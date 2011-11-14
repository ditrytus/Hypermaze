//
//  HPCheckpointMask.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 27.08.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HPCheckpointMask.h"


@implementation HPCheckpointMask

- (id)initWithMaze: (HPMaze*) newMaze numOfCheckPoints: (int) num
{
    self = [super init];
    if (self) {
		maze = newMaze;
		numOfCheckPoints = num;
		[self refresh];
    }
    return self;
}

- (void) refresh {
	[path removeAllObjects];
	int solutionLength = [[maze solution] count];
	int step = ceil((double)solutionLength / (double)(numOfCheckPoints+1));
	for (int i=step; i<solutionLength; i+=step) {
		FS3DPoint point;
		[[[maze solution] objectAtIndex:i] getBytes:&point length:sizeof(FS3DPoint)];
		[self addToPath: point];
	}
}

- (void) setLevel: (int) level {
	numOfCheckPoints = level;
	[self refresh];
}

- (int) getLevel {
	return numOfCheckPoints;
}

- (void) dealloc {
	[super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[super encodeWithCoder:encoder];
	[encoder encodeConditionalObject: maze forKey:@"maze"];
	[encoder encodeInt32:numOfCheckPoints forKey:@"numOfCheckPoints"];
}

- (id) initWithCoder:(NSCoder *)decoder {
	self = [super initWithCoder:decoder];
	maze = [decoder decodeObjectForKey:@"maze"];
	numOfCheckPoints = [decoder decodeInt32ForKey:@"numOfCheckPoints"];
	NSLog(@"%@",[[self class] description]);
	return self;
}

@end
