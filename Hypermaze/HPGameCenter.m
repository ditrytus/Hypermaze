//
//  HPGameCenter.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 01.11.2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "HPGameCenter.h"

@implementation HPGameCenter

static HPGameCenter* sharedGameCenter;

+ (HPGameCenter*) sharedGameCenter {
	return sharedGameCenter;
}

+ (void)initialize
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        sharedGameCenter = [[HPGameCenter alloc] init];
    }
}

@synthesize  isGameCenterAvailable;

- (void) authenticateLocalPlayer {
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    [localPlayer authenticateWithCompletionHandler:^(NSError *error) {
		if (localPlayer.isAuthenticated) {
			isGameCenterAvailable = YES;
			[[NSNotificationCenter defaultCenter] postNotificationName: EVENT_LOCAL_PLAYER_AUTHORISED object: self userInfo: nil];
			if (lastPlayerId != nil && [lastPlayerId isEqualToString: localPlayer.playerID]) {
				[lastPlayerId release];
				lastPlayerId = [localPlayer.playerID copy];
				[[NSNotificationCenter defaultCenter] postNotificationName: EVENT_LOCAL_PLAYER_CHANGED object: self userInfo: nil];
			} else {
				[lastPlayerId release];
				lastPlayerId = [localPlayer.playerID copy];
			}
		} else {
			isGameCenterAvailable = NO;
			[[NSNotificationCenter defaultCenter] postNotificationName: EVENT_LOCAL_PLAYER_NOT_AUTHORISED object: self userInfo: nil];
		}
	}];
}

- (void) initGameCenter:(UIViewController<GKLeaderboardViewControllerDelegate,GKAchievementViewControllerDelegate>*)controller {
	uiController = [controller retain];
	if ([self isGameCenterAPIAvailable]) {
		[self authenticateLocalPlayer];
	} else {
		isGameCenterAvailable = NO;
	}
}


- (BOOL) isGameCenterAPIAvailable {
    // Check for presence of GKLocalPlayer class.
    BOOL localPlayerClassAvailable = (NSClassFromString(@"GKLocalPlayer")) != nil;
    // The device must be running iOS 4.1 or later.
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
    return (localPlayerClassAvailable && osVersionSupported);
}

- (void) showLeaderboard
{
    GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
    if (leaderboardController != nil)
    {
        leaderboardController.leaderboardDelegate = uiController;
        [uiController presentModalViewController: leaderboardController animated: YES];
    }
}

- (void) showAchievements
{
    GKAchievementViewController *achievements = [[GKAchievementViewController alloc] init];
    if (achievements != nil)
    {
        achievements.achievementDelegate = uiController;
        [uiController presentModalViewController: achievements animated: YES];
    }
    [achievements release];
}

- (void) invalidateAuthentication {
	[[NSNotificationCenter defaultCenter] postNotificationName: EVENT_LOCAL_PLAYER_NOT_AUTHORISED object: self userInfo: nil];
	isGameCenterAvailable = NO;
}

- (void) loadAchievements
{
    
}


- (void) dealloc {
	[lastPlayerId release];
	[uiController release];
}

@end
