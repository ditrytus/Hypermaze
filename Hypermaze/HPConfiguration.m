//
//  HPConfiguration.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 29.07.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HPConfiguration.h"
#import "PathBuilder.h"

@implementation HPConfiguration

@synthesize music;
@synthesize sound;
@synthesize difficulty;

static HPConfiguration *sharedConfiguration;

+ (HPConfiguration*) sharedConfiguration {
	return sharedConfiguration;
}

+ (void)initialize
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        sharedConfiguration = [[HPConfiguration alloc] init];
    }
}

- (id) init
{
    self = [super init];
    if (self) {
        NSString *errorDesc = nil;
        NSPropertyListFormat format;
        NSString *plistPath = [PathBuilder settingsFile];
        if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
            plistPath = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"];
        }
        NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
        NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization
											  propertyListFromData:plistXML
											  mutabilityOption:NSPropertyListMutableContainersAndLeaves
											  format:&format
											  errorDescription:&errorDesc];
        if (!temp) {
            NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
        }
        self.music = [temp objectForKey:@"Music"];
        self.sound = [temp objectForKey:@"Sound"];
		self.difficulty = [temp objectForKey:@"Difficulty"];
    }
    
    return self;
}

- (void) save {
	NSString *error;
    NSString *plistPath = [PathBuilder settingsFile];
    NSDictionary *plistDict = [NSDictionary dictionaryWithObjects:
							   [NSArray arrayWithObjects: music, sound, difficulty, nil]
														  forKeys:[NSArray arrayWithObjects: @"Music", @"Sound", @"Difficulty", nil]];
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict
																   format:NSPropertyListXMLFormat_v1_0
														 errorDescription:&error];
    if(plistData) {
        [plistData writeToFile:plistPath atomically:YES];
    }
    else {
        NSLog(@"%@",error);
        [error release];
    }
}

@end
