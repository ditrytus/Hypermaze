//
//  PathBuilder.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 09.09.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PathBuilder.h"

@implementation PathBuilder


+ (NSString*) resourceDirectory {
	NSString* documentDirectory = [[NSBundle mainBundle] resourcePath];
	return documentDirectory;
}

+ (NSString*) documentDirectory {
	NSString* documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	return documentDirectory;
}

+ (NSString*) saveDirectory {
	return [[PathBuilder documentDirectory] stringByAppendingPathComponent:@"Save"];
}

+ (NSString*) savedGameDirectory: (NSString*) date {
	return [[PathBuilder saveDirectory] stringByAppendingPathComponent: date];
}

+ (NSString*) settingsFile {
	return [[PathBuilder documentDirectory] stringByAppendingPathComponent:SETTINGS_FILE];
}

@end
