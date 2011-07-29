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

@end
