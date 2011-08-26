//
//  HPGameState.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 30.07.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HPGameState.h"
#import "HPDirectionUtil.h"

@implementation HPGameState

@synthesize movesMade;
@synthesize currentPosition;
@synthesize hasFinished;

- (id)init
{
    self = [super init];
    if (self) {
        movesMade = 0;
		lastResume = [NSDate date];
		hasFinished = NO;
		currentPosition = BEGIN_POINT;
		previousTimeElapsed = 0;
    }
    return self;
}

- (NSTimeInterval) getTimeElapsed {
	return previousTimeElapsed + [lastResume timeIntervalSinceNow];
}

- (void) handleMove: (HPDirection) dir {
	movesMade++;
	currentPosition = [HPDirectionUtil moveInDirection:dir fromPoint:currentPosition];
}

@end
