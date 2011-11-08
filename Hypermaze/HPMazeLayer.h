//
//  HPMazeLayer.h
//  Hypermaze
//
//  Created by Jakub Gruszecki on 19.08.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCLayer.h"
#import "cocos2d.h"
#import "HPLogic.h"
#import "FSIsoSystem.h"
#import "HPSound.h"

#define BORDER_S_CORRECTION_POINT ccp(50-16,50-12)
#define BORDER_NW_CORRECTION_POINT ccp(50-16+3,50-12-1)
#define BORDER_NE_CORRECTION_POINT ccp(50-16-2,50-12-1)

@interface HPMazeLayer : CCLayer {
	HPLogic* logic;
	FSIsoSystem* isoSys;
	CCSprite** pinkChamberPrototypes;
	CCSprite** yellowChamberPrototypes;
	CCSprite** greenChamberPrototypes;
	CCSprite** redChamberPrototypes;
	
	CCSprite* outerNEWiredPrototype;
	CCSprite* outerNEFilledPrototype;
	
	CCSprite* outerNWWiredPrototype;
	CCSprite* outerNWFilledPrototype;
	
	CCSprite* outerSWiredPrototype;
	CCSprite* outerSFilledPrototype;
	
	CCSprite* mark;
	
	CCRenderTexture* mazeTexture;
	CCRenderTexture* borderTexture;
	int mazeSize;
	Byte*** topology;
	CGPoint*** positionCache;
	Byte** chamberRotationCache;
}

- (id)initWithLogic: (HPLogic*) newLogic;
- (CGPoint) getChamberPos: (FS3DPoint) coords;
- (void) redrawMazeTexture;
- (void) onPositionChanged: (NSNotification*) notification;
- (double) getCompassAngle;
- (CGPoint) getDestination;
- (CGPoint) getTranslation;
@end
