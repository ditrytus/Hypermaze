//
//  HPMaze.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 22.07.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HPMaze.h"

@implementation HPMaze

@synthesize topology;
@synthesize size;
@synthesize solution;

-(id)initWithTopology:(Byte ***) arrayWithTopology size: (int)arraySize solution: (NSArray*) arraySolution {
	self = [super init];
    if (self) {
		topology = arrayWithTopology;
		size = arraySize;
		solution = [arraySolution retain];
    }
    return self;
}

-(void) dealloc {
	[solution release];
	for (int i=0; i<size; i++) {
		topology[i] = (Byte**) malloc(size*sizeof(Byte*));
		for (int j=0; j<size; j++) {
			free(topology[i][j]);
		}
		free(topology[i]);
	}
	free(topology);
	[super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeInt32:size forKey:@"size"];
	[encoder encodeObject:solution forKey:@"solution"];
	NSMutableArray* xPlaneTopology = [[[NSMutableArray alloc] initWithCapacity:size] autorelease];
	for (int i=0; i<size; i++) {
		NSMutableArray* yPlaneTopology = [[[NSMutableArray alloc] initWithCapacity:size] autorelease];
		for (int j=0; j<size; j++) {
			NSMutableArray* zPlaneTopology = [[[NSMutableArray alloc] initWithCapacity:size] autorelease];
			for (int h=0; h<size; h++) {
				[zPlaneTopology addObject:[NSNumber numberWithChar:topology[i][j][h]]];
			}
			[yPlaneTopology addObject:zPlaneTopology];
		}
		[xPlaneTopology addObject: yPlaneTopology];
	}
	[encoder encodeObject:xPlaneTopology forKey:@"topology"];
}
	
- (id) initWithCoder:(NSCoder *)decoder {
	int decodedSize = [decoder decodeInt32ForKey:@"size"];
	NSMutableArray* xPlaneTopology = [[decoder decodeObjectForKey:@"topology"] autorelease];
	Byte*** arrayWithTopology = malloc(decodedSize*sizeof(Byte**));
	for (int i=0; i<size; i++) {
		NSMutableArray* yPlaneTopology = [xPlaneTopology objectAtIndex:i];
		arrayWithTopology[i] = malloc(decodedSize*sizeof(Byte*));
		for (int j=0; j<size; j++) {
			NSMutableArray* zPlaneTopology = [yPlaneTopology objectAtIndex:i];
			arrayWithTopology[i][j] = malloc(decodedSize*sizeof(Byte));
			for (int h=0; h<size; h++) {
				arrayWithTopology[i][j][h] = [((NSNumber*)[zPlaneTopology objectAtIndex:h]) charValue];
			}
		}
	}
	NSLog(@"%@",[[self class] description]);
	return [self initWithTopology: arrayWithTopology
							 size: decodedSize
						 solution: [[decoder decodeObjectForKey:@"solution"] autorelease]];
}

@end
