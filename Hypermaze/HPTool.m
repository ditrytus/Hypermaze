//
//  HPTool.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 21.08.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HPTool.h"

@implementation HPTool

@synthesize isEnabled;

- (id)init
{
    self = [super init];
    if (self) {
        isEnabled = false;
    }    
    return self;
}

- (void) toggle {
	isEnabled = !isEnabled;
	if (isEnabled) {
		[self turnOn];
	} else {
		[self turnOff];
	}
}

- (void) turnOn  {
	@throw [NSException exceptionWithName:NSInternalInconsistencyException
								   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
								 userInfo:nil];
}

- (void) turnOff {
	@throw [NSException exceptionWithName:NSInternalInconsistencyException
								   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
								 userInfo:nil];
}

@end
