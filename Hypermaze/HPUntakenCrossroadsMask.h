//
//  HPUntakenCrossroadsMask.h
//  Hypermaze
//
//  Created by Jakub Gruszecki on 26.08.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HPVisibilityMask.h"
#import "HPVisitedMask.h"
#import "HPMaze.h"

@interface HPUntakenCrossroadsMask : HPVisibilityMask {
	HPVisitedMask* visitedMask;
	HPMaze* maze;
}

- (id)initWithVisted: (HPVisitedMask*) vis Maze: (HPMaze*) maz;

@end
