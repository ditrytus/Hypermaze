//
//  HPLogic.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 29.07.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HPLogic.h"
#import "HPChamberUtil.h"
#import "HPUnionMaskComposite.h"
#import "HPIntersectionMaskComposite.h"
#import "HPVisibilityMaskManipulationTool.h"
#import "HPPositionMask.h"
#import "HPAriadnaMask.h"
#import "HPCheckpointMask.h"
#import "HPRangeTool.h"

@implementation HPLogic

@synthesize beginDate;
@synthesize maze;
@synthesize gameState;
@synthesize visibilityMask;
@synthesize markMask;
@synthesize checkpointTool;
@synthesize recursiveTool;
@synthesize showBorders;
@synthesize showCompass;
@synthesize showTarget;
@synthesize rotation;
@synthesize visitedTool;
@synthesize xAxisTool;
@synthesize yAxisTool;
@synthesize zAxisTool;
@synthesize untakenTool;
@synthesize ariadnaTool;
@synthesize mazeTool;

- (id)initWithBeginDate: (NSDate*) newBeginDate
				   maze: (HPMaze *) newMaze
			  gameState: (HPGameState*) newGameState
		 visibilityMask: (HPVisibilityMask*) newVisibilityMask
			   markMask: (HPMarkMask*) newMarkMask
			visitedMask: (HPVisitedMask*) newVisitedMask
			ariadnaMask: (HPAriadnaMask*) newAriadnaMask
		  recursiveMask: (HPRecursiveMask*) newRecursiveMask
			visitedTool: (HPTool*) newVisitedTool
			  xAxisTool: (HPTool*) newXAxisTool
			  yAxisTool: (HPTool*) newYAxisTool
			  zAxisTool: (HPTool*) newZAxisTool
		  recursiveTool: (HPRangeTool*) newRecursiveTool	
			untakenTool: (HPTool*) newUntakenTool
			ariadnaTool: (HPTool*) newAriadnaTool
			   mazeTool: (HPTool*) newMazeTool
		 checkpointTool: (HPRangeTool*) newCheckpointTool
			showBorders: (bool) newShowBorders
			showCompass: (bool) newShowCompass
			 showTarget: (bool) newShowTarget
			   rotation: (int) newRotation 
	   movementHandlers: (NSArray*) newMovementHandlers {
	self = [super init];
    if (self) {
		beginDate = [newBeginDate retain];
		maze = [newMaze retain];
		gameState = [newGameState retain];
		visibilityMask = [newVisibilityMask retain];
		markMask = [newMarkMask retain];
		visitedMask = [newVisitedMask retain];
		ariadnaMask = [newAriadnaMask retain];
		recursiveMask = [newRecursiveMask retain];
		visitedTool = [newVisitedTool retain];
		xAxisTool = [newXAxisTool retain];
		yAxisTool = [newYAxisTool retain];
		zAxisTool = [newZAxisTool retain];
		recursiveTool = [newRecursiveTool retain];
		untakenTool = [newUntakenTool retain];
		ariadnaTool = [newAriadnaTool retain];
		mazeTool = [newMazeTool retain];
		checkpointTool = [newCheckpointTool retain];
		showBorders = newShowBorders;
		showCompass	= newShowCompass;
		showTarget = newShowTarget;
		rotation = newRotation;
		movementHandlers = [newMovementHandlers retain];
	}
	return self;
}

