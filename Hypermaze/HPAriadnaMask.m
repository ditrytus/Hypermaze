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
		gameState = [state retain];
		[self addToPath:BEGIN_POINT];
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
	[gameState release];
	[super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[super encodeWithCoder:encoder];
	[encoder encodeObject:gameState forKey:@"gameState"];
}

- (id) initWithCoder:(NSCoder *)decoder {
	self = [super initWithCoder:decoder];
	gameState = [[decoder decodeObjectForKey:@"gameState"] retain];
	return self;
}

@end
