//
//  HPGameCenter.h
//  Hypermaze
//
//  Created by Jakub Gruszecki on 01.11.2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "cocos2d.h"

#define EVENT_LOCAL_PLAYER_AUTHORISED @"localPlayerAuthorised"
#define EVENT_LOCAL_PLAYER_CHANGED @"localPlayerChanged"
#define EVENT_LOCAL_PLAYER_NOT_AUTHORISED @"localPlayerNotAuthorised"

@interface HPGameCenter : NSObject {
	UIViewController<GKLeaderboardViewControllerDelegate,GKAchievementViewControllerDelegate>* uiController;
	bool isGameCenterAvailable;
	NSString* lastPlayerId;
}

@property(nonatomic, readonly) bool isGameCenterAvailable;

+ (HPGameCenter*) sharedGameCenter;

- (void) initGameCenter: (UIViewController*) controller;
- (void) invalidateAuthentication;
- (BOOL) isGameCenterAPIAvailable;
- (void) showLeaderboard;
- (void) showAchievements;

@end
