//
//  HPLogic.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 29.07.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HPLogic.h"
#import "HPChamberUtil.h"

@implementation HPLogic

@synthesize maze;
@synthesize gameState;

- (id)initWithMaze:(HPMaze*) newMaze;
{
    self = [super init];
    if (self) {
		maze = [newMaze retain];
		gameState = [[HPGameState alloc] init];
    }
    return self;
}

- (void) dealloc {
	[maze release];
	[gameState release];
	[super dealloc];
}

- (void) moveInDirection: (HPDirection) dir {
	if ([HPChamberUtil canGoInDirection:dir fromChamber:maze.topology[gameState.currentPosition.x][gameState.currentPosition.y][gameState.currentPosition.z] currentPosition:gameState.currentPosition size: maze.size]) {
		FS3DPoint previousPosition = [gameState currentPosition];
		[gameState handleMove:dir];
		FS3DPoint currentPosition = [gameState currentPosition];
		NSDictionary* eventData = [NSDictionary dictionaryWithObjectsAndKeys: [NSData dataWithBytes: &previousPosition length:sizeof(previousPosition)] ,@"previousPosition", [NSData dataWithBytes: &currentPosition length:sizeof(currentPosition)],@"currentPosition", nil];
		[[NSNotificationCenter defaultCenter] postNotificationName:EVENT_POSITION_CHANGED object:self userInfo: eventData];
	} else {
		[[NSNotificationCenter defaultCenter] postNotificationName: EVENT_MOVEMENT_CANCELED object:self];
	}
}

@end
