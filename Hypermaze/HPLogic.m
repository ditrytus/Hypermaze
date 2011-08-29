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

@synthesize maze;
@synthesize gameState;
@synthesize visibilityMask;
@synthesize markMask;
@synthesize checkpointTool;
@synthesize recursiveTool;

- (id)initWithMaze:(HPMaze*) newMaze;
{
    self = [super init];
    if (self) {
		maze = [newMaze retain];
		gameState = [[HPGameState alloc] init];
		
		HPPositionMask* positionMask = [[[HPPositionMask alloc] initWithGameState: gameState] autorelease];
	
		HPAriadnaMask* ariadnaMask = [[[HPAriadnaMask alloc] initWithGameState: gameState] autorelease];
		HPVisitedMask* visitedMask = [[[HPVisitedMask alloc] initWithSize:[maze size] gameState:gameState] autorelease];
		HPUntakenCrossroadsMask* untakenMask = [[[HPUntakenCrossroadsMask alloc] initWithVisted:visitedMask Maze:maze] autorelease];
		HPCheckpointMask* checkPointMask = [[[HPCheckpointMask alloc] initWithMaze:maze numOfCheckPoints:3]  autorelease];
		
		HPUnionMaskComposite* brainComposite = [[[HPUnionMaskComposite alloc] initWithMasks: ariadnaMask, visitedMask, untakenMask, checkPointMask, nil] autorelease];
		
		HPXAxisMask* xAxisMask = [[[HPXAxisMask alloc] initWithGameState:gameState] autorelease];
		HPYAxisMask* yAxisMask = [[[HPYAxisMask alloc] initWithGameState:gameState] autorelease];
		HPZAxisMask* zAxisMask = [[[HPZAxisMask alloc] initWithGameState:gameState] autorelease];
		HPRecursiveMask* recursiveMask = [[[HPRecursiveMask alloc] initWithGameState:gameState maze:maze depth:5] autorelease];
		
		HPVisibilityMask* mazeMask = [[[HPVisibilityMask alloc] init] autorelease];
		
		HPUnionMaskComposite* axisComposite = [[[HPUnionMaskComposite alloc] initWithMasks:xAxisMask, yAxisMask, zAxisMask, nil] autorelease];
		HPIntersectionMaskComposite* planesComposite = [[[HPIntersectionMaskComposite alloc] initWithMasks:axisComposite, recursiveMask,nil] autorelease];
		
		HPUnionMaskComposite* composite = [[[HPUnionMaskComposite alloc] initWithMasks:positionMask, brainComposite, planesComposite, mazeMask, nil] autorelease];
		
		ariadnaTool	= [[HPVisibilityMaskManipulationTool alloc] initWithMask:ariadnaMask composite:brainComposite];
		visitedTool = [[HPVisibilityMaskManipulationTool alloc] initWithMask:visitedMask composite:brainComposite];
		untakenTool = [[HPVisibilityMaskManipulationTool alloc] initWithMask:untakenMask composite:brainComposite];
		int maxNumOfCheckpoints = [maze.solution count] / 50;
		if (maxNumOfCheckpoints > 10) {
			maxNumOfCheckpoints = 10;
		}
		if (maxNumOfCheckpoints < 1) {
			maxNumOfCheckpoints	= 1;
		}
		checkpointTool = [[HPRangeTool alloc] initWithMask:checkPointMask composite:brainComposite minValue:1 maxValue:maxNumOfCheckpoints initialValue:5];
		xAxisTool = [[HPVisibilityMaskManipulationTool alloc] initWithMask:xAxisMask composite:axisComposite];
		yAxisTool = [[HPVisibilityMaskManipulationTool alloc] initWithMask:yAxisMask composite:axisComposite];
		zAxisTool = [[HPVisibilityMaskManipulationTool alloc] initWithMask:zAxisMask composite:axisComposite];
		recursiveTool = [[HPRangeTool alloc] initWithMask:recursiveMask composite:planesComposite minValue:1 maxValue:10 initialValue:5];
		mazeTool = [[HPVisibilityMaskManipulationTool alloc] initWithMask:mazeMask composite:composite];
		visibilityMask = [composite retain];
		markMask = [[HPMarkMask alloc] initWithUntaken:untakenMask visited:visitedMask ariadna:ariadnaMask checkpoint:checkPointMask];
		movementHandlers = [[NSArray arrayWithObjects:gameState, visitedMask, ariadnaMask, recursiveMask, nil] retain];
    }
    return self;
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
	[super dealloc];
}

- (void) moveInDirection: (HPDirection) dir {
	if ([HPChamberUtil canGoInDirection:dir fromChamber:maze.topology[gameState.currentPosition.x][gameState.currentPosition.y][gameState.currentPosition.z] currentPosition:gameState.currentPosition size: maze.size]) {
		FS3DPoint previousPosition = [gameState currentPosition];
		for (int i=0; i<[movementHandlers count]; i++) {
			[((id<HPMoveHandler>)[movementHandlers objectAtIndex:i]) handleMove:dir];
		}
		FS3DPoint currentPosition = [gameState currentPosition];
		NSDictionary* eventData = [NSDictionary dictionaryWithObjectsAndKeys: [NSData dataWithBytes: &previousPosition length:sizeof(previousPosition)] ,@"previousPosition", [NSData dataWithBytes: &currentPosition length:sizeof(currentPosition)],@"currentPosition", nil];
		[[NSNotificationCenter defaultCenter] postNotificationName:EVENT_POSITION_CHANGED object:self userInfo: eventData];
	} else {
		[[NSNotificationCenter defaultCenter] postNotificationName: EVENT_MOVEMENT_CANCELED object:self];
	}
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

@end
