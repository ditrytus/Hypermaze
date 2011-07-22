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

@end
