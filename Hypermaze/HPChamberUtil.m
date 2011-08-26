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

@end
