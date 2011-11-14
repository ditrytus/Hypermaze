//
//  HPMarkMask.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 27.08.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HPMarkMask.h"

@implementation HPMarkMask

@synthesize isEnabled;

- (id)initWithIsEnabled: (BOOL) enabled
				Untaken: (HPVisibilityMask*) untaken
				visited: (HPVisibilityMask*) visited
				ariadna: (HPVisibilityMask*) ariadna
			 checkpoint: (HPVisibilityMask*) checkpoint
{
    self = [super init];
    if (self) {
		isEnabled = enabled;
        untakenMask = untaken;
		visitedMask = visited;
		ariadnaMask = ariadna;
		checkpointMask = checkpoint;
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
	[super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeBool:isEnabled forKey:@"isEnabled"];
	[encoder encodeConditionalObject:untakenMask forKey:@"untakenMask"];
	[encoder encodeConditionalObject:visitedMask forKey:@"visitedMask"];
	[encoder encodeConditionalObject:ariadnaMask forKey:@"ariadnaMask"];
	[encoder encodeConditionalObject:checkpointMask forKey:@"checkpointMask"];
}

- (id) initWithCoder:(NSCoder *)decoder {
	bool decodedIsEnabled = [decoder decodeBoolForKey:@"isEnabled"];
	id decodedUntaken = [decoder decodeObjectForKey:@"untakenMask"];
	id decodedVisited = [decoder decodeObjectForKey:@"visitedMask"];
	id decodedAriadna = [decoder decodeObjectForKey:@"ariadnaMask"];
	id decodedCheckpoint = [decoder decodeObjectForKey:@"checkpointMask"];
	return [self initWithIsEnabled: decodedIsEnabled
						   Untaken: decodedUntaken
						   visited: decodedVisited
						   ariadna: decodedAriadna
						checkpoint: decodedCheckpoint];
}

@end
