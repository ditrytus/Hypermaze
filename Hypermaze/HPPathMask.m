//
//  HPPathMask.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 26.08.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HPPathMask.h"

@implementation HPPathMask

- (id)init
{
    self = [super init];
    if (self) {
        path = [[NSMutableArray alloc] init];
    }
    return self;
}

-(NSString*) stringFromPoint: (FS3DPoint) point {
	return [NSString stringWithFormat:@"x%d;y%d;z%d", point.x, point.y, point.z];
}

-(bool) contains: (FS3DPoint) point {
	return [path containsObject: [self stringFromPoint: point]];
}

-(void)addToPath:(FS3DPoint) point {
	if (![self contains: point]) {
		[path addObject: [self stringFromPoint: point]];
	}
}

-(void)removeFromPath:(FS3DPoint) point {
	if ([self contains: point]) {
		[path removeObject: [self stringFromPoint: point]];
	}
}

- (NSNumber*) getValue: (FS3DPoint) position {
	return [NSNumber numberWithBool: [self contains:position]];
}


-(void) dealloc {
	[path release];
	[super dealloc];
}

@end
