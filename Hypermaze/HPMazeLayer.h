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
	int mazeSize;
	Byte*** topology;
	CGPoint*** positionCache;
	Byte** chamberRotationCache;
}

-(CGPoint) getChamberPos: (FS3DPoint) coords;
-(void) redrawMazeTexture;
- (void) onPositionChanged: (NSNotification*) notification;
-(double) getCompassAngle;
- (CGPoint) getDestination;
- (CGPoint) getTranslation;
@end
