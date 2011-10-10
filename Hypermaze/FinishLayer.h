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

@interface FinishLayer : CCLayer {
	int score;
	int currentScoreCounter;
	CCLabelTTF* scoreValueLabel;
	CCMenuItemLabel* backItem;
	CCMenu* backMenu;
	CCSprite* backCloud;
	NSString* saveGameFolder;
}

- (id) initWithLogic: (HPLogic*) newLogic;

@end
