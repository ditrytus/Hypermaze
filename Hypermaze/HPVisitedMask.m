//
//  HPVisitedMask.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 21.08.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HPVisitedMask.h"

@implementation HPVisitedMask

- (id)initWithSize: (int) size gameState:(HPGameState*) state
{
    self = [super initWithSize:size];
    if (self) {
        array[0][0][0] = true;
		gameState = [state retain];
    }
    
    return self;
}

- (void) handleMove: (HPDirection) dir {
	array[gameState.currentPosition.x][gameState.currentPosition.y][gameState.currentPosition.z] = true;
}

-(void) dealloc {
	[gameState release];
	[super dealloc];
}

@end
