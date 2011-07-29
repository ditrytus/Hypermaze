//
//  FS3DPoint.h
//  Hypermaze
//
//  Created by Jakub Gruszecki on 23.07.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#ifndef Hypermaze_FS3DPoint_h
#define Hypermaze_FS3DPoint_h

typedef struct {
	int x;
	int y;
	int z;
} FS3DPoint;

FS3DPoint point3D(int x, int y, int z);

#endif
