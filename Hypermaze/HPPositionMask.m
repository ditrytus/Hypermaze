//
//  HPPositionMask.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 21.08.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HPPositionMask.h"

@implementation HPPositionMask

- (id)initWithGameState: (HPGameState*) state
{
    self = [super init];
    if (self) {
        gameState = state;
    }
    return self;
}

- (NSNumber*) getValue: (FS3DPoint) position {
	FS3DPoint currentPosition = gameState.currentPosition;
	return [NSNumber numberWithBool: currentPosition.x == position.x && currentPosition.y == position.y && currentPosition.z == position.z];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[super encodeWithCoder:encoder];
	[encoder encodeConditionalObject: gameState forKey:@"gameState"];
}

- (id) initWithCoder:(NSCoder *)decoder {
	self = [super initWithCoder:decoder];
	gameState = [decoder decodeObjectForKey:@"gameState"];
	return self;
}

- (void) dealloc {
	[super dealloc];
}


@end
