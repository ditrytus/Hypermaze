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

- (void)encodeWithCoder:(NSCoder *)encoder {
	[super encodeWithCoder:encoder];
	[encoder encodeInt32:arraySize forKey:@"arraySize"];
	NSMutableArray* xPlane = [[[NSMutableArray alloc] initWithCapacity:arraySize] autorelease];
	for (int i=0; i<arraySize; i++) {
		NSMutableArray* yPlane= [[[NSMutableArray alloc] initWithCapacity:arraySize] autorelease];
		for (int j=0; j<arraySize; j++) {
			NSMutableArray* zPlane = [[[NSMutableArray alloc] initWithCapacity:arraySize] autorelease];
			for (int h=0; h<arraySize; h++) {
				[zPlane addObject:[NSNumber numberWithChar:array[i][j][h]]];
			}
			[yPlane addObject:yPlane];
		}
		[xPlane addObject: yPlane];
	}
	[encoder encodeObject:xPlane forKey:@"array"];
}

- (id) initWithCoder:(NSCoder *)decoder {
	self = [super initWithCoder:decoder];
	arraySize = [decoder decodeInt32ForKey:@"arraySize"];
	NSMutableArray* xPlane= [[decoder decodeObjectForKey:@"array"] autorelease];
	array = malloc(arraySize*sizeof(bool**));
	for (int i=0; i<arraySize; i++) {
		NSMutableArray* yPlane = [xPlane objectAtIndex:i];
		array[i] = malloc(arraySize*sizeof(bool*));
		for (int j=0; j<arraySize; j++) {
			NSMutableArray* zPlane = [yPlane objectAtIndex:i];
			array[i][j] = malloc(arraySize*sizeof(bool));
			for (int h=0; h<arraySize; h++) {
				array[i][j][h] = [((NSNumber*)[zPlane objectAtIndex:h]) boolValue];
			}
		}
	}
	return self;
}


@end
