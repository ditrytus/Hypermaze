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

- (id) initWithMaze: (HPMaze*) _maze
		  movesMade: (int) moves
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
		maze = [_maze retain];
    }
    return self;
}

- (id)initWithMaze: (HPMaze*) _maze
{
    self = [self initWithMaze: _maze
					movesMade: 0
				   lastResume: [NSDate date]
				  hasFinished: NO
			  currentPosition: BEGIN_POINT
		  previousTimeElapsed: 0];
    return self;
}

- (NSTimeInterval) getTimeElapsed {
	if (hasFinished) {
		return previousTimeElapsed - [lastResume timeIntervalSinceNow];
	} else {
		return finishTimeElapsed;
	}
}

- (void) handleMove: (HPDirection) dir {
	movesMade++;
	currentPosition = [HPDirectionUtil moveInDirection:dir fromPoint:currentPosition];
	FS3DPoint finishPoint = [maze getFinishPosition];
	if (currentPosition.x == finishPoint.x &&
		currentPosition.y == finishPoint.y &&
		currentPosition.z == finishPoint.z) {
		finishTimeElapsed = [self getTimeElapsed];
		hasFinished = YES;
	}
}

- (void) dealloc {
	[lastResume release];
	[maze release];
	[super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeInt32:movesMade forKey:@"movesMade"];
	[encoder encodeDouble:previousTimeElapsed forKey:@"previousTimeElapsed"];
	[encoder encodeObject:maze forKey:@"maze"];
	[encoder encodeObject:
	[NSData dataWithBytes: &currentPosition length:sizeof(currentPosition)]
				   forKey:@"currentPosition"];
}

- (id) initWithCoder:(NSCoder *)decoder {
	FS3DPoint position;
	[((NSData*)[decoder decodeObjectForKey:@"currentPosition"]) getBytes:&position];
	NSLog(@"%@",[[self class] description]);
	return [[HPGameState alloc] initWithMaze: [decoder decodeObjectForKey:@"maze"]
								   movesMade: [decoder decodeInt32ForKey:@"movesMade"]
								  lastResume: [NSDate date]
								 hasFinished: NO
							 currentPosition: position
						 previousTimeElapsed: [decoder decodeDoubleForKey:@"previousTimeElapsed"]];
}

- (void) reset {
	currentPosition = BEGIN_POINT;
}

@end
