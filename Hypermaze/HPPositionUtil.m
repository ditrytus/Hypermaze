//
//  HPPositionUtil.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 03.09.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HPPositionUtil.h"


@implementation HPPositionUtil

+ (FS3DPoint) rotatePoint: (FS3DPoint)point by: (int) rot withSize: (int) size {
	rot = rot % 4;
	if (rot == 0) {
		return point;
	} else {
		FS3DPoint rotatedPoint = point3D(size-1-point.y, point.x, point.z);
		return [self rotatePoint:rotatedPoint by:rot-1 withSize:size];
	}
}

@end
