//
//  HPLeaderboardsManager.h
//  Hypermaze
//
//  Created by Jakub Gruszecki on 03.11.2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HPGameCenter.h"

#define LEADERBOARD_ID_TEMPLATE @"hypermaze_leaderboard_difficulty_%d"

@interface HPLeaderboardsManager : NSObject

+ (HPLeaderboardsManager*) sharedLeaderboardsManager;

- (void) postTime: (NSTimeInterval) duration forMaze: (int) size;

@end
