//
//  FSIsoSystem.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 29.07.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FSIsoSystem.h"

#define CORRECTION_Y 1.5

@implementation FSIsoSystem

- (id)initWithTileSize: (CGSize)tSize mapSize: (CGSize)mSize;
{
    self = [super init];
    if (self) {
        tileSize = tSize;
		xVertex = CGPointMake(0.5*tileSize.width, 0.5*tileSize.height+CORRECTION_Y);
		yVertex = CGPointMake(-0.5*tileSize.width, 0.5*tileSize.height+CORRECTION_Y);
		mapLogicalSize = mSize;
		firstPosition = CGPointMake((mapLogicalSize.height - 1)*tileSize.width / 2.0, 0);
		tileCoords = malloc(mapLogicalSize.width*sizeof(CGPoint*));
		for (int x=0; x<mapLogicalSize.width; x++) {
			tileCoords[x] = malloc(mapLogicalSize.height*sizeof(CGPoint));
			for (int y=0; y<mapLogicalSize.height; y++) {
				tileCoords[x][y] = CGPointMake(firstPosition.x + xVertex.x*x + yVertex.x*y, firstPosition.y + xVertex.y*x + yVertex.y*y);
			}
		}
	}
    return self;
}

- (CGPoint) getTileRealPosition:(CGPoint)logicPosition {
	return tileCoords[(int)logicPosition.x][(int)logicPosition.y];
}

-(void) dealloc {
	for (int x=0; x<mapLogicalSize.width; x++) {
		free(tileCoords[x]);
	}
	free(tileCoords);
	[super dealloc];
}

@end
