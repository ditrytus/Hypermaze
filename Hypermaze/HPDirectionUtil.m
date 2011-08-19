//
//  HPDirectionUtil.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 22.07.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HPDirectionUtil.h"

@implementation HPDirectionUtil

+ (HPDirection) getOpositeDirectionTo: (HPDirection) direction {
	switch (direction) {
		case dirNorth: return dirSouth;
		case dirNorthWest: return dirSouthEast;
		case dirNorthEast: return dirSouthWest;
		case dirSouthWest: return dirNorthEast;
		case dirSouthEast: return dirNorthWest;
		case dirSouth: return dirNorth;
		default: return dirNorth;
	}
}

+ (HPDirection) getNextDirection: (HPDirection) direction {
	int directionIndex = 0;
	HPDirection* allDirections = [HPDirectionUtil getAllDirections];
	for (int i=0; i<DIR_TOTAL_DIRECTIONS; i++) {
		if (allDirections[i] == direction) {
			directionIndex = i;
			break;
		}
	}
	return allDirections[(directionIndex + 1) % DIR_TOTAL_DIRECTIONS];
}

+ (HPDirection*) getAllDirections {
	static HPDirection allDirections[DIR_TOTAL_DIRECTIONS] = {dirNorth, dirNorthEast, dirNorthWest, dirSouthEast, dirSouthWest, dirSouth};
	return allDirections;
}

+ (FS3DPoint) moveInDirection: (HPDirection) direction fromPoint: (FS3DPoint) currentPosition;
{
	switch(direction) {
		case dirNorth: return point3D(currentPosition.x, currentPosition.y, currentPosition.z + 1);
		case dirNorthEast: return point3D(currentPosition.x + 1, currentPosition.y, currentPosition.z);
		case dirNorthWest: return point3D(currentPosition.x, currentPosition.y + 1, currentPosition.z);
		case dirSouthEast: return point3D(currentPosition.x, currentPosition.y - 1, currentPosition.z);
		case dirSouthWest: return point3D(currentPosition.x - 1, currentPosition.y, currentPosition.z);
		case dirSouth: return point3D(currentPosition.x, currentPosition.y, currentPosition.z - 1);
	}
	return INVALID_POINT;
}

@end
