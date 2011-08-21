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

#define EVENT_MOVEMENT_CANCELED @"hpLogicMovementCanceledEvent"
#define EVENT_POSITION_CHANGED @"hpLogicpositionChangedEvent"
#define EVENT_VIEW_CHANGED @"hpLogicviewChangedEvent"

@interface HPLogic : NSObject {
	HPMaze* maze;
	HPGameState* gameState;
	HPVisibilityMask* visibilityMask;
	HPTool* visitedTool;
	HPTool* xAxisTool;
	HPTool* yAxisTool;
	HPTool* zAxisTool;
	HPTool* recursiveTool;
	NSArray* movementHandlers;
}

- (id) initWithMaze:(HPMaze*) newMaze;
- (void) moveInDirection: (HPDirection) dir;

@property (readonly, nonatomic) HPMaze* maze;
@property (readonly, nonatomic) HPGameState* gameState;
@property (readonly, nonatomic) HPVisibilityMask* visibilityMask;

- (void) toggleVisitedTool;
- (void) toggleXAxisTool;
- (void) toggleYAxisTool;
- (void) toggleZAxisTool;
- (void) toggleRecursiveTool;

@end