- (id)initWithMaze:(HPMaze*) newMaze {
	
	HPGameState* newGameState = [[[HPGameState alloc] initWithMaze:newMaze] autorelease];
	
	HPPositionMask* positionMask = [[[HPPositionMask alloc] initWithGameState: newGameState] autorelease];
	
	HPAriadnaMask* newAriadnaMask = [[[HPAriadnaMask alloc] initWithGameState: newGameState] autorelease];
	HPVisitedMask* newVisitedMask = [[[HPVisitedMask alloc] initWithSize:[newMaze size] gameState:newGameState] autorelease];
	HPUntakenCrossroadsMask* untakenMask = [[[HPUntakenCrossroadsMask alloc] initWithVisted:newVisitedMask Maze:newMaze] autorelease];
	HPCheckpointMask* checkPointMask = [[[HPCheckpointMask alloc] initWithMaze:newMaze numOfCheckPoints:3]  autorelease];
	
	HPUnionMaskComposite* brainComposite = [[[HPUnionMaskComposite alloc] initWithMasks: newAriadnaMask, newVisitedMask, untakenMask, checkPointMask, nil] autorelease];
	
	HPXAxisMask* xAxisMask = [[[HPXAxisMask alloc] initWithGameState:newGameState] autorelease];
	HPYAxisMask* yAxisMask = [[[HPYAxisMask alloc] initWithGameState:newGameState] autorelease];
	HPZAxisMask* zAxisMask = [[[HPZAxisMask alloc] initWithGameState:newGameState] autorelease];
	HPRecursiveMask* newRecursiveMask = [[[HPRecursiveMask alloc] initWithGameState: newGameState maze:newMaze depth:5] autorelease];
	
	HPVisibilityMask* mazeMask = [[[HPVisibilityMask alloc] init] autorelease];
	
	HPUnionMaskComposite* axisComposite = [[[HPUnionMaskComposite alloc] initWithMasks:xAxisMask, yAxisMask, zAxisMask, nil] autorelease];
	HPIntersectionMaskComposite* planesComposite = [[[HPIntersectionMaskComposite alloc] initWithMasks:axisComposite, newRecursiveMask,nil] autorelease];
	
	HPUnionMaskComposite* newVisibilityMask = [[[HPUnionMaskComposite alloc] initWithMasks:positionMask, brainComposite, planesComposite, mazeMask, nil] autorelease];

	int maxNumOfCheckpoints = [newMaze.solution count] / 50;
	if (maxNumOfCheckpoints > 10) {
		maxNumOfCheckpoints = 10;
	}
	if (maxNumOfCheckpoints < 1) {
		maxNumOfCheckpoints	= 1;
	}
	
	return [self initWithBeginDate: [NSDate date]
							  maze: newMaze 
						 gameState: newGameState
					visibilityMask: newVisibilityMask 
						  markMask: [[[HPMarkMask alloc] initWithUntaken:untakenMask visited:newVisitedMask ariadna:ariadnaMask checkpoint:checkPointMask] autorelease] 
					   visitedMask: newVisitedMask 
					   ariadnaMask: newAriadnaMask
					 recursiveMask: newRecursiveMask
					   visitedTool: [[[HPVisibilityMaskManipulationTool alloc] initWithMask:newVisitedMask composite:brainComposite] autorelease] 
						 xAxisTool: [[[HPVisibilityMaskManipulationTool alloc] initWithMask:xAxisMask composite:axisComposite] autorelease] 
						 yAxisTool: [[[HPVisibilityMaskManipulationTool alloc] initWithMask:yAxisMask composite:axisComposite] autorelease] 
						 zAxisTool: [[[HPVisibilityMaskManipulationTool alloc] initWithMask:zAxisMask composite:axisComposite] autorelease] 
					 recursiveTool: [[[HPRangeTool alloc] initWithMask:newRecursiveMask composite:planesComposite minValue:1 maxValue:10 initialValue:5] autorelease] 
					   untakenTool: [[[HPVisibilityMaskManipulationTool alloc] initWithMask:untakenMask composite:brainComposite] autorelease]
					   ariadnaTool: [[[HPVisibilityMaskManipulationTool alloc] initWithMask:newAriadnaMask composite:brainComposite] autorelease] 
						  mazeTool: [[[HPVisibilityMaskManipulationTool alloc] initWithMask:mazeMask composite:newVisibilityMask] autorelease]
					checkpointTool: [[[HPRangeTool alloc] initWithMask:checkPointMask composite:brainComposite minValue:1 maxValue:maxNumOfCheckpoints initialValue:5] autorelease] 
					   showBorders: false 
					   showCompass: false 
						showTarget: false 
						  rotation: 0 
			 movementHandlers:[NSArray arrayWithObjects:newGameState, newVisitedMask, newAriadnaMask, newRecursiveMask, nil]];
}

- (void) dealloc {
	[maze release];
	[gameState release];
	[visibilityMask release];
	[ariadnaTool release];
	[untakenTool release];
	[recursiveTool release];
	[xAxisTool release];
	[yAxisTool release];
	[zAxisTool release];
	[visitedTool release];
	[movementHandlers release];
	[markMask release];
	[visitedMask release];
	[ariadnaMask release];
	[super dealloc];
}

