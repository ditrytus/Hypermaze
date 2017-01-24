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
#import "PathBuilder.h"

@interface MainMenuLayer : CCLayer {
	BOOL isInTrasition;
	bool hasSavedGames;
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
	CCMenu *newGameMenu;
	CCMenu *gameSettingsMenu;
	CCMenu *resumeGameMenu;
	CCSprite *title;
	CCSprite *background;
	CCMenuItemToggle *sizeItem;
	CCMenuItemSprite* resumeButton;
	
	CGPoint menuBeginLocation;
	CGPoint middleScreen;
	CGPoint titleLocation;
}

+(CCScene *) scene;

- (void) onGameDeleteConfirm: (NSNotification*) notification;

@end
