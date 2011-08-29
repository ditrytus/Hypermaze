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

@interface RadialMenuLayer : CCLayer {
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
	
	CCMenuItem* okXToggle;
	NSIndexPath* okXIndexPath;
	
	CCMenuItem* okRToggle;
	NSIndexPath* okRIndexPath;
	
	NSMutableArray* flagSliderItems;
	NSMutableArray* crossSliderItems;
	
	FSRadialAligner* aligner;
	
}

- (id)initWithLogic: (HPLogic*) innerLogic;

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
