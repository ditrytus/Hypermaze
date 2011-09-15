//
//  NSFileManager+ArrayOfFoldersInFolder.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 09.09.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSFileManager+ArrayOfFoldersInFolder.h"

@implementation NSFileManager (ArrayOfFoldersInFolder)

+(NSArray*)arrayOfFoldersInFolder:(NSString*) folder {
	NSFileManager *fm = [NSFileManager defaultManager];
	NSError* error;
	NSArray* files = [fm contentsOfDirectoryAtPath:folder error:&error];
	NSMutableArray *directoryList = [NSMutableArray arrayWithCapacity:10];
	for(NSString *file in files) {
		NSString *path = [folder stringByAppendingPathComponent:file];
		BOOL isDir = NO;
		[fm fileExistsAtPath:path isDirectory:(&isDir)];
		if(isDir) {
			[directoryList addObject:file];
		}
	}
	return directoryList;
}

@end
