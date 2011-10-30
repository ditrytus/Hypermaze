//
//  RadialMenuLayer.h
//  Hypermaze
//
//  Created by Jakub Gruszecki on 20.08.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"
#import "FSRadialAligner.h"
#import "HPLogic.h"
#import "RadialMenuParticleSystem.h"
#import "TutorialLayer.h"
#import "HPSound.h"

#define RAD_CHANGE_EVENT @"RAD_CHANGE_EVENT"
#define RAD_CHANGE_USER_INFO @"toggledItem"

@class Game;

@interface RadialMenuLayer : CCLayer {
	bool isMenuOpened;
	bool isEnabled;
	
	HPLogic* logic;
	
	CCMenuItemToggle* menuToggle;
	CCMenuItemToggle* brainToggle;
	NSIndexPath* brainIndexPath;
	CCMenuItemToggle* planesToggle;
	NSIndexPath* planesIndexPath;
	CCMenuItemToggle* eyeToggle;
	NSIndexPath* eyeIndexPath;
	CCMenuItemToggle* gearToggle;
	NSIndexPath* gearIndexPath;

	CCMenuItemToggle* flagToggle;
	NSIndexPath* flagIndexPath;
	CCMenuItemToggle* woolToggle;
	NSIndexPath* woolIndexPath;
	CCMenuItemToggle* breadToggle;
	NSIndexPath* breadIndexPath;
	CCMenuItemToggle* signpostToggle;
	NSIndexPath* signpostIndexPath;
	CCMenuItemToggle* brushToggle;
	NSIndexPath* brushIndexPath;
	
	CCMenuItemToggle* planesXToggle;
	NSIndexPath* planesXIndexPath;
	CCMenuItemToggle* planesYToggle;
	NSIndexPath* planesYIndexPath;
	CCMenuItemToggle* planesZToggle;
	NSIndexPath* planesZIndexPath;
	CCMenuItemToggle* crossToggle;
	NSIndexPath* crossIndexPath;
	
	CCMenuItemToggle* mazeToggle;
	NSIndexPath* mazeIndexPath;
	CCMenuItemToggle* crosshairToggle;
	NSIndexPath* crosshairIndexPath;
	CCMenuItemToggle* cubeToggle;
	NSIndexPath* cubeIndexPath;
	CCMenuItemToggle* compassToggle;
	NSIndexPath* compassIndexPath;
	
	CCMenuItemToggle* speakerToggle;
	NSIndexPath* speakerIndexPath;
	CCMenuItemToggle* noteToggle;
	NSIndexPath* noteIndexPath;
	CCMenuItemToggle* xToggle;
	NSIndexPath* xIndexPath;
	CCMenuItemToggle* rToggle;
	NSIndexPath* rIndexPath;
	
	CCMenuItemToggle* okXToggle;
	NSIndexPath* okXIndexPath;
	
	CCMenuItemToggle* okRToggle;
	NSIndexPath* okRIndexPath;
	
	NSMutableArray* flagSliderItems;
	NSMutableArray* crossSliderItems;
	
	CCSprite* background;
	FSRadialAligner* aligner;
	
	Game* game;
	CCLabelTTF* tooltipLabel;
	
	NSMutableDictionary* enabilityMap;
	NSMutableDictionary* itemsTooltipMap;
}

@property(readonly, nonatomic) CCMenuItemToggle* menuToggle;
@property(readonly, nonatomic) CCMenuItemToggle* brainToggle;
@property(readonly, nonatomic) CCMenuItemToggle* planesToggle;
@property(readonly, nonatomic) CCMenuItemToggle* eyeToggle;
@property(readonly, nonatomic) CCMenuItemToggle* gearToggle;
@property(readonly, nonatomic) CCMenuItemToggle* flagToggle;
@property(readonly, nonatomic) CCMenuItemToggle* woolToggle;
@property(readonly, nonatomic) CCMenuItemToggle* breadToggle;
@property(readonly, nonatomic) CCMenuItemToggle* signpostToggle;
@property(readonly, nonatomic) CCMenuItemToggle* brushToggle;
@property(readonly, nonatomic) CCMenuItemToggle* planesXToggle;
@property(readonly, nonatomic) CCMenuItemToggle* planesYToggle;
@property(readonly, nonatomic) CCMenuItemToggle* planesZToggle;
@property(readonly, nonatomic) CCMenuItemToggle* crossToggle;
@property(readonly, nonatomic) CCMenuItemToggle* mazeToggle;
@property(readonly, nonatomic) CCMenuItemToggle* crosshairToggle;
@property(readonly, nonatomic) CCMenuItemToggle* cubeToggle;
@property(readonly, nonatomic) CCMenuItemToggle* compassToggle;
@property(readonly, nonatomic) CCMenuItemToggle* speakerToggle;
@property(readonly, nonatomic) CCMenuItemToggle* noteToggle;
@property(readonly, nonatomic) CCMenuItemToggle* xToggle;
@property(readonly, nonatomic) CCMenuItemToggle* rToggle;
@property(readonly, nonatomic) CCMenuItemToggle* okXToggle;
@property(readonly, nonatomic) CCMenuItemToggle* okRToggle;

@property(readonly, nonatomic) NSMutableArray* flagSliderItems;
@property(readonly, nonatomic) NSMutableArray* crossSliderItems;

- (id)initWithLogic: (HPLogic*) innerLogic game: (Game*) newGame  isInTutorial: (BOOL) isInTutorial;

- (void) onMenuToggle: (CCMenuItemToggle*) item;
- (CCMenuItemToggle*) menuItemFromOnFrameName: (NSString*) onFrameName offFrameName: (NSString*) offFrameName target: (SEL) target;
- (CCMenuItemToggle*) hiddenMenuItemFromOnFrameName: (NSString*) onFrameName offFrameName: (NSString*) offFrameName target: (SEL) target;
- (void) onPlanesToggle: (CCMenuItemToggle*) item;
- (void) onEyeToggle: (CCMenuItemToggle*) item;
- (void) onGearToggle: (CCMenuItemToggle*) item;
- (void) showX;
- (void) setXHidden;
- (void) hideXToLevel: (int) level;
- (void) showR;
- (void) setRHidden;
- (void) hideRToLevel: (int) level;
- (void) onRToggle: (CCMenuItemToggle*) item;
- (void) renderFlagSliderValue;

@end
