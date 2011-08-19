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

#define EVENT_MOVEMENT_CANCELED @"movementCanceled"
#define EVENT_POSITION_CHANGED @"positionChanged"

@interface HPLogic : NSObject {
	HPMaze* maze;
	HPGameState* gameState;
}

- (id) initWithMaze:(HPMaze*) newMaze;
- (void) moveInDirection: (HPDirection) dir;

@property (readonly, nonatomic) HPMaze* maze;
@property (readonly, nonatomic) HPGameState* gameState;

@end
