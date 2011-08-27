//
//  HPMarkMask.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 27.08.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HPMarkMask.h"

@implementation HPMarkMask

- (id)initWithUntaken: (HPVisibilityMask*) untaken visited: (HPVisibilityMask*) visited ariadna: (HPVisibilityMask*)  ariadna checkpoint: (HPVisibilityMask*) checkpoint
{
    self = [super init];
    if (self) {
		isEnabled = false;
        untakenMask = [untaken retain];
		visitedMask = [visited retain];
		ariadnaMask = [ariadna retain];
		checkpointMask = [checkpoint retain];
    }
    return self;
}

- (HPChamberMark) getValue: (FS3DPoint) position {
	if (isEnabled) {
		if ([[untakenMask getValue: position] boolValue]) {
			return cmUntaken;
		} else if ([[ariadnaMask getValue: position] boolValue]) {
			return cmAriadna;
		} else if ([[checkpointMask getValue: position] boolValue]) {
			return cmAriadna;
		} else if ([[visitedMask getValue: position] boolValue]) {
			return cmVisited;
		} else {
			return cmUnvisited;
		}
	} else {
		return cmUnvisited;
	}
}

- (void) toggle {
	isEnabled = !isEnabled;
}

- (void) dealloc {
	[untakenMask release];
	[visitedMask release];
	[ariadnaMask release];
	[checkpointMask release];
	[super dealloc];
}

@end
