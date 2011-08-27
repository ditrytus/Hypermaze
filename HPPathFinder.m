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

//void floodDistance(Byte*** topology, int size, FS3DPoint point, int distance, int*** distanceMap) {
//	if (distanceMap[point.x][point.y][point.z] == UNSET_DISTANCE) {
//		distanceMap[point.x][point.y][point.z] = distance;
//		HPDirection* allDirections = [HPDirectionUtil getAllDirections];
//		for (int i=0; i<DIR_TOTAL_DIRECTIONS; i++) {
//			if ([HPChamberUtil canGoInDirection:allDirections[i]
//									fromChamber:topology[point.x][point.y][point.z]
//								currentPosition:point
//										   size:size]) {
//				floodDistance(topology, size, [HPDirectionUtil moveInDirection:allDirections[i] fromPoint:point], distance+1, distanceMap);
//			}
//		}
//	}
//}
//
//int*** createDistanceMap(int size) {
//	int*** distanceMap = malloc(size*sizeof(int**));
//	for (int i=0; i<size; i++) {
//		distanceMap[i] = malloc(size*sizeof(int*));
//		for (int j=0; j<size; j++) {
//			distanceMap[i][j] = malloc(size*sizeof(int));
//			for (int h=0; h<size; h++) {
//				distanceMap[i][j][h] = UNSET_DISTANCE;
//			}
//		}
//	}
//	return distanceMap;
//}
//
//void deleteDistanceMap(int*** distanceMap, int size) {
//	for (int i=0; i<size; i++) {
//		for (int j=0; j<size; j++) {
//			free(distanceMap[i][j]);
//		}
//		free(distanceMap[i]);
//	}
//	free(distanceMap);
//}
//
//void createPathToBegin(NSMutableArray* path, FS3DPoint point, int*** distanceMap, int size) {
//	int currentDistance = distanceMap[point.x][point.y][point.z];
//	[path addObject:[NSData dataWithBytes:&point length:sizeof(point)]];
//	HPDirection* allDirections = [HPDirectionUtil getAllDirections];
//	for (int i=0; i<DIR_TOTAL_DIRECTIONS; i++) {
//		FS3DPoint nextPoint = [HPDirectionUtil moveInDirection:allDirections[i] fromPoint:point];
//		if (isPositionValid(nextPoint, size)) {
//			if (distanceMap[nextPoint.x][nextPoint.y][nextPoint.z] == currentDistance - 1) {
//				createPathToBegin(path, nextPoint, distanceMap, size);
//			}
//		}
//	}
//}

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
	NSMutableArray* path = [[NSMutableArray alloc] init];
//	int*** distanceMap = createDistanceMap(size);

	bool pathFound = findPath(path, topology, size, begin, end, dirNorthWest);
	NSAssert(pathFound, @"Nie znaleziono wyjścia z labirytnu!");
	
//	deleteDistanceMap(distanceMap, size);
	
	return [NSArray arrayWithArray: path];
}

@end
