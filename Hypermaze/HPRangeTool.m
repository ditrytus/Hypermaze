//
//  HPRangeTool.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 27.08.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HPRangeTool.h"

@implementation HPRangeTool

@synthesize minValue;
@synthesize maxValue;

- (id)initWithMask:(HPVisibilityMask<HPLeveled>*) managedMask composite: (HPMaskComposite*) managedComposite minValue: (int) min maxValue: (int) max initialValue: (int) val
{
    self = [super initWithMask: managedMask composite: managedComposite];
    if (self) {
		minValue = min;
		maxValue = max;
		refreshableMask  = [managedMask retain];
		[refreshableMask setLevel: val];
    }
    return self;
}

- (int) getValue {
	return [refreshableMask getLevel];
}

- (void) setValue: (int) newValue {
	if(newValue > maxValue) {
		newValue = maxValue;
	} else if (newValue < minValue) {
		newValue = minValue;
	}
	[refreshableMask setLevel: newValue];
}

- (void) dealloc {
	[refreshableMask release];
	[super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[super encodeWithCoder:encoder];
	[encoder encodeInt32:minValue forKey:@"minValue"];
	[encoder encodeInt32:maxValue forKey:@"maxValue"];
	[encoder encodeObject:refreshableMask forKey:@"refreshableMask"];
}

- (id) initWithCoder:(NSCoder *)decoder {
	self = [super initWithCoder:decoder];
	minValue = [decoder decodeInt32ForKey:@"minValue"];
	maxValue = [decoder decodeInt32ForKey:@"maxValue"];
	refreshableMask = [[decoder decodeObjectForKey:@"refreshableMask"] retain];
	NSLog(@"%@",[[self class] description]);
	return self;
}

@end