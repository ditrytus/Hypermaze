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
        // Initialization code here.
    }
    return self;
}

- (NSNumber*) getValue: (FS3DPoint) position {
	return [NSNumber numberWithBool: true];
}

@end
