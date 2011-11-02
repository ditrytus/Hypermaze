//
//  PathBuilder.h
//  Hypermaze
//
//  Created by Jakub Gruszecki on 09.09.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SETTINGS_FILE			@"Settings.plist"
#define ACHIEVEMENTS_FILE		@"achievements.hmz"
#define SAVE_SCREENSHOT_FILE	@"screenshot.jpg"
#define SAVE_METADATA_FILE		@"metadata.hmz"
#define SAVE_DATA_FILE			@"data.hmz"
#define TUTORIAL_METADATA_FILE	@"tutorial_metadata.hmz"
#define TUTORIAL_DATA_FILE		@"tutorial_data.hmz"

@interface PathBuilder : NSObject

+ (NSString*) resourceDirectory;
+ (NSString*) saveDirectory;
+ (NSString*) savedGameDirectory: (NSString*) date;
+ (NSString*) settingsFile;
+ (NSString*) achievementsArchiveFile;

@end
