//
//  HPAchievements.h
//  Hypermaze
//
//  Created by Jakub Gruszecki on 01.11.2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HPGameCenter.h"
#import "PathBuilder.h"

#define ACHIEVEMENT_ID_MAZE_SIZE_20 @"hypermaze_achievement_maze_size_20"
#define ACHIEVEMENT_ID_MAZE_SIZE_19 @"hypermaze_achievement_maze_size_19"
#define ACHIEVEMENT_ID_MAZE_SIZE_18 @"hypermaze_achievement_maze_size_18"
#define ACHIEVEMENT_ID_MAZE_SIZE_17 @"hypermaze_achievement_maze_size_17"
#define ACHIEVEMENT_ID_MAZE_SIZE_16 @"hypermaze_achievement_maze_size_16"
#define ACHIEVEMENT_ID_MAZE_SIZE_15 @"hypermaze_achievement_maze_size_15"
#define ACHIEVEMENT_ID_MAZE_SIZE_14 @"hypermaze_achievement_maze_size_14"
#define ACHIEVEMENT_ID_MAZE_SIZE_13 @"hypermaze_achievement_maze_size_13"
#define ACHIEVEMENT_ID_MAZE_SIZE_12 @"hypermaze_achievement_maze_size_12"
#define ACHIEVEMENT_ID_MAZE_SIZE_11 @"hypermaze_achievement_maze_size_11"
#define ACHIEVEMENT_ID_MAZE_SIZE_10 @"hypermaze_achievement_maze_size_10"
#define ACHIEVEMENT_ID_MAZE_SIZE_9 @"hypermaze_achievement_maze_size_9"
#define ACHIEVEMENT_ID_MAZE_SIZE_8 @"hypermaze_achievement_maze_size_8"
#define ACHIEVEMENT_ID_MAZE_SIZE_7 @"hypermaze_achievement_maze_size_7"
#define ACHIEVEMENT_ID_MAZE_SIZE_6 @"hypermaze_achievement_maze_size_6"
#define ACHIEVEMENT_ID_MAZE_SIZE_5 @"hypermaze_achievement_maze_size_5"
#define ACHIEVEMENT_ID_MAZE_SIZE_4 @"hypermaze_achievement_maze_size_4"
#define ACHIEVEMENT_ID_MAZE_SIZE_3 @"hypermaze_achievement_maze_size_3"
#define ACHIEVEMENT_ID_MAZE_SIZE_TEMPLATE @"hypermaze_achievement_maze_size_%d"
#define ACHIEVEMENT_ID_IMPROVEMENT @"hypermaze_achievement_improvement"
#define ACHIEVEMENT_ID_PATHFINDER @"hypermaze_achievement_pathfinder"
#define ACHIEVEMENT_ID_14_IS_NOT_ENOUGH @"hypermaze_achievement_14_is_not_enough"
#define ACHIEVEMENT_ID_THINKER @"hypermaze_achievement_thinker"
#define ACHIEVEMENT_ID_MAZE_MASTER_2000 @"hypermaze_achievement_maze_master_2000"

@interface HPAchievementsManager : NSObject<NSCoding> {
	NSMutableDictionary* achievementsDict;
	NSMutableDictionary* postQueue;
	bool areAchievementsLoaded;
}

+ (HPAchievementsManager*) sharedAchievementsManager;

@property(nonatomic, readonly) NSMutableDictionary* achievementsDict;

- (void) increaseWinCountForMazeSize: (int) mazeSize;
- (void) retryPostAchievements;

@end
