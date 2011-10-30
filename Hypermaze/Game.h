//
//  Game.h
//  Hypermaze
//
//  Created by Jakub Gruszecki on 29.07.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "HPLogic.h"
#import "HPMazeLayer.h"
#import "FSIsoSystem.h"
#import "RadialMenuLayer.h"
#import "InfoPanel.h"
#import "FinishLayer.h"
#import "TutorialLayer.h"

#define INTF_ARROW_CLICK_EVENT @"onArrowClick"
#define INTF_ARROW_CLICK_USER_INFO @"arrowClicked"

@interface Game : CCScene {
	HPLogic* logic;
	HPMazeLayer* mazeLayer;
	InfoPanel* infoPanel;
	RadialMenuLayer* radialMenuLayer;
	TutorialLayer* tutorialLayer;
	CCLayer* interfaceLayer;
	CGSize size;
	CGPoint middleScreen;
	CCSprite* compassArrow;
	bool isTutorial;
	int stepNum;
}

- (CCMenuItem*) getLeftNArrow;
- (CCMenuItem*) getLeftNWArrow;
- (CCMenuItem*) getLeftNEArrow;
- (CCMenuItem*) getLeftSWArrow;
- (CCMenuItem*) getLeftSEArrow;
- (CCMenuItem*) getLeftSArrow;
- (CCMenuItem*) getLeftCWArrow;
- (CCMenuItem*) getLeftCCWArrow;

- (CCMenuItem*) getRightNArrow;
- (CCMenuItem*) getRightNWArrow;
- (CCMenuItem*) getRightNEArrow;
- (CCMenuItem*) getRightSWArrow;
- (CCMenuItem*) getRightSEArrow;
- (CCMenuItem*) getRightSArrow;
- (CCMenuItem*) getRightCWArrow;
- (CCMenuItem*) getRightCCWArrow;

- (id) initWithLogic: (HPLogic*) newLogic;
- (id) initTutorial;
- (void) saveGame;

- (void) onViewChanged: (NSNotification*) notification;
- (void) onPositionChanged: (NSNotification*) notification;

+ (CCMenuItemSprite*) createArrowWithName: (NSString*) arrowName target: (id) target selector: (SEL) selector;

@end
