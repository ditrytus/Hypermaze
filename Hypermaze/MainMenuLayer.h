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
	CCSprite *title;
	CCSprite *background;
	CCMenu *mainMenu;
}

+(CCScene *) scene;

@end
