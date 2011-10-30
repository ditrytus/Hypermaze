//
//  HPLogic.h
//  Hypermaze
//
//  Created by Jakub Gruszecki on 29.07.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HPMaze.h"
#import "HPGameState.h"
#import "HPVisitedMask.h"
#import "HPTool.h"
#import	"HPXAxisMask.h"
#import "HPYAxisMask.h"
#import "HPZAxisMask.h"
#import "HPRecursiveMask.h"
#import "HPUntakenCrossroadsMask.h"
#import "HPMarkMask.h"
#import "HPRangeTool.h"
#import "HPAriadnaMask.h"

#define EVENT_MOVEMENT_CANCELED @"hpLogicMovementCanceledEvent"
#define EVENT_ROTATED @"hpLogicRotatedEvent"
#define EVENT_POSITION_CHANGED @"hpLogicPositionChangedEvent"
#define EVENT_VIEW_CHANGED @"hpLogicviewChangedEvent"
#define EVENT_MAZE_FINISHED @"hpLogicMazeFinished"

@interface HPLogic : NSObject<NSCoding> {
	NSDate* beginDate;
	
	HPMaze* maze;
	HPGameState* gameState;
	
	HPVisibilityMask* visibilityMask;
	HPMarkMask* markMask;
	HPVisitedMask* visitedMask;
	HPAriadnaMask* ariadnaMask;
	HPRecursiveMask* recursiveMask;
	
	HPTool* visitedTool;
	HPTool* xAxisTool;
	HPTool* yAxisTool;
	HPTool* zAxisTool;
	HPRangeTool* recursiveTool;
	HPTool* untakenTool;
	HPTool* ariadnaTool;
	HPTool* mazeTool;
	HPRangeTool* checkpointTool;
	
	bool showBorders;
	bool showCompass;
	bool showTarget;
	int rotation;
	
	NSArray* movementHandlers;
}

- (id) initWithMaze:(HPMaze*) newMaze;
- (void) moveInDirection: (HPDirection) dir;

@property (readonly, nonatomic) NSDate* beginDate;

@property (readonly, nonatomic) HPMaze* maze;
@property (readonly, nonatomic) HPGameState* gameState;
@property (readonly, nonatomic) HPVisibilityMask* visibilityMask;
@property (readonly, nonatomic) HPMarkMask* markMask;

@property (readonly, nonatomic) HPTool* visitedTool;
@property (readonly, nonatomic) HPTool* xAxisTool;
@property (readonly, nonatomic) HPTool* yAxisTool;
@property (readonly, nonatomic) HPTool* zAxisTool;
@property (readonly, nonatomic) HPRangeTool* recursiveTool;
@property (readonly, nonatomic) HPTool* untakenTool;
@property (readonly, nonatomic) HPTool* ariadnaTool;
@property (readonly, nonatomic) HPTool* mazeTool;
@property (readonly, nonatomic) HPRangeTool* checkpointTool;

@property (readonly, nonatomic) bool showBorders;
@property (readonly, nonatomic) bool showCompass;
@property (readonly, nonatomic) bool showTarget;
@property (readonly, nonatomic) int rotation;

- (void) toggleAriadnaTool;
- (void) toggleVisitedTool;
- (void) toggleCheckpointTool;
- (void) toggleUntakenTool;
- (void) toggleMarkMask;
- (void) toggleXAxisTool;
- (void) toggleYAxisTool;
- (void) toggleZAxisTool;
- (void) toggleRecursiveTool;
- (void) toggleMazeTool;

- (void) toggleBorders;
- (void) toggleCompass;
- (void) toggleTarget;

- (void) setCheckpointNumber: (int) num;
- (void) setRecursionDepth: (int) num;

- (void) rotateClockwise;
- (void) rotateCounterclockwise;

- (void) reset;

- (int) getNumOfVisited;
- (int) getTotalChambers;

- (int) getScore;

@end
