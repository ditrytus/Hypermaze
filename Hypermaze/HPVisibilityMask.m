//
//  HPVisibilityMask.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 21.08.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HPVisibilityMask.h"

@implementation HPVisibilityMask

- (id)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (NSNumber*) getValue: (FS3DPoint) position {
	return [NSNumber numberWithBool: true];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
}
	
- (id) initWithCoder:(NSCoder *)decoder {
	NSLog(@"%@",[[self class] description]);
	return [self init];
}


@end
