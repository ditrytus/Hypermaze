//
//  HPMazeGenerator.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 22.07.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HPMazeGenerator.h"

@implementation HPMazeGenerator

+ (HPMaze*) generateMazeInSize: (int) size {
	NSMutableArray *topologyX = [[NSMutableArray alloc] initWithCapacity: size*size*size];
	for (int i=0; i<size; i++) {
		NSMutableArray *topologyY = [[NSMutableArray alloc] initWithCapacity: size];
		for (int j=0; j<size; j++) {
			NSMutableArray * topologyZ = [[NSMutableArray alloc] initWithCapacity: size];
			for (int h=0; h<size; h++) {
				NSNumber *newChamber = [NSNumber numberWithInt:0];
				[topologyZ addObject: newChamber]; 
			}
			[topologyY addObject: topologyZ];
		}
		[topologyX addObject: topologyY];
	}
	HPMaze* generatedMaze = [[[HPMaze alloc] initWithTopology: topologyX] autorelease];
	return generatedMaze;
}

@end
