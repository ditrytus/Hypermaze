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

@interface Game : CCScene {
	HPLogic* logic;
	HPMazeLayer* mazeLayer;
	RadialMenuLayer* radialMenuLayer;
	CCLayer* interfaceLayer;
	CGSize size;
	CGPoint middleScreen;
	CCSprite* compassArrow;
	CCLabelTTF* timeElapsedLabel;
	CCLabelTTF* movesMadeLabel;
	CCLabelTTF* visitedLabel;
	CCLabelTTF* unvisitedLabel;
}

- (id) initWithLogic: (HPLogic*) newLogic;
- (void) saveGame;

- (void) onViewChanged: (NSNotification*) notification;
- (void) onPositionChanged: (NSNotification*) notification;

@end
