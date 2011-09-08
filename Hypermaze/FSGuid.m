//
//  FSGuid.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 08.09.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FSGuid.h"

@implementation NSString (FSGuid)

+ (NSString*) stringWithUUID {
	CFUUIDRef	uuidObj = CFUUIDCreate(nil);
	NSString	*uuidString = (NSString*)CFUUIDCreateString(nil, uuidObj);
	CFRelease(uuidObj);
	return [uuidString autorelease];
}

@end
