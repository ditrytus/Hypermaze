//
//  FS3DSize.c
//  Hypermaze
//
//  Created by Jakub Gruszecki on 23.07.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#include <stdio.h>
#import "FS3DSize.h"

FS3DSize fsSize3D(int width, int height, int depth) {
	FS3DSize newSize;
	newSize.width = width;
	newSize.height = height;
	newSize.depth = depth;
	return newSize;
}

FS3DSize fsCubeSize(int size) {
	return fsSize3D(size,size,size);
}