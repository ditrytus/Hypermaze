//
//  HPVisitedMask.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 21.08.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HPVisitedMask.h"

@implementation HPVisitedMask

@synthesize  numOfVisited;

- (void) markPositionAsVisited {
	if (array[gameState.currentPosition.x][gameState.currentPosition.y][gameState.currentPosition.z] == false) {
		numOfVisited++;
	}
	array[gameState.currentPosition.x][gameState.currentPosition.y][gameState.currentPosition.z] = true;
}

- (id)initWithSize: (int) size gameState:(HPGameState*) state
{
    self = [super initWithSize:size];
    if (self) {
		numOfVisited = 0;
		gameState = [state retain];
		[self markPositionAsVisited];
    }
    
    return self;
}

- (void) handleMove: (HPDirection) dir {
	[self markPositionAsVisited];
}

-(void) dealloc {
	[gameState release];
	[super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[super encodeWithCoder:encoder];
	[encoder encodeInt32:numOfVisited forKey:@"numOfVisited"];
	[encoder encodeObject:gameState forKey:@"gameState"];
}

- (id) initWithCoder:(NSCoder *)decoder {
	self = [super initWithCoder:decoder];
	numOfVisited = [decoder decodeInt32ForKey:@"numOfVisited"];
	gameState = [[decoder decodeObjectForKey:@"gameState"] retain];
	return self;
}


@end
