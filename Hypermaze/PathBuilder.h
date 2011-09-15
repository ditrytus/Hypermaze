//
//  PathBuilder.h
//  Hypermaze
//
//  Created by Jakub Gruszecki on 09.09.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SETTINGS_FILE			@"Settings.plist"
#define SAVE_SCREENSHOT_FILE	@"screenshot.jpg"
#define SAVE_METADATA_FILE		@"metadata.hmz"
#define SAVE_DATA_FILE			@"data.hmz"

@interface PathBuilder : NSObject

+ (NSString*) baseDirectory;
+ (NSString*) saveDirectory;
+ (NSString*) savedGameDirectory: (NSString*) date;
+ (NSString*) settingsFile;

@end
