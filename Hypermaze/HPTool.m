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

- (id) initWithIsEnabled: (BOOL) enabled {
	self = [super init];
    if (self) {
        isEnabled = enabled;
    }    
    return self;
}

- (id)init
{
    return [self initWithIsEnabled:false];
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

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeBool:isEnabled forKey:@"isEnabled"];
}
	
- (id) initWithCoder:(NSCoder *)decoder {
	NSLog(@"%@",[[self class] description]);
	return [self initWithIsEnabled:[decoder decodeBoolForKey:@"isEnabled"]];
}


@end
