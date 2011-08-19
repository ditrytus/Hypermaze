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
#import "FSIsoSystem.h"

@interface Game : CCScene {
	HPLogic* logic;
	CCLayer* backgroundLayer;
	CCLayer* mazeLayer;
	CCLayer* interfaceLayer;
	FSIsoSystem* isoSys;
	CCSprite**** pinkChambers;
	CGSize size;
	CGPoint middleScreen;
	
}

- (id) initWithLogic: (HPLogic*) newLogic;

@end
