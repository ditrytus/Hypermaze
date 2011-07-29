//
//  MultiDimensional.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 23.07.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MultiDimensional.h"
#import "math.h"

int project3DTo1D(FS3DSize size, FS3DPoint pos) {
	return pos.x + pos.y*size.width + pos.z*size.width*size.height;
}

@implementation NSMutableArray (MultiDimensional)

- (id) get3Dsize: (FS3DSize)size position: (FS3DPoint)pos {
	return [self objectAtIndex: project3DTo1D(size,pos)];
}

- (id)  get3Dposition: (FS3DPoint)pos {
	int size = cbrt([self count]);
	return [self get3Dsize: fsCubeSize(size) position: pos];
}

- (void) set3Dsize: (FS3DSize)size position: (FS3DPoint)position value:(id)val {
	[self replaceObjectAtIndex: project3DTo1D(size,position) withObject: val];
}

- (void) set3Dposition: (FS3DPoint)position value: (id)val {
	int size = cbrt([self count]);
	[self set3Dsize: fsCubeSize(size) position: position value: val];
}

@end
