//
//  FinishLayer.h
//  Hypermaze
//
//  Created by Jakub Gruszecki on 10.10.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "HPLogic.h"
#import "InfoPanel.h"
#import "MainMenuLayer.h"
#import "PathBuilder.h"
#import "HPSound.h"

@interface FinishLayer : CCLayer {
	int score;
	int currentScoreCounter;
	CCMenuItemLabel* backItem;
	CCMenu* backMenu;
	CCSprite* backCloud;
}

- (id) initWithLogic: (HPLogic*) newLogic;

@end
