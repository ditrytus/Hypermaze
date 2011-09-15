//
//  PathBuilder.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 09.09.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PathBuilder.h"

@implementation PathBuilder

+ (NSString*) baseDirectory {
	NSString* baseDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	return baseDirectory;
}

+ (NSString*) saveDirectory {
	return [[PathBuilder baseDirectory] stringByAppendingPathComponent:@"Save"];
}

+ (NSString*) savedGameDirectory: (NSString*) date {
	return [[PathBuilder saveDirectory] stringByAppendingPathComponent: date];
}

+ (NSString*) settingsFile {
	return [[PathBuilder baseDirectory] stringByAppendingPathComponent:SETTINGS_FILE];
}

@end
