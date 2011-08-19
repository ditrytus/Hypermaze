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

-(id)initWithTopology:(Byte ***) arrayWithTopology size: (int)arraySize {
	self = [super init];
    if (self) {
		topology = arrayWithTopology;
		size = arraySize;
    }
    return self;
}

-(void) dealloc {
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

@end
