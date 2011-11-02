//
//  MainMenuScene.h
//  Hypermaze
//
//  Created by Jakub Gruszecki on 11-07-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"
#import "CCScrollLayer.h"
#import "HPGameCenter.h"

@interface MainMenuLayer : CCLayer {
	BOOL isInTrasition;
	bool hasSavedGames;
	bool isInProgressMenu;
	bool isProgressMenuEnable;
	int resumeGameMenuPos;
	NSMutableArray* savedGames;
	NSMutableArray* resumeItems;
	CCAction *showFromRightAndFadeIn;
	CCAction *hideToRightAndFadeOut;
	CCAction *showFromLeftAndFadeIn;
	CCAction *hideToLeftAndFadeOut;
	CCAction *moveLeftWithEasing;
	CCAction *moveRightWithEasing;
	CCAction *fadeInWithEasing;
	CCAction *fadeOutWithEasing;
	CCAction *moveUpWithEasing;
	CCAction *moveDownWithEasing;
	CCAction *pushUp;
	CCAction *pushDown;
	CCAction *jumpUp;
	CCAction *jumpDown;
	CCMenu *mainMenu;
	CCMenu *optionsMenu;
	CCMenu *progressMenu;
	CCMenu *newGameMenu;
	CCMenu *gameSettingsMenu;
	CCLayer *resumeGameLayer;
	CCMenu *resumeGameMenu;
	CCSprite *title;
	CCSprite *background;
	CCMenuItemToggle *sizeItem;
	CCMenuItemSprite* resumeButton;
	
	CCMenuItemSprite* progressButton;
	CCMenuItemSprite* leaderboardsButton;
	CCMenuItemSprite* achievementsButton;
	
	CGPoint menuBeginLocation;
	CGPoint middleScreen;
	CGPoint titleLocation;
}

+(CCScene *) scene;

@property BOOL isProgressMenuEnable;

- (void) onGameDeleteConfirm: (NSNotification*) notification;

@end