- (void)raisePostionChangedEvent:(FS3DPoint)currentPosition previousPosition:(FS3DPoint)previousPosition  {
	NSDictionary* eventData = [NSDictionary dictionaryWithObjectsAndKeys: [NSData dataWithBytes: &previousPosition length:sizeof(previousPosition)] ,@"previousPosition", [NSData dataWithBytes: &currentPosition length:sizeof(currentPosition)],@"currentPosition", nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:EVENT_POSITION_CHANGED object:self userInfo: eventData];
}
- (void) moveInDirection: (HPDirection) dir {
	if ([HPChamberUtil canGoInDirection:dir fromChamber:maze.topology[gameState.currentPosition.x][gameState.currentPosition.y][gameState.currentPosition.z] currentPosition:gameState.currentPosition size: maze.size]) {
		FS3DPoint previousPosition = [gameState currentPosition];
		for (int i=0; i<[movementHandlers count]; i++) {
			[((id<HPMoveHandler>)[movementHandlers objectAtIndex:i]) handleMove:dir];
		}
		FS3DPoint currentPosition = [gameState currentPosition];
		if (gameState.hasFinished) {
			[[NSNotificationCenter defaultCenter] postNotificationName:EVENT_MAZE_FINISHED object:self];
		} else {
			[self raisePostionChangedEvent: currentPosition previousPosition: previousPosition];
		}

	} else {
		[[NSNotificationCenter defaultCenter] postNotificationName: EVENT_MOVEMENT_CANCELED object:self];
	}
}

- (int) getNumOfVisited {
	return visitedMask.numOfVisited;
}

- (int) getTotalChambers {
	return pow(maze.size, 3);
}

- (void) toggleAriadnaTool {
	[ariadnaTool toggle];
	[[NSNotificationCenter defaultCenter] postNotificationName: EVENT_VIEW_CHANGED object:self];
}

- (void) toggleVisitedTool {
	[visitedTool toggle];
	[[NSNotificationCenter defaultCenter] postNotificationName: EVENT_VIEW_CHANGED object:self];
}

- (void) toggleUntakenTool {
	[untakenTool toggle];
	[[NSNotificationCenter defaultCenter] postNotificationName: EVENT_VIEW_CHANGED object:self];
}

- (void) toggleCheckpointTool {
	[checkpointTool toggle];
	[[NSNotificationCenter defaultCenter] postNotificationName: EVENT_VIEW_CHANGED object:self];
}

- (void) toggleMarkMask {
	[markMask toggle];
	[[NSNotificationCenter defaultCenter] postNotificationName: EVENT_VIEW_CHANGED object:self];
}

- (void) toggleXAxisTool {
	[xAxisTool toggle];
	[[NSNotificationCenter defaultCenter] postNotificationName: EVENT_VIEW_CHANGED object:self];
}

- (void) toggleYAxisTool {
	[yAxisTool toggle];
	[[NSNotificationCenter defaultCenter] postNotificationName: EVENT_VIEW_CHANGED object:self];
}

- (void) toggleZAxisTool {
	[zAxisTool toggle];
	[[NSNotificationCenter defaultCenter] postNotificationName: EVENT_VIEW_CHANGED object:self];
}

- (void) toggleRecursiveTool {
	[recursiveTool toggle];
	[[NSNotificationCenter defaultCenter] postNotificationName: EVENT_VIEW_CHANGED object:self];
}

- (void) toggleMazeTool {
	[mazeTool toggle];
	[[NSNotificationCenter defaultCenter] postNotificationName: EVENT_VIEW_CHANGED object:self];
}

- (void) setCheckpointNumber: (int) num {
	[checkpointTool setValue: num];
	[[NSNotificationCenter defaultCenter] postNotificationName: EVENT_VIEW_CHANGED object:self];
}

- (void) setRecursionDepth: (int) num {
	[recursiveTool setValue: num];
	[[NSNotificationCenter defaultCenter] postNotificationName: EVENT_VIEW_CHANGED object:self];
}

- (void) toggleBorders {
	showBorders = !showBorders;
	[[NSNotificationCenter defaultCenter] postNotificationName: EVENT_VIEW_CHANGED object:self];
}

- (void) toggleCompass {
	showCompass = !showCompass;
	[[NSNotificationCenter defaultCenter] postNotificationName: EVENT_VIEW_CHANGED object:self];
}

- (void) toggleTarget {
	showTarget = !showTarget;
	[[NSNotificationCenter defaultCenter] postNotificationName: EVENT_VIEW_CHANGED object:self];
}

