//
//  HPGameState.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 30.07.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HPGameState.h"
#import "HPDirectionUtil.h"
#import "HPGlobals.h"

@implementation HPGameState

@synthesize movesMade;
@synthesize currentPosition;
@synthesize hasFinished;

- (id) initWithMovesMade: (int) moves
			 lastResume: (NSDate*) date
			hasFinished: (bool) finished
		currentPosition: (FS3DPoint) point
	previousTimeElapsed: (int) prevElapsed {
	self = [super init];
    if (self) {
        movesMade = moves;
		lastResume = [date retain];
		hasFinished = finished;
		currentPosition = point;
		previousTimeElapsed = prevElapsed;
    }
    return self;
}

- (id)init
{
    self = [self initWithMovesMade:0
						lastResume:[NSDate date]
					   hasFinished:NO
				   currentPosition:BEGIN_POINT
			   previousTimeElapsed:0];
    return self;
}

- (NSTimeInterval) getTimeElapsed {
	return previousTimeElapsed - [lastResume timeIntervalSinceNow];
}

- (void) handleMove: (HPDirection) dir {
	movesMade++;
	currentPosition = [HPDirectionUtil moveInDirection:dir fromPoint:currentPosition];
}

- (void) dealloc {
	[lastResume release];
	[super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeInt32:movesMade forKey:@"movesMade"];
	[encoder encodeDouble:previousTimeElapsed forKey:@"previousTimeElapsed"];
	[encoder encodeObject:
	[NSData dataWithBytes: &currentPosition length:sizeof(currentPosition)]
				   forKey:@"currentPosition"];
}

- (id) initWithCoder:(NSCoder *)decoder {
	FS3DPoint position;
	[[((NSData*)[decoder decodeObjectForKey:@"currentPosition"]) autorelease] getBytes:&position];
	NSLog(@"%@",[[self class] description]);
	return [[HPGameState alloc] initWithMovesMade: [decoder decodeInt32ForKey:@"movesMade"]
									   lastResume: [NSDate date]
									  hasFinished: NO
								  currentPosition: position
							  previousTimeElapsed: [decoder decodeDoubleForKey:@"previousTimeElapsed"]];
}

- (void) reset {
	currentPosition = BEGIN_POINT;
}

@end
