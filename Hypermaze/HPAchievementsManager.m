//
//  HPAchievements.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 01.11.2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "HPAchievementsManager.h"

@implementation HPAchievementsManager

static HPAchievementsManager* sharedAchievementsManager;

+ (HPAchievementsManager*) sharedAchievementsManager {
	return sharedAchievementsManager;
}

+ (void)initialize
{
    static BOOL initialized = NO;
    if(!initialized)
    {
		sharedAchievementsManager = [[HPAchievementsManager alloc] init];
		initialized = YES;
    }
}

@synthesize achievementsDict;

- (id) init {
	if (self = [super init]) {
		achievementsDict = [[NSMutableDictionary dictionary] retain];
		[[NSNotificationCenter defaultCenter] addObserver: self
												 selector: @selector(onPlayerAuthorised:)
													 name: EVENT_LOCAL_PLAYER_AUTHORISED
												   object: [HPGameCenter sharedGameCenter]];
		[[NSNotificationCenter defaultCenter] addObserver: self
												 selector: @selector(onPlayerNotAuthorised:)
													 name: EVENT_LOCAL_PLAYER_NOT_AUTHORISED
												   object: [HPGameCenter sharedGameCenter]];
	}
	return self;
}

- (void) onPlayerAuthorised: (NSNotification*) notification {
	[GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *achievements, NSError *error) {
		if (error == nil)
		{
			for (GKAchievement* achievement in achievements) {
				[achievementsDict setObject: achievement forKey: achievement.identifier];
			}
			areAchievementsLoaded = YES;
		} else {
			NSLog(@"%@", [error description]);
		}
	}];
}

- (void) onPlayerNotAuthorised: (NSNotification*) notification {
	areAchievementsLoaded = NO;
	[achievementsDict removeAllObjects];
}

- (GKAchievement*) getAchievementForIdentifier: (NSString*) identifier
{
    GKAchievement *achievement = [achievementsDict objectForKey:identifier];
    if (achievement == nil)
    {
        achievement = [[[GKAchievement alloc] initWithIdentifier:identifier] autorelease];
        [achievementsDict setObject:achievement forKey:achievement.identifier];
    }
    return [[achievement retain] autorelease];
}

- (void) reportAchievement: (GKAchievement*) achievement {
	if (achievement)
    {
		[achievement reportAchievementWithCompletionHandler:^(NSError *error) {
			 if (error != nil)
			 {
				 NSLog(@"Report achievement failure: %@", [error localizedDescription]);
			 }
		}];
    }
}

- (void) reportAchievement: (GKAchievement*) achievement percentComplete: (float) percent
{
	if (achievement) {
		achievement.percentComplete = percent;
		[self reportAchievement: achievement];
	}
}

- (void) increaseWinCountForMazeSize: (int) mazeSize {
	if ([[HPGameCenter sharedGameCenter] isGameCenterAvailable]) {
		NSString* achievementMazeSizeId = [NSString stringWithFormat: ACHIEVEMENT_ID_MAZE_SIZE_TEMPLATE, mazeSize];
		GKAchievement* achievementMazeSize = [self getAchievementForIdentifier: achievementMazeSizeId];
		if (achievementMazeSize.percentComplete < 100.0) {
			[self reportAchievement:achievementMazeSize percentComplete:100.0f];
		}
		
		GKAchievement* achievementImprovement = [self getAchievementForIdentifier: ACHIEVEMENT_ID_IMPROVEMENT];
		if (achievementImprovement.percentComplete < 100.0) {
			double levelsCompleted = 1.0;
			for (int i=3; i<=20; i++) {
				if (i!=mazeSize) {
					NSString* achievId = [NSString stringWithFormat: ACHIEVEMENT_ID_MAZE_SIZE_TEMPLATE, i];
					GKAchievement* achiev = [self getAchievementForIdentifier: achievId];
					if (achiev.percentComplete == 100.0) {
						levelsCompleted++;
					}
				}
			}
			double percentComplete = (levelsCompleted / 18.0) * 100.0;
			if (achievementImprovement.percentComplete < percentComplete) {
				[self reportAchievement: achievementImprovement percentComplete: percentComplete];
			}
		}
		
		GKAchievement* achievementPathfinder= [self getAchievementForIdentifier: ACHIEVEMENT_ID_PATHFINDER];
		if (achievementPathfinder.percentComplete < 100.0) {
			[self reportAchievement: achievementPathfinder percentComplete: achievementPathfinder.percentComplete + 2.0];
		}
		
		if (mazeSize > 14) {
			GKAchievement* achievement14IsNotEnough= [self getAchievementForIdentifier: ACHIEVEMENT_ID_14_IS_NOT_ENOUGH];
			if (achievement14IsNotEnough.percentComplete < 100.0) {
				[self reportAchievement: achievement14IsNotEnough percentComplete: achievement14IsNotEnough.percentComplete + 2.0];
			}
		}
		
		GKAchievement* achievementThinker= [self getAchievementForIdentifier: ACHIEVEMENT_ID_THINKER];
		if (achievementThinker.percentComplete < 100.0) {
			[self reportAchievement: achievementThinker percentComplete: achievementThinker.percentComplete + 1.0];
		}
		
		if (mazeSize == 20) {
			GKAchievement* achievementMazeMaster2000 = [self getAchievementForIdentifier: ACHIEVEMENT_ID_MAZE_MASTER_2000];
			if (achievementMazeMaster2000.percentComplete < 100.0) {
				[self reportAchievement: achievementMazeMaster2000 percentComplete: achievementMazeMaster2000.percentComplete + 1.0];
			}
		}
	}
}

- (void) save {
	if ([[HPGameCenter sharedGameCenter] isGameCenterAvailable]) {
		if ([NSKeyedArchiver archiveRootObject:self
										toFile:[PathBuilder achievementsArchiveFile]]) {
			NSLog(@"Save OK");
		} else {
			NSLog(@"Save ERROR");
		}
	}
}

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver: self];
	[achievementsDict release];
	[super dealloc];
}

@end
