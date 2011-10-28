//
//  TutorialLayer.h
//  Hypermaze
//
//  Created by Jakub Gruszecki on 15.10.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "CCDialog.h"

@class Game;
@class RadialMenuLayer;

#define POS_START_ARROW				ccp(567,768-378)
#define POS_END_ARROW				ccp(512,768- 29)
#define POS_MENU_ARROW				ccp(512,768-620)

#define POP_BORDERBOTTOM_ARROW		ccp(512,768-438)
#define POP_BORDERLEFT_ARROW		ccp(284,768-273)
#define POP_BORDERRIGHT_ARROW		ccp(747,768-273)

#define POS_NWL_ARROW				ccp( 45,768-528)
#define POS_SWL_ARROW				ccp( 45,768-655)
#define POS_NL_ARROW				ccp(122,768-528)
#define POS_SL_ARROW				ccp(122,768-655)
#define POS_NEL_ARROW				ccp(200,768-528)
#define POS_SEL_ARROW				ccp(200,768-655)

#define POS_NWR_ARROW				ccp(827,768-528)
#define POS_SWR_ARROW				ccp(827,768-655)
#define POS_NR_ARROW				ccp(902,768-528)
#define POS_SR_ARROW				ccp(902,768-655)
#define POS_NER_ARROW				ccp(978,768-528)
#define POS_SER_ARROW				ccp(978,768-655)

#define POS_CLOCKWISEL_ARROW		ccp( 72,768-385)
#define POS_COUNTERCLOCKWISEL_ARROW	ccp(174,768-385)
#define POS_CLOCKWISER_ARROW		ccp(851,768-385)
#define POS_COUNTERCLOCKWISER_ARROW ccp(953,768-385)

#define POS_CLOCK_ARROW				ccp(348,768- 33)
#define POS_MOVES_ARROW				ccp(432,768- 33)
#define POS_UNVISITED_ARROW			ccp(536,768- 33)
#define POS_VISITED_ARROW			ccp(648,768- 33)

#define POS_BRAIN_ARROW				ccp(384,768-604)
#define POS_PLANES_ARROW			ccp(474,768-531)
#define POS_EYE_ARROW				ccp(561,768-531)
#define POS_GEAR_ARROW				ccp(654,768-604)

#define POS_SPEAKER_ARROW			ccp(473,768-428)
#define POS_NOTE_ARROW				ccp(574,768-435)
#define POS_X_ARROW					ccp(657,768-487)
#define POS_R_ARROW					ccp(705,768-574)

#define POS_MAZE_ARROW				ccp(454,768-433)
#define POS_CROSSHAIR_ARROW			ccp(555,768-429)
#define POS_BORDERS_ARROW			ccp(643,768-465)
#define POS_COMPASS_ARROW			ccp(700,768-550)

#define POS_XPLANE_ARROW			ccp(327,768-548)
#define POS_YPLANE_ARROW			ccp(383,768-466)
#define POS_ZPLANE_ARROW			ccp(474,768-428)
#define POS_RECURSIVE_ARROW			ccp(574,768-431)
#define POS_RECURSIVELEVELS_ARROW	ccp(611,768-372)

#define POS_WOOL_ARROW				ccp(318,768-572)
#define POS_BREAD_ARROW				ccp(367,768-485)
#define POS_SIGN_ARROW				ccp(451,768-432)
#define POS_FLAG_ARROW				ccp(555,768-430)
#define POS_BRUSH_ARROW				ccp(643,768-470)
#define POS_FLAGLEVELS_ARROW		ccp(576,768-375)

#define ANGLE_N		0
#define ANGLE_S		180
#define ANGLE_E		90
#define ANGLE_W		270
#define ANGLE_NW	315
#define ANGLE_SW	225
#define ANGLE_NE	45
#define ANGLE_SE	135

#define TUT_DISABLE_ALL_EVENT			@"TUT_DISABLE_ALL_EVENT"

