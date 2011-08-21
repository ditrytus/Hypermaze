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

@implementation HPLogic

@synthesize maze;
@synthesize gameState;
@synthesize visibilityMask;

- (id)initWithMaze:(HPMaze*) newMaze;
{
    self = [super init];
    if (self) {
		maze = [newMaze retain];
		gameState = [[HPGameState alloc] init];
		HPPositionMask* positionMask = [[[HPPositionMask alloc] initWithGameState: gameState] autorelease];
		HPVisitedMask* visitedMask = [[[HPVisitedMask alloc] initWithSize:[maze size] gameState:gameState] autorelease];
		HPXAxisMask* xAxisMask = [[[HPXAxisMask alloc] initWithGameState:gameState] autorelease];
		HPYAxisMask* yAxisMask = [[[HPYAxisMask alloc] initWithGameState:gameState] autorelease];
		HPZAxisMask* zAxisMask = [[[HPZAxisMask alloc] initWithGameState:gameState] autorelease];
		HPRecursiveMask* recursiveMask = [[[HPRecursiveMask alloc] initWithGameState:gameState maze:maze depth:5] autorelease];
		HPUnionMaskComposite* axisComposite = [[[HPUnionMaskComposite alloc] initWithMasks:xAxisMask, yAxisMask, zAxisMask, nil] autorelease];
		HPIntersectionMaskComposite* planesComposite = [[[HPIntersectionMaskComposite alloc] initWithMasks:axisComposite, recursiveMask,nil] autorelease];
		HPUnionMaskComposite* composite = [[[HPUnionMaskComposite alloc] initWithMasks:positionMask, visitedMask, planesComposite,nil] autorelease];
		visitedTool = [[HPVisibilityMaskManipulationTool alloc] initWithMask:visitedMask composite:composite];
		xAxisTool = [[HPVisibilityMaskManipulationTool alloc] initWithMask:xAxisMask composite:axisComposite];
		yAxisTool = [[HPVisibilityMaskManipulationTool alloc] initWithMask:yAxisMask composite:axisComposite];
		zAxisTool = [[HPVisibilityMaskManipulationTool alloc] initWithMask:zAxisMask composite:axisComposite];
		recursiveTool = [[HPVisibilityMaskManipulationTool alloc] initWithMask:recursiveMask composite:planesComposite];
		visibilityMask = [composite retain];
		movementHandlers = [[NSArray arrayWithObjects:gameState, visitedMask, recursiveMask, nil] retain];
    }
    return self;
}

- (void) dealloc {
	[maze release];
	[gameState release];
	[visibilityMask release];
	[xAxisTool release];
	[yAxisTool release];
	[zAxisTool release];
	[visitedTool release];
	[movementHandlers release];
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

- (void) toggleVisitedTool {
	[visitedTool toggle];
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

@end
