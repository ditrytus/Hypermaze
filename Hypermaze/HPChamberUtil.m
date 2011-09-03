//
//  NSChamberUtil.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 22.07.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HPChamberUtil.h"
#import "HPMazeGenerator.h"
#import "HPDirectionUtil.h"

@implementation HPChamberUtil

+ (BOOL) canGoInDirection: (HPDirection) direction fromChamber: (Byte) chamber {
	return (direction & chamber) > 0;
}

+ (BOOL) canGoInDirection: (HPDirection) direction fromChamber: (Byte) chamber currentPosition: (FS3DPoint) pos size: (int) size {
	return isPositionValid([HPDirectionUtil moveInDirection:direction fromPoint:pos], size) && (direction & chamber) > 0 ;
}

+ (Byte) createPassageInDirection: (HPDirection) direction chamber: (Byte) chamber {
	return (direction | chamber);
}

+ (Byte) rotateChamber: (Byte) chamber by: (int) rot {
	bool northBit = chamber & dirNorth;
	bool northWestBit = chamber & dirNorthWest;
	bool northEastBit = chamber & dirNorthEast;
	bool southWestBit = chamber & dirSouthWest;
	bool southEastBit = chamber & dirSouthEast;
	bool southBit = chamber & dirSouth;
	
	Byte rotatedNorthComponent = (northBit ? 1 : 0) * [HPDirectionUtil rotateDirection:dirNorth by:rot];
	Byte rotatedNorthWestComponent = (northWestBit ? 1 : 0) * [HPDirectionUtil rotateDirection:dirNorthWest by:rot];
	Byte rotatedNorthEastComponent = (northEastBit ? 1 : 0) * [HPDirectionUtil rotateDirection:dirNorthEast by:rot];
	Byte rotatedSouthWestComponent = (southWestBit ? 1 : 0) * [HPDirectionUtil rotateDirection:dirSouthWest by:rot];
	Byte rotatedSouthEastComponent = (southEastBit ? 1 : 0) * [HPDirectionUtil rotateDirection:dirSouthEast by:rot];
	Byte rotatedSouthComponent = (southBit ? 1 : 0) * [HPDirectionUtil rotateDirection:dirSouth by:rot];
	
	return rotatedNorthComponent +
		rotatedNorthEastComponent +
		rotatedNorthWestComponent +
		rotatedSouthComponent +
		rotatedSouthEastComponent +
		rotatedSouthWestComponent;
}

@end
