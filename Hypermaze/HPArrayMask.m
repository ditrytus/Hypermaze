//
//  HPArrayMask.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 21.08.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HPArrayMask.h"

@implementation HPArrayMask

- (id)initWithSize: (int) size
{
    self = [super init];
    if (self) {
		arraySize = size;
        array = malloc(arraySize*sizeof(bool**));
		for (int i=0; i<arraySize; i++) {
			array[i] = malloc(arraySize*sizeof(bool*));
			for (int j=0; j<arraySize; j++) {
				array[i][j] = malloc(arraySize*sizeof(bool));
				for (int h=0; h<arraySize; h++) {
					array[i][j][h] = false;
				}
			}
		}
    }
    return self;
}

- (void) clearArray {
	for (int i=0; i<arraySize; i++) {
		for (int j=0; j<arraySize; j++) {
			for (int h=0; h<arraySize; h++) {
				array[i][j][h] = false;
			}
		}
	}
}

- (NSNumber*) getValue: (FS3DPoint) position {
	return [NSNumber numberWithBool: array[position.x][position.y][position.z]];
}

- (void) dealloc {
	free(array);
	for (int i=0; i<arraySize; i++) {
		array[i] = malloc(arraySize*sizeof(bool*));
		for (int j=0; j<arraySize; j++) {
			array[i][j] = malloc(arraySize*sizeof(bool));
		}
	}
	[super dealloc];
}

@end
