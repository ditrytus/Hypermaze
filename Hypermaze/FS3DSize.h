//
//  FS3DSize.h
//  Hypermaze
//
//  Created by Jakub Gruszecki on 23.07.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#ifndef Hypermaze_FS3DSize_h
#define Hypermaze_FS3DSize_h

typedef struct {
	int width;
	int height;
	int depth;
} FS3DSize;

FS3DSize fsSize(int width, int height, int depth);
FS3DSize fsCubeSize(int size);

#endif
