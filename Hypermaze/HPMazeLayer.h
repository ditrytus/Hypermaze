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

@interface HPMazeLayer : CCLayer {
	HPLogic* logic;
	FSIsoSystem* isoSys;
	CCSprite** pinkChamberPrototypes;
	CCSprite** yellowChamberPrototypes;
	CCSprite** greenChamberPrototypes;
	CCSprite** redChamberPrototypes;
	CCRenderTexture* mazeTexture;
	int mazeSize;
	Byte*** topology;
	CGPoint*** positionCache;
}

-(CGPoint) getChamberPos: (FS3DPoint) coords;
-(void) redrawMazeTexture;
- (void) onPositionChanged: (NSNotification*) notification;
@end
