//
//  HPIntersectionMaskComposite.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 21.08.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HPIntersectionMaskComposite.h"

@implementation HPIntersectionMaskComposite

- (NSNumber*) getValue: (FS3DPoint) position {
	NSNumber* result = nil;
	for (int i=0; i<[masks count]; i++) {
		NSNumber* value = [((HPVisibilityMask*)[masks objectAtIndex:i]) getValue:position];
	    if (value != nil) {
			if (result == nil) {
				result = [NSNumber numberWithBool: true];
			}
			result = [NSNumber numberWithBool: [result boolValue] && [value boolValue]];
	    }
	}
	return result;
}

@end
