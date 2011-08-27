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
		maze = [newMaze retain];
		numOfCheckPoints = num;
		[self refresh];
    }
    return self;
}

- (void) refresh {
	[path removeAllObjects];
	int solutionLength = [[maze solution] count];
	int step = solutionLength / (numOfCheckPoints + 1);
	for (int i=0; i<solutionLength; i++) {
		if (i%step==0) {
			FS3DPoint point;
			[[[maze solution] objectAtIndex:i] getBytes:&point length:sizeof(FS3DPoint)];
			[self addToPath: point];
		}
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
	[maze release];
	[super dealloc];
}

@end
