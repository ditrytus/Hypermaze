//
//  FS3DPoint.c
//  Hypermaze
//
//  Created by Jakub Gruszecki on 23.07.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#include <stdio.h>
#import "FS3DPoint.h"

FS3DPoint point3D(int x, int y, int z) {
	FS3DPoint newPoint;
	newPoint.x = x;
	newPoint.y = y;
	newPoint.z = z;
	return newPoint;
}