//
//  HPUntakenCrossroadsMask.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 26.08.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HPUntakenCrossroadsMask.h"
#import "HPDirectionUtil.h"
#import "HPChamberUtil.h"

@implementation HPUntakenCrossroadsMask

- (id)initWithVisted: (HPVisitedMask*) vis Maze: (HPMaze*) maz
{
    self = [super init];
    if (self) {
        visitedMask = [vis retain];
		maze = [maz retain];
    }    
    return self;
}

- (NSNumber*) getValue: (FS3DPoint) position {
	if ([[visitedMask getValue:position] boolValue]) {
		Byte chamber = maze.topology[position.x][position.y][position.z];
		HPDirection* allDirections = [HPDirectionUtil getAllDirections];
		for (int i=0; i<DIR_TOTAL_DIRECTIONS; i++) {
			HPDirection currentDirection = allDirections[i];		
			if ([HPChamberUtil canGoInDirection:currentDirection
									fromChamber:chamber
								currentPosition:position
										   size:[maze size]]) {
				FS3DPoint newPosition = [HPDirectionUtil moveInDirection:currentDirection fromPoint:position];
				if (![[visitedMask getValue:newPosition] boolValue]) {
					return [NSNumber numberWithBool: true];
				}
			}
		}
	}
	return [NSNumber numberWithBool: false];
}

-(void) dealloc {
	[visitedMask release];
	[maze release];
	[super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[super encodeWithCoder:encoder];
	[encoder encodeObject:visitedMask forKey:@"visitedMask"];
	[encoder encodeObject:maze forKey:@"maze"];
}

- (id) initWithCoder:(NSCoder *)decoder {
	self = [super initWithCoder:decoder];
	visitedMask = [[decoder decodeObjectForKey:@"visitedMask"] retain];
	maze = [[decoder decodeObjectForKey:@"maze"] retain];
	return self;
}


@end