#define TUT_ENABLE_MENU_EVENT			@"TUT_ENABLE_MENU_EVENT"
#define TUT_ENABLE_BRAIN_EVENT			@"TUT_ENABLE_BRAIN_EVENT"
#define TUT_ENABLE_PLANES_EVENT			@"TUT_ENABLE_PLANES_EVENT"
#define TUT_ENABLE_EYE_EVENT			@"TUT_ENABLE_EYE_EVENT"
#define TUT_ENABLE_GEAR_EVENT			@"TUT_ENABLE_GEAR_EVENT"
#define TUT_ENABLE_FLAG_EVENT			@"TUT_ENABLE_FLAG_EVENT"
#define TUT_ENABLE_WOOL_EVENT			@"TUT_ENABLE_WOOL_EVENT"
#define TUT_ENABLE_BREAD_EVENT			@"TUT_ENABLE_BREAD_EVENT"
#define TUT_ENABLE_SIGNPOST_EVENT		@"TUT_ENABLE_SIGNPOST_EVENT"
#define TUT_ENABLE_BRUSH_EVENT			@"TUT_ENABLE_BRUSH_EVENT"
#define TUT_ENABLE_PLANES_X_EVENT		@"TUT_ENABLE_PLANES_X_EVENT"
#define TUT_ENABLE_PLANES_Y_EVENT		@"TUT_ENABLE_PLANES_Y_EVENT"
#define TUT_ENABLE_PLANES_Z_EVENT		@"TUT_ENABLE_PLANES_Z_EVENT"
#define TUT_ENABLE_CROSS_EVENT			@"TUT_ENABLE_CROSS_EVENT"
#define TUT_ENABLE_MAZE_EVENT			@"TUT_ENABLE_MAZE_EVENT"
#define TUT_ENABLE_CROSSHAIR_EVENT		@"TUT_ENABLE_CROSSHAIR_EVENT"
#define TUT_ENABLE_CUBE_EVENT			@"TUT_ENABLE_CUBE_EVENT"
#define TUT_ENABLE_COMPASS_EVENT		@"TUT_ENABLE_COMPASS_EVENT"
#define TUT_ENABLE_SPEAKER_EVENT		@"TUT_ENABLE_SPEAKER_EVENT"
#define TUT_ENABLE_NOTE_EVENT			@"TUT_ENABLE_NOTE_EVENT"
#define TUT_ENABLE_X_EVENT				@"TUT_ENABLE_X_EVENT"
#define TUT_ENABLE_R_EVENT				@"TUT_ENABLE_R_EVENT"
#define TUT_ENABLE_FLAG_SLIDER_EVENT	@"TUT_ENABLE_FLAG_SLIDER_EVENT"
#define TUT_ENABLE_CROSS_SLIDER_EVENT	@"TUT_ENABLE_CROSS_SLIDER_EVENT"

#define TUT_ENABLE_N_EVENT				@"TUT_ENABLE_N_EVENT"
#define TUT_ENABLE_S_EVENT				@"TUT_ENABLE_S_EVENT"
#define TUT_ENABLE_NW_EVENT				@"TUT_ENABLE_NW_EVENT"
#define TUT_ENABLE_NE_EVENT				@"TUT_ENABLE_NE_EVENT"
#define TUT_ENABLE_SW_EVENT				@"TUT_ENABLE_SW_EVENT"
#define TUT_ENABLE_SE_EVENT				@"TUT_ENABLE_SE_EVENT"
#define TUT_ENABLE_ROTATIONS_EVENT		@"TUT_ENABLE_ROTATIONS_EVENT"

@interface TutorialLayer : CCLayer {
	
	int stepNum;
	int rotationState;
	int planesState;
	
	CCSprite* startArrow;
	CCSprite* endArrow;
	CCSprite* menuArrow;
	
	CCSprite* borderTopArrow;
	CCSprite* borderLeftArrow;
	CCSprite* borderRightArrow;
	
	CCSprite* NWArrowL;
	CCSprite* SWArrowL;
	CCSprite* NArrowL;
	CCSprite* SArrowL;
	CCSprite* NEArrowL;
	CCSprite* SEArrowL;
	
	CCSprite* NWArrowR;
	CCSprite* SWArrowR;
	CCSprite* NArrowR;
	CCSprite* SArrowR;
	CCSprite* NEArrowR;
	CCSprite* SEArrowR;
	
	CCSprite* clockwiseArrowL;
	CCSprite* countercolckwiseArrowL;
	CCSprite* clockwiseArrowR;
	CCSprite* countercolckwiseArrowR;
	
	CCSprite* clockArrow;
	CCSprite* movesArrow;
	CCSprite* unvisitedArrow;
	CCSprite* visitedArrow;
	
	CCSprite* brainArrow;
	CCSprite* planesArrow;
	CCSprite* eyeArrow;
	CCSprite* gearArrow;
	
	CCSprite* speakerArrow;
	CCSprite* noteArrow;
	CCSprite* xArrow;
	CCSprite* rArrow;
	
	CCSprite* mazeArrow;
	CCSprite* crosshairArrow;
	CCSprite* bordersArrow;
	CCSprite* compassArrow;
	
	CCSprite* xPlaneArrow;
	CCSprite* yPlaneArrow;
	CCSprite* zPlaneArrow;
	CCSprite* recursiveArrow;
	CCSprite* recursiveLevelsArrow;
	
	CCSprite* woolArrow;
	CCSprite* breadArrow;
	CCSprite* signArrow;
	CCSprite* flagArrow;
	CCSprite* flagLevelsArrow;
	CCSprite* brushArrow;
	
	NSArray* arrows;
	
	CCDialog* dialog;
	CCDialog* endDialog;
	CCDialog* confirmEnd;
	
	CCLabelTTF* message;
	CCMenuItemLabel* nextButton;
	
	RadialMenuLayer* radialMenu;
	Game* game;
	
	NSDictionary* arrowButtonTree;
	NSMutableSet* visibleArrows;
	NSDictionary* toggleArrowDict;
}

- (id)initWithGame: (Game*) aGame radialMenu: (RadialMenuLayer*) aRadialMenu;
- (void) openDialog: (CCScene*) scene;
- (void) nextStep;

@end
