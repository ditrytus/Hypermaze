//
//  MainMenuScene.h
//  Hypermaze
//
//  Created by Jakub Gruszecki on 11-07-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@interface MainMenuLayer : CCLayer {
	BOOL isInTrasition;
	CCAction *showFromRightAndFadeIn;
	CCAction *hideToRightAndFadeOut;
	CCAction *showFromLeftAndFadeIn;
	CCAction *hideToLeftAndFadeOut;
	CCAction *moveLeftWithEasing;
	CCAction *moveRightWithEasing;
	CCAction *fadeInWithEasing;
	CCAction *fadeOutWithEasing;
	CCMenu *mainMenu;
	CCMenu *optionsMenu;
	CCMenu *newGameMenu;
	CCMenu *gameSettingsMenu;
	CCSprite *title;
	CCSprite *background;
	CCMenuItemToggle *sizeItem;
	
	CGPoint menuBeginLocation;
	CGPoint middleScreen;
	CGPoint titleLocation;
	
}

+(CCScene *) scene;

@end
