//
//  HPVisibilityMaskManipulationTool.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 21.08.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HPVisibilityMaskManipulationTool.h"

@implementation HPVisibilityMaskManipulationTool

- (id)initWithMask:(HPVisibilityMask*) managedMask composite: (HPMaskComposite*) managedComposite {
    self = [super init];
    if (self) {
        mask = [managedMask retain];
		composite = [managedComposite retain];
		[self turnOff];
    }
    return self;
}

- (void) turnOn  {
	[composite addMask: mask];
}

- (void) turnOff {
	[composite removeMask: mask];
}

-(void) dealloc {
	[mask release];
	[composite release];
	[super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[super encodeWithCoder:encoder];
	[encoder encodeObject: mask forKey: @"mask"];
	[encoder encodeObject: composite forKey:@"composite"];
}
	
- (id) initWithCoder:(NSCoder *)decoder {
	self = [super initWithCoder:decoder];
	mask = [[decoder decodeObjectForKey:@"mask"] retain];
	composite = [[decoder decodeObjectForKey:@"composite"] retain];
	NSLog(@"%@",[[self class] description]);
	return self;
}

@end
