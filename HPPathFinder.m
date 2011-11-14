//
//  HPPathFinder.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 27.08.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HPPathFinder.h"
#import "HPDirectionUtil.h"
#import "HPChamberUtil.h"

#define UNSET_DISTANCE -1

bool findPath(NSMutableArray* path, Byte*** topology, int size, FS3DPoint begin, FS3DPoint end, HPDirection fromDir) {
	if (!(begin.x == end.x && begin.y == end.y && begin.z == end.z)) {
		NSData* dataPoint = [NSData dataWithBytes:&begin length:sizeof(begin)];
		[path addObject: dataPoint];
		HPDirection* allDirections = [HPDirectionUtil getAllDirections];
		for (int i=0; i<DIR_TOTAL_DIRECTIONS; i++) {
			if (allDirections[i] != [HPDirectionUtil getOpositeDirectionTo: fromDir]) {
				if ([HPChamberUtil canGoInDirection:allDirections[i]
										fromChamber:topology[begin.x][begin.y][begin.z]
									currentPosition:begin
											   size:size]) {
					if (findPath(path, topology, size, [HPDirectionUtil moveInDirection:allDirections[i] fromPoint:begin], end, allDirections[i])) {
						return true;
					}
				}
			}
		}
		[path removeObject: dataPoint];
		return false;
	} else {
		return true;
	}
}

@implementation HPPathFinder

+ (NSArray*) findPathInTopology: (Byte***) topology size: (int) size from: (FS3DPoint) begin to: (FS3DPoint) end {
	NSMutableArray* path = [[[NSMutableArray alloc] init] autorelease];
//	int*** distanceMap = createDistanceMap(size);

	bool pathFound = findPath(path, topology, size, begin, end, dirNorthWest);
	NSAssert(pathFound, @"Nie znaleziono wyjścia z labirytnu!");
	
//	deleteDistanceMap(distanceMap, size);
	
	return [NSArray arrayWithArray: path];
}

@end