- (void) rotateClockwise {
	rotation = (rotation - 1) % 4;
	if (rotation < 0) {
		rotation = rotation + 4;
	}
	FS3DPoint currentPosition = [gameState currentPosition];
	[self raisePostionChangedEvent: currentPosition previousPosition: currentPosition];
}

- (void) rotateCounterclockwise {
	rotation = (rotation + 1) % 4;
	FS3DPoint currentPosition = [gameState currentPosition];
	[self raisePostionChangedEvent: currentPosition previousPosition: currentPosition];
}

- (void) reset {
	FS3DPoint prevPos = gameState.currentPosition;
	[gameState reset];
	FS3DPoint curPos = gameState.currentPosition;
	[visitedMask reset];
	[ariadnaMask reset];
	[recursiveMask refresh];
	[self raisePostionChangedEvent: curPos previousPosition:prevPos];
}

- (int) getScore {
	return (pow(maze.size, 3) - gameState.movesMade) / ([gameState getTimeElapsed] / 60.0);
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:beginDate forKey:@"beginDate"];
	
	[encoder encodeObject:maze forKey:@"maze"];
	[encoder encodeObject:gameState forKey:@"gameState"];
	
	[encoder encodeObject:visibilityMask forKey:@"visibilityMask"];
	[encoder encodeObject:markMask forKey:@"markMask"];
	[encoder encodeObject:visitedMask forKey:@"visitedMask"];
	[encoder encodeObject:ariadnaMask forKey:@"ariadnaMask"];
	[encoder encodeObject:recursiveMask forKey:@"recursiveMask"];
	
	[encoder encodeObject:visitedTool forKey:@"visitedTool"];
	[encoder encodeObject:xAxisTool forKey:@"xAxisTool"];
	[encoder encodeObject:yAxisTool forKey:@"yAxisTool"];
	[encoder encodeObject:zAxisTool forKey:@"zAxisTool"];
	[encoder encodeObject:recursiveTool forKey:@"recursiveTool"];
	[encoder encodeObject:untakenTool forKey:@"untakenTool"];
	[encoder encodeObject:ariadnaTool forKey:@"ariadnaTool"];
	[encoder encodeObject:mazeTool forKey:@"mazeTool"];
	[encoder encodeObject:checkpointTool forKey:@"checkpointTool"];
	
	[encoder encodeBool:showBorders forKey:@"showBorders"];
	[encoder encodeBool:showCompass forKey:@"showCompass"];
	[encoder encodeBool:showTarget forKey:@"showTarget"];
	[encoder encodeInt32:rotation forKey:@"rotation"];
	
	[encoder encodeObject:movementHandlers forKey:@"movementHandlers"];
}

- (id) initWithCoder:(NSCoder *)decoder {
	return [self initWithBeginDate: [decoder decodeObjectForKey:@"beginDate"]
							  maze: [decoder decodeObjectForKey:@"maze"] 
						 gameState: [decoder decodeObjectForKey:@"gameState"] 
					visibilityMask: [decoder decodeObjectForKey:@"visibilityMask"]  
						  markMask: [decoder decodeObjectForKey:@"markMask"] 
					   visitedMask: [decoder decodeObjectForKey:@"visitedMask"]  
					   ariadnaMask: [decoder decodeObjectForKey:@"ariadnaMask"]
					 recursiveMask: [decoder decodeObjectForKey:@"recursiveMask"]
					   visitedTool: [decoder decodeObjectForKey:@"visitedTool"]  
						 xAxisTool: [decoder decodeObjectForKey:@"xAxisTool"]  
						 yAxisTool: [decoder decodeObjectForKey:@"yAxisTool"]  
						 zAxisTool: [decoder decodeObjectForKey:@"zAxisTool"]  
					 recursiveTool: [decoder decodeObjectForKey:@"recursiveTool"]  
					   untakenTool: [decoder decodeObjectForKey:@"untakenTool"]  
					   ariadnaTool: [decoder decodeObjectForKey:@"ariadnaTool"]  
						  mazeTool: [decoder decodeObjectForKey:@"mazeTool"]  
					checkpointTool: [decoder decodeObjectForKey:@"checkpointTool"]  
					   showBorders: [decoder decodeBoolForKey:@"showBorders"] 
					   showCompass: [decoder decodeBoolForKey:@"showCompass"]  
						showTarget: [decoder decodeBoolForKey:@"showTarget"]  
						  rotation: [decoder decodeInt32ForKey:@"rotation"] 
				  movementHandlers: [decoder decodeObjectForKey:@"movementHandlers"]];
}

@end
