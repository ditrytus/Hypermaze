//
//  HPAriadnaMask.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 26.08.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HPAriadnaMask.h"
#import "HPDirectionUtil.h"
#import "HPGlobals.h"

@implementation HPAriadnaMask

- (id)initWithGameState: (HPGameState*) state
{
    self = [super init];
    if (self) {
		gameState = state;
		[self addToPath: gameState.currentPosition];
    }
    
    return self;
}

- (void) handleMove: (HPDirection) dir {
	if([self contains:gameState.currentPosition]) {
		[path removeLastObject];
	} else {
		[self addToPath:gameState.currentPosition];
	}
}

-(void) dealloc {
	[super dealloc];
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

- (void) reset {
	[path removeAllObjects];
	[self addToPath: gameState.currentPosition];
}

@end
