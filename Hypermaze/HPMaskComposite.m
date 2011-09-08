//
//  HPMaskComposite.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 21.08.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HPMaskComposite.h"

@implementation HPMaskComposite

- (id)initWithMasks: (HPVisibilityMask*) firstMask, ...
{
    self = [super init];
    if (self) {
        masks = [[NSMutableArray alloc] init];
		va_list args;
		va_start(args, firstMask);
		for (HPVisibilityMask *mask = firstMask; mask != nil; mask = va_arg(args, HPVisibilityMask*))
		{
			[masks addObject: mask];
		}
		va_end(args);
    }
    return self;
}

- (NSNumber*) getValue: (FS3DPoint) position {
	@throw [NSException exceptionWithName:NSInternalInconsistencyException
								   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
								 userInfo:nil];
}

- (void) addMask: (HPVisibilityMask*) mask {
	if(![masks containsObject:mask]) {
		[masks addObject:mask];
	}
}

- (void) removeMask: (HPVisibilityMask*) mask {
	if([masks containsObject:mask]) {
		[masks removeObject:mask];
	}
}

-(void) dealloc {
	[masks release];
	[super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[super encodeWithCoder:encoder];
	[encoder encodeObject:masks forKey:@"masks"];
}

- (id) initWithCoder:(NSCoder *)decoder {
	self = [super initWithCoder:decoder];
	masks = [[decoder decodeObjectForKey:@"masks"] retain];
	return self;
}



@end
