//
//  HPLeaderboardsManager.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 03.11.2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "HPLeaderboardsManager.h"

@implementation HPLeaderboardsManager

static HPLeaderboardsManager* sharedLeaderboardsManager;

+ (HPLeaderboardsManager*) sharedLeaderboardsManager {
	return sharedLeaderboardsManager;
}

+ (void)initialize
{
    static BOOL initialized = NO;
    if(!initialized)
    {
		sharedLeaderboardsManager = [[HPLeaderboardsManager alloc] init];
		initialized = YES;
    }
}

- (void) postTime: (NSTimeInterval) duration forMaze: (int) size {
	if ([[HPGameCenter sharedGameCenter] isGameCenterAvailable]) {
		GKScore *scoreReporter = [[[GKScore alloc] initWithCategory:[NSString stringWithFormat:LEADERBOARD_ID_TEMPLATE,size]] autorelease];
		scoreReporter.value = duration;
		
		[scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
			if (error != nil)
			{
				
			}
		}];
	}
}

@end
