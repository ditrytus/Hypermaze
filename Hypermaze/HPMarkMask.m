//
//  HPMarkMask.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 27.08.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HPMarkMask.h"

@implementation HPMarkMask

- (id)initWithIsEnabled: (BOOL) enabled
				Untaken: (HPVisibilityMask*) untaken
				visited: (HPVisibilityMask*) visited
				ariadna: (HPVisibilityMask*) ariadna
			 checkpoint: (HPVisibilityMask*) checkpoint
{
    self = [super init];
    if (self) {
		isEnabled = enabled;
        untakenMask = [untaken retain];
		visitedMask = [visited retain];
		ariadnaMask = [ariadna retain];
		checkpointMask = [checkpoint retain];
    }
    return self;
}

- (id)initWithUntaken: (HPVisibilityMask*) untaken
			  visited: (HPVisibilityMask*) visited
			  ariadna: (HPVisibilityMask*) ariadna
		   checkpoint: (HPVisibilityMask*) checkpoint
{
    return [self initWithIsEnabled: false
						   Untaken: untaken
						   visited: visited
						   ariadna: ariadna
						checkpoint: checkpoint];
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

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeBool:isEnabled forKey:@"isEnabled"];
	[encoder encodeObject:untakenMask forKey:@"untakenMask"];
	[encoder encodeObject:visitedMask forKey:@"visitedMask"];
	[encoder encodeObject:ariadnaMask forKey:@"ariadnaMask"];
	[encoder encodeObject:checkpointMask forKey:@"checkpointMask"];
}

- (id) initWithCoder:(NSCoder *)decoder {
	return [self initWithIsEnabled:[decoder decodeBoolForKey:@"isEnabled"]
						   Untaken:[[decoder decodeObjectForKey:@"untakenMask"] autorelease]
						   visited:[[decoder decodeObjectForKey:@"visitedMask"] autorelease]
						   ariadna:[[decoder decodeObjectForKey:@"ariadnaMask"] autorelease]
						checkpoint:[[decoder decodeObjectForKey:@"checkpointMask"] autorelease]];
}

@end
