//
//  HPRecursiveMask.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 21.08.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HPRecursiveMask.h"
#import "HPChamberUtil.h"
#import "HPDirectionUtil.h"

@implementation HPRecursiveMask

- (id)initWithGameState: (HPGameState*) state maze: (HPMaze*) mazeParam depth: (int) d
{
    self = [super initWithSize: [mazeParam size]];
    if (self) {
        gameState = state;
		maze = mazeParam;
		maxDepth = d;
		[self refresh];
    }
    return self;
}

- (void) refresh {
	[self clearArray];
	[self visitChamber: gameState.currentPosition depth: 0];
}

- (void) setLevel: (int) level {
	maxDepth = level;
	[self refresh];
}

- (int) getLevel {
	return maxDepth;
}

- (void) visitChamber: (FS3DPoint) position depth: (int) depth {
	if (depth < maxDepth) {
		array[position.x][position.y][position.z] = true;
		HPDirection* allDirections = [HPDirectionUtil getAllDirections];
		for (int i=0; i<DIR_TOTAL_DIRECTIONS; i++) {
			if ([HPChamberUtil canGoInDirection:allDirections[i]
									fromChamber:maze.topology[position.x][position.y][position.z]
								currentPosition:position
										   size:[maze size]]) {
				[self visitChamber: [HPDirectionUtil moveInDirection:allDirections[i] fromPoint:position] depth:depth+1];
			}
		}
	}
}

- (void) handleMove: (HPDirection) dir {
	[self refresh];
}

- (void) dealloc {
	[super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[super encodeWithCoder:encoder];
	[encoder encodeConditionalObject: gameState forKey:@"gameState"];
	[encoder encodeConditionalObject: maze forKey:@"maze"];
	[encoder encodeInt32:maxDepth forKey:@"maxDepth"];
}

- (id) initWithCoder:(NSCoder *)decoder {
	self = [super initWithCoder:decoder];
	gameState = [decoder decodeObjectForKey:@"gameState"];
	maze = [decoder decodeObjectForKey:@"maze"];
	maxDepth = [decoder decodeInt32ForKey:@"maxDepth"];
	return self;
}


@end
