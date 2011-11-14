//
//  RadialMenuLayer.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 20.08.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CCTouchDispatcher.h"
#import "RadialMenuLayer.h"
#import "MainMenuLayer.h"
#import "HPConfiguration.h"
#import <math.h>
#import "Game.h"

@implementation RadialMenuLayer

@synthesize menuToggle;
@synthesize brainToggle;
@synthesize planesToggle;
@synthesize eyeToggle;
@synthesize gearToggle;
@synthesize flagToggle;
@synthesize woolToggle;
@synthesize breadToggle;
@synthesize signpostToggle;
@synthesize brushToggle;
@synthesize planesXToggle;
@synthesize planesYToggle;
@synthesize planesZToggle;
@synthesize crossToggle;
@synthesize mazeToggle;
@synthesize crosshairToggle;
@synthesize cubeToggle;
@synthesize compassToggle;
@synthesize speakerToggle;
@synthesize noteToggle;
@synthesize xToggle;
@synthesize rToggle;
@synthesize okXToggle;
@synthesize okRToggle;

@synthesize flagSliderItems;
@synthesize crossSliderItems;

- (CCMenuItemToggle*) menuItemFromOnFrameName: (NSString*) onFrameName offFrameName: (NSString*) offFrameName target: (SEL) target {
	CCSprite* onSprite = [CCSprite spriteWithSpriteFrameName:onFrameName];
	CCMenuItemImage* onItem = [CCMenuItemImage itemFromNormalSprite:onSprite selectedSprite:nil];
	CCSprite* offSprite = [CCSprite spriteWithSpriteFrameName:offFrameName];
	CCMenuItemImage* offItem = [CCMenuItemImage itemFromNormalSprite:offSprite selectedSprite:nil];
	CCMenuItemToggle* toggleItem = [CCMenuItemToggle itemWithTarget:self selector:target items:offItem, onItem, nil];
	toggleItem.selectedIndex = 0;
	toggleItem.position = ccp(0,0);
	return toggleItem;
}

- (CCMenuItemToggle*) menuItemFromOnFileName: (NSString*) onFileName offFileName: (NSString*) offFileName target: (SEL) target {
	CCSprite* onSprite = [CCSprite spriteWithFile:onFileName];
	CCMenuItemImage* onItem = [CCMenuItemImage itemFromNormalSprite:onSprite selectedSprite:nil];
	CCSprite* offSprite = [CCSprite spriteWithFile: offFileName];
	CCMenuItemImage* offItem = [CCMenuItemImage itemFromNormalSprite:offSprite selectedSprite:nil];
	CCMenuItemToggle* toggleItem = [CCMenuItemToggle itemWithTarget:self selector:target items:offItem, onItem, nil];
	toggleItem.selectedIndex = 0;
	toggleItem.position = ccp(0,0);
	return toggleItem;
}
	
- (CCMenuItemToggle*) hiddenMenuItemFromOnFrameName: (NSString*) onFrameName offFrameName: (NSString*) offFrameName target: (SEL) target {
	CCMenuItemToggle* toggleItem = [self menuItemFromOnFrameName:onFrameName offFrameName:offFrameName target:target];
	[toggleItem setOpacity: 0.0];
	[toggleItem setIsEnabled: NO];
	[toggleItem setVisible:NO];
	return toggleItem;
}

- (CCMenuItemToggle*) hiddenMenuItemFromOnFileName: (NSString*) onFileName offFileName: (NSString*) offFileName target: (SEL) target {
	CCMenuItemToggle* toggleItem = [self menuItemFromOnFileName: onFileName offFileName:offFileName target:target];
	[toggleItem setOpacity: 0.0];
	[toggleItem setIsEnabled: NO];
	[toggleItem setVisible:NO];
	return toggleItem;
}

- (void) renderFlagSliderValue {
	for (int i=0; i< logic.checkpointTool.maxValue ; i++) {
		[((CCMenuItemToggle*)[flagSliderItems objectAtIndex:i]) setSelectedIndex: (i < [logic.checkpointTool getValue]) ? 1 : 0];
	}
}

- (void) renderCrossSliderValue {
	for (int i=0; i< logic.recursiveTool.maxValue ; i++) {
		[((CCMenuItemToggle*)[crossSliderItems objectAtIndex:i]) setSelectedIndex: (i < [logic.recursiveTool getValue]) ? 1 : 0];
	}
}

- (void)storeItemsEnability:(CCMenuItem *)item  {
	[enabilityMap setValue:[NSNumber numberWithBool: item.isEnabled] forKey:item.description];	
}


- (void)disableAll {
    NSMutableArray* keys = [NSMutableArray array];
    for (NSString* key in enabilityMap) {
        [keys addObject: key];
    }
    for (NSString* key in keys) {
        [enabilityMap setValue: [NSNumber numberWithBool:NO] forKey:key];
    }
    isEnabled = NO;
    menuToggle.isEnabled = NO;
    brainToggle.isEnabled = NO;
    planesToggle.isEnabled = NO;
    eyeToggle.isEnabled = NO;
    gearToggle.isEnabled = NO;
    flagToggle.isEnabled = NO;
    woolToggle.isEnabled = NO;
    breadToggle.isEnabled = NO;
    signpostToggle.isEnabled = NO;
    brushToggle.isEnabled = NO;
    planesXToggle.isEnabled = NO;
    planesYToggle.isEnabled = NO;
    planesZToggle.isEnabled = NO;
    crossToggle.isEnabled = NO;
    mazeToggle.isEnabled = NO;
    crosshairToggle.isEnabled = NO;
    cubeToggle.isEnabled = NO;
    compassToggle.isEnabled = NO;
    speakerToggle.isEnabled = NO;
    noteToggle.isEnabled = NO;
    xToggle.isEnabled = NO;
    rToggle.isEnabled = NO;
    okXToggle.isEnabled = NO;
    okRToggle.isEnabled = NO;
    for (CCMenuItem* item in flagSliderItems) {
        item.isEnabled = NO;
    }
    for (CCMenuItem* item in crossSliderItems) {
        item.isEnabled = NO;
    }
}

- (void)enableMenuItem:(CCMenuItem *)item {
    item.isEnabled = YES;
    [self storeItemsEnability:item];
    isEnabled = YES;
}

- (void)enableBrainToggle {
    [self enableMenuItem:brainToggle];
}

- (void)enableMenuToggle {
	[self enableMenuItem:menuToggle];
}

- (void)enablePlanesToggle {
	[self enableMenuItem:planesToggle];
}

- (void)enableEyeToggle {
	[self enableMenuItem:eyeToggle];
}

- (void)enableGearToggle {
	[self enableMenuItem:gearToggle];
}

- (void)enableFlagToggle {
	[self enableMenuItem:flagToggle];
}

- (void)enableWoolToggle {
	[self enableMenuItem:woolToggle];
}

- (void)enableBreadToggle {
	[self enableMenuItem:breadToggle];
}

- (void)enableSignpostToggle {
	[self enableMenuItem:signpostToggle];
}

- (void)enableBrushToggle {
	[self enableMenuItem:brushToggle];
}

- (void)enablePlanesXToggle {
	[self enableMenuItem:planesXToggle];
}

- (void)enablePlanesYToggle {
	[self enableMenuItem:planesYToggle];
}

- (void)enableZToggle {
	[self enableMenuItem:planesZToggle];
}

- (void)enableCrossToggle {
	[self enableMenuItem:crossToggle];
}

- (void)enableMazeToggle {
	[self enableMenuItem:mazeToggle];
}

- (void)enableCrosshairToggle {
	[self enableMenuItem:crosshairToggle];
}

- (void)enableCubeToggle {
	[self enableMenuItem:cubeToggle];
}

- (void)enableCompassToggle {
	[self enableMenuItem:compassToggle];
}

- (void)enableSpeakerToggle {
	[self enableMenuItem:speakerToggle];
}

- (void)enableNoteToggle {
	[self enableMenuItem:noteToggle];
}

- (void)enableXToggle {
	[self enableMenuItem:xToggle];
}

- (void)enableRToggle {
	[self enableMenuItem:rToggle];
}

- (void)enableSliderItems:(NSArray *)sliderItems {
    for (CCMenuItem* item in sliderItems) {
        item.isEnabled = YES;
        [self storeItemsEnability:item];
    }
    isEnabled = YES;
}

- (void)enableFlagSliderItems {
    [self enableSliderItems:flagSliderItems];
}

- (void)enableSliderItems {
	[self enableSliderItems:crossSliderItems];
}

- (void) wireupTutorialEvents {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disableAll) name:TUT_DISABLE_ALL_EVENT object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableBrainToggle) name:TUT_ENABLE_BRAIN_EVENT object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableMenuToggle) name:TUT_ENABLE_MENU_EVENT object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enablePlanesToggle) name:TUT_ENABLE_PLANES_EVENT object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableEyeToggle) name:TUT_ENABLE_EYE_EVENT object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableGearToggle) name:TUT_ENABLE_GEAR_EVENT object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableFlagToggle) name:TUT_ENABLE_FLAG_EVENT object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableWoolToggle) name:TUT_ENABLE_WOOL_EVENT object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableBreadToggle) name:TUT_ENABLE_BREAD_EVENT object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableSignpostToggle) name:TUT_ENABLE_SIGNPOST_EVENT object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableBrushToggle) name:TUT_ENABLE_BRUSH_EVENT object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enablePlanesXToggle) name:TUT_ENABLE_PLANES_X_EVENT object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enablePlanesYToggle) name:TUT_ENABLE_PLANES_Y_EVENT object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableZToggle) name:TUT_ENABLE_PLANES_Z_EVENT object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableCrossToggle) name:TUT_ENABLE_CROSS_EVENT object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableMazeToggle) name:TUT_ENABLE_MAZE_EVENT object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableCrosshairToggle) name:TUT_ENABLE_CROSSHAIR_EVENT object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableCubeToggle) name:TUT_ENABLE_CUBE_EVENT object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableCompassToggle) name:TUT_ENABLE_COMPASS_EVENT object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableSpeakerToggle) name:TUT_ENABLE_SPEAKER_EVENT object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableNoteToggle) name:TUT_ENABLE_NOTE_EVENT object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableXToggle) name:TUT_ENABLE_X_EVENT object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableRToggle) name:TUT_ENABLE_R_EVENT object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableFlagSliderItems) name:TUT_ENABLE_FLAG_SLIDER_EVENT object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableSliderItems) name:TUT_ENABLE_CROSS_SLIDER_EVENT object:nil];

}

- (id)initWithLogic: (HPLogic*) innerLogic game: (Game*) newGame isInTutorial: (BOOL) isInTutorial
{
    self = [super init];
    if (self) {

		if (isInTutorial)
			[self wireupTutorialEvents];


		game = newGame;
		isEnabled = !isInTutorial;
		isMenuOpened = false;
		logic = [innerLogic retain];
		
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"interface.plist" textureFile: @"interface.png"];
		
		menuToggle = [self menuItemFromOnFrameName:@"menu_on.png" offFrameName:@"menu_off.png" target:@selector(onMenuToggle:)];

		brainToggle = [self hiddenMenuItemFromOnFrameName:@"brain_on.png" offFrameName:@"brain_off.png" target:@selector(onBrainToggle:)];
		brainIndexPath = [[NSIndexPath indexPathWithIndex:0] retain];
		
		woolToggle = [self hiddenMenuItemFromOnFrameName:@"wool_on.png" offFrameName:@"wool_off.png" target:@selector(onWoolToggle:)];
		woolIndexPath= [[brainIndexPath indexPathByAddingIndex:0] retain];
		woolToggle.selectedIndex = logic.ariadnaTool.isEnabled ? 1 : 0;
		
		breadToggle = [self hiddenMenuItemFromOnFrameName:@"bread_on.png" offFrameName:@"bread_off.png" target:@selector(onBreadToggle:)];
		breadIndexPath= [[brainIndexPath indexPathByAddingIndex:1] retain];
		breadToggle.selectedIndex = logic.visitedTool.isEnabled ? 1 : 0;
		
		signpostToggle = [self hiddenMenuItemFromOnFrameName:@"signpost_on.png" offFrameName:@"signpost_off.png" target:@selector(onSignPostToggle:)];
		signpostIndexPath= [[brainIndexPath indexPathByAddingIndex:2] retain];
		signpostToggle.selectedIndex = logic.untakenTool.isEnabled ? 1 : 0;
		
		flagToggle = [self hiddenMenuItemFromOnFrameName:@"flag_on.png" offFrameName:@"flag_off.png" target:@selector(onFlagToggle:)];
		flagIndexPath= [[brainIndexPath indexPathByAddingIndex:3] retain];
		flagToggle.selectedIndex = logic.checkpointTool.isEnabled ? 1 : 0;
		
		flagSliderItems = [[NSMutableArray alloc] init];

		for (int i=0; i< logic.checkpointTool.maxValue ; i++) {
			CCMenuItemToggle* flagLevelToggle = [self hiddenMenuItemFromOnFileName:@"slider_on_yellow.png" offFileName:@"slider_off_yellow.png" target:@selector(onFlagLevelToggle:)];
			[flagSliderItems addObject: flagLevelToggle];
		}
		
		[self renderFlagSliderValue];

		
		brushToggle = [self hiddenMenuItemFromOnFrameName:@"brush_on.png" offFrameName:@"brush_off.png" target:@selector(onBrushToggle:)];
		brushIndexPath= [[brainIndexPath indexPathByAddingIndex:4] retain];
		brushToggle.selectedIndex = logic.markMask.isEnabled ? 1 : 0;
		
		planesToggle = [self hiddenMenuItemFromOnFrameName:@"planes_on.png" offFrameName:@"planes_off.png" target:@selector(onPlanesToggle:)];
		planesIndexPath = [[NSIndexPath indexPathWithIndex:1] retain];
		
		planesXToggle = [self hiddenMenuItemFromOnFrameName:@"plane_x_on.png" offFrameName:@"plane_x_off.png" target:@selector(onPlaneXToggle:)];
		planesXIndexPath= [[planesIndexPath indexPathByAddingIndex:0] retain];
		planesXToggle.selectedIndex = logic.xAxisTool.isEnabled ? 1 : 0;
		
		planesYToggle = [self hiddenMenuItemFromOnFrameName:@"plane_y_on.png" offFrameName:@"plane_y_off.png" target:@selector(onPlaneYToggle:)];
		planesYIndexPath= [[planesIndexPath indexPathByAddingIndex:1] retain];
		planesYToggle.selectedIndex = logic.yAxisTool.isEnabled ? 1 : 0;
		
		planesZToggle = [self hiddenMenuItemFromOnFrameName:@"plane_z_on.png" offFrameName:@"plane_z_off.png" target:@selector(onPlaneZToggle:)];
		planesZIndexPath= [[planesIndexPath indexPathByAddingIndex:2] retain];
		planesZToggle.selectedIndex = logic.zAxisTool.isEnabled ? 1 : 0;
		
		crossToggle	= [self hiddenMenuItemFromOnFrameName:@"cross_on.png" offFrameName:@"cross_off.png" target:@selector(onCrossToggle:)];
		crossIndexPath = [[planesIndexPath indexPathByAddingIndex:3] retain];
		crossToggle.selectedIndex = logic.recursiveTool.isEnabled ? 1 : 0;

		crossSliderItems = [[NSMutableArray alloc] init];
		
		for (int i=0; i < logic.recursiveTool.maxValue ; i++) {
			CCMenuItemToggle* crossLevelToggle = [self hiddenMenuItemFromOnFileName:@"slider_on_pink.png" offFileName:@"slider_off_pink.png" target:@selector(onCrossLevelToggle:)];
			[crossSliderItems addObject: crossLevelToggle];
		}
		
		[self renderCrossSliderValue];

		eyeToggle = [self hiddenMenuItemFromOnFrameName:@"eye_on.png" offFrameName:@"eye_off.png" target:@selector(onEyeToggle:)];
		eyeIndexPath = [[NSIndexPath indexPathWithIndex:2] retain];
		
		mazeToggle = [self hiddenMenuItemFromOnFrameName:@"maze_on.png" offFrameName:@"maze_off.png" target:@selector(onMazeToggle:)];
		mazeIndexPath= [[eyeIndexPath indexPathByAddingIndex:0] retain];
		mazeToggle.selectedIndex = logic.mazeTool.isEnabled ? 1 : 0;
		
		crosshairToggle = [self hiddenMenuItemFromOnFrameName:@"crosshair_on.png" offFrameName:@"crosshair_off.png" target:@selector(onCrosshairToggle:)];
		crosshairIndexPath = [[eyeIndexPath indexPathByAddingIndex:1] retain];
		crosshairToggle.selectedIndex = logic.showTarget ? 1 : 0;
		
		cubeToggle = [self hiddenMenuItemFromOnFrameName:@"cube_on.png" offFrameName:@"cube_off.png" target:@selector(onCubeToggle:)];
		cubeIndexPath= [[eyeIndexPath indexPathByAddingIndex:2] retain];
		cubeToggle.selectedIndex = logic.showBorders ? 1 : 0;
		
		compassToggle = [self hiddenMenuItemFromOnFrameName:@"compass_on.png" offFrameName:@"compass_off.png" target:@selector(onCompassToggle:)];
		compassIndexPath = [[eyeIndexPath indexPathByAddingIndex:3] retain];
		compassToggle.selectedIndex = logic.showCompass ? 1 : 0;
				
		gearToggle = [self hiddenMenuItemFromOnFrameName:@"gear_on.png" offFrameName:@"gear_off.png" target:@selector(onGearToggle:)];
		gearIndexPath = [[NSIndexPath indexPathWithIndex:3] retain];
		
		speakerToggle = [self hiddenMenuItemFromOnFrameName:@"speaker_on.png" offFrameName:@"speaker_off.png" target:@selector(onSpeakerToggle:)];
		speakerIndexPath = [[gearIndexPath indexPathByAddingIndex:0] retain];
		speakerToggle.selectedIndex = [[HPConfiguration sharedConfiguration].sound boolValue] ? 0 : 1;
		
		noteToggle = [self hiddenMenuItemFromOnFrameName:@"note_on.png" offFrameName:@"note_off.png" target:@selector(onNoteToggle:)];
		noteIndexPath = [[gearIndexPath indexPathByAddingIndex:1] retain];
		noteToggle.selectedIndex = [[HPConfiguration sharedConfiguration].music boolValue] ? 0 : 1;
		
		xToggle	= [self hiddenMenuItemFromOnFrameName:@"x_on.png" offFrameName:@"x_off.png" target:@selector(onXToggle:)];
		xIndexPath = [[gearIndexPath indexPathByAddingIndex:2] retain];
		
		okXToggle = [self hiddenMenuItemFromOnFrameName:@"ok_on.png" offFrameName:@"ok_off.png" target:@selector(onOkXToggle:)];
		okXIndexPath = [[xIndexPath indexPathByAddingIndex:0] retain];
		
		rToggle = [self hiddenMenuItemFromOnFrameName:@"r_on.png" offFrameName:@"r_off.png" target:@selector(onRToggle:)];
		rIndexPath = [[gearIndexPath indexPathByAddingIndex:3] retain];
		
		okRToggle = [self hiddenMenuItemFromOnFrameName:@"ok_on.png" offFrameName:@"ok_off.png" target:@selector(onOkRToggle:)];
		okRIndexPath = [[rIndexPath indexPathByAddingIndex:0] retain];
		
		CCMenu* radialMenu = [CCMenu menuWithItems:
							  okXToggle, okRToggle,
							  woolToggle, breadToggle, signpostToggle, flagToggle, brushToggle,
							  planesXToggle, planesYToggle, planesZToggle, crossToggle,
							  mazeToggle, crosshairToggle, cubeToggle, compassToggle,
							  speakerToggle, noteToggle, xToggle, rToggle,
							  brainToggle, planesToggle, eyeToggle, gearToggle,
							  menuToggle, nil];
		
		for (CCMenuItemToggle* flagSliderItem in flagSliderItems) {
			[radialMenu addChild:flagSliderItem];
		}
		for (CCMenuItemToggle* crossSliderItem in crossSliderItems) {
			[radialMenu addChild:crossSliderItem];
		}
		
		CGSize size = [[CCDirector sharedDirector] winSize];
		
		background = [CCSprite spriteWithFile:@"menu_bkg.png"];
		background.position = ccp(size.width / 2.0 ,size.height/2.0+150);
		background.scale = 2.0;
		background.visible = NO;		
		[self addChild: background];

		[self addChild: radialMenu];

		tooltipLabel = [CCLabelTTF labelWithString:@"TooltipLabel" fontName:@"Arial" fontSize:12];
		tooltipLabel.color = ccWHITE;
		tooltipLabel.position = ccp(size.width / 2.0 ,size.height/2.0-65);
		tooltipLabel.visible = NO;
		[self addChild: tooltipLabel];

		itemsTooltipMap = [[NSMutableDictionary dictionaryWithObjectsAndKeys:
							@"Game menu", menuToggle.description, 
							@"Hints menu", brainToggle.description, 
							@"Planes menu", planesToggle.description, 
							@"View menu", eyeToggle.description, 
							@"Settings menu", gearToggle.description, 
							@"Checkpoints", flagToggle.description, 
							@"Path from the current position to the entrance", woolToggle.description, 
							@"All visited chambers", breadToggle.description, 
							@"Unused crossroads", signpostToggle.description, 
							@"Mark chambers with different colors", brushToggle.description,	
							@"Chambers on the same plane as the current chamber", planesXToggle.description,	
							@"Chambers on the same plane as the current chamber", planesYToggle.description,	
							@"Chambers on the same plane as the current chamber", planesZToggle.description,	
							@"Chambers adjustent to the current chamber", crossToggle.description,	
							@"Entire maze", mazeToggle.description,
							@"Current chamber on top", crosshairToggle.description,
							@"Borders of the maze", cubeToggle.description,		
							@"Compass", compassToggle.description,	
							@"Sound", speakerToggle.description,	
							@"Music", noteToggle.description,		
							@"Back to main menu", xToggle.description,		
							@"Reset game", rToggle.description,		
							@"Confirm", okXToggle.description,		
							@"Confirm", okRToggle.description,
							nil] retain];

		[self setPosition: ccp(0,-size.height/2.0 + 100)];

		aligner	= [[FSRadialAligner alloc] initWithAngle:M_PI/1.2 radius:100 margin:100 root:
				   [NSMutableArray arrayWithObjects:
					[NSMutableArray arrayWithObjects:woolToggle, breadToggle, signpostToggle, flagSliderItems, brushToggle, nil],
					[NSMutableArray arrayWithObjects:planesXToggle, planesYToggle, planesZToggle, crossSliderItems, nil],
					[NSMutableArray arrayWithObjects:mazeToggle, crosshairToggle, cubeToggle, compassToggle, nil],
					[NSMutableArray arrayWithObjects:
					 speakerToggle,
					 noteToggle,
					 [NSMutableArray arrayWithObjects:okXIndexPath, nil],
					 [NSMutableArray arrayWithObjects:okRIndexPath, nil],
					 nil],
					nil]];

		enabilityMap = [[NSMutableDictionary dictionaryWithObjectsAndKeys:
						[NSNumber numberWithBool:!isInTutorial], menuToggle.description, 
						[NSNumber numberWithBool:!isInTutorial], brainToggle.description, 
						[NSNumber numberWithBool:!isInTutorial], planesToggle.description, 
						[NSNumber numberWithBool:!isInTutorial], eyeToggle.description, 
						[NSNumber numberWithBool:!isInTutorial], gearToggle.description, 
						[NSNumber numberWithBool:!isInTutorial], flagToggle.description, 
						[NSNumber numberWithBool:!isInTutorial], woolToggle.description, 
						[NSNumber numberWithBool:!isInTutorial], breadToggle.description, 
						[NSNumber numberWithBool:!isInTutorial], signpostToggle.description, 
						[NSNumber numberWithBool:!isInTutorial], brushToggle.description,	
						[NSNumber numberWithBool:!isInTutorial], planesXToggle.description,	
						[NSNumber numberWithBool:!isInTutorial], planesYToggle.description,	
						[NSNumber numberWithBool:!isInTutorial], planesZToggle.description,	
						[NSNumber numberWithBool:!isInTutorial], crossToggle.description,	
						[NSNumber numberWithBool:!isInTutorial], mazeToggle.description,
						[NSNumber numberWithBool:!isInTutorial], crosshairToggle.description,
						[NSNumber numberWithBool:!isInTutorial], cubeToggle.description,		
						[NSNumber numberWithBool:!isInTutorial], compassToggle.description,	
						[NSNumber numberWithBool:!isInTutorial], speakerToggle.description,	
						[NSNumber numberWithBool:!isInTutorial], noteToggle.description,		
						[NSNumber numberWithBool:!isInTutorial], xToggle.description,		
						[NSNumber numberWithBool:!isInTutorial], rToggle.description,		
						[NSNumber numberWithBool:!isInTutorial], okXToggle.description,		
						[NSNumber numberWithBool:!isInTutorial], okRToggle.description,		
						 nil] retain];

		for (CCMenuItem* item in flagSliderItems) {
			[enabilityMap setObject:[NSNumber numberWithBool:!isInTutorial] forKey:item.description];
			[itemsTooltipMap setObject:@"Number of checkpoints being displayed" forKey:item.description];
		}
		for (CCMenuItem* item in crossSliderItems) {
			[enabilityMap setObject:[NSNumber numberWithBool:!isInTutorial] forKey:item.description];
			[itemsTooltipMap setObject:@"Number of adjustent chambers being displayed" forKey:item.description];
		}
		[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    }
    
    return self;
}
	
- (void) showNodeFromRoot:(CCMenuItem*) node index: (NSIndexPath*) index radiusDelta: (int) radius marginDelata: (int) margin {
	[node stopAllActions];
	[node runAction: [CCSequence actions:
					  [CCCallBlock actionWithBlock:^{ [node setVisible:YES]; }],
					  [CCSpawn actions:
					   [CCEaseBounceOut actionWithAction:[CCMoveTo actionWithDuration:0.5 position:[aligner alignElementOnIndex: index radiusDelta: radius marginDelta:margin]]],
					   [CCFadeIn actionWithDuration:0.5],
					   nil],
					  nil]];
	[node setIsEnabled: [((NSNumber*)[enabilityMap objectForKey: node.description]) boolValue]];
}

- (void) showNodeFromRoot:(CCMenuItem*) node index: (NSIndexPath*) index {
	[self showNodeFromRoot:node index:index radiusDelta:0 marginDelata:0];
}

- (void) hideNode:(CCMenuItem*) item onIndex: (NSIndexPath*) index toLevel: (int) level radiusDelta: (int) radius marginDelata: (int) margin {
	CGPoint position;
	if (level == 0){
		position = ccp(0,0);
	} else {
		position = [aligner alignElementOnIndex:index radiusDelta: radius + [aligner getRadiusDeltaForIndex: index level: level] marginDelta:margin];
	}
	[item stopAllActions];
	[item runAction: [CCSequence actions:
					  [CCSpawn actions:
					   [CCEaseBounceOut actionWithAction:[CCMoveTo actionWithDuration:0.5 position:position]],
					   [CCFadeOut actionWithDuration:0.5],
					   nil],
					  [CCCallBlock actionWithBlock:^{ [item setVisible:NO]; }],
					  nil]];
	[item setIsEnabled:NO];
}

- (void) hideNode:(CCMenuItem*) item onIndex: (NSIndexPath*) index toLevel: (int) level  {
	[self hideNode:item onIndex:index toLevel:level radiusDelta:0 marginDelata:0];
}


- (void) setHiddenNode: (CCMenuItem*) node onIndex: (NSIndexPath*) index toLevel: (int) level radiusDelta: (int) radius marginDelta: (int) margin {
	float radiusDelta = [aligner getRadiusDeltaForIndex: index level: level] + radius;
	node.position = [aligner alignElementOnIndex:index radiusDelta: radiusDelta marginDelta:margin];
}

- (void) setHiddenNode: (CCMenuItem*) node onIndex: (NSIndexPath*) index toLevel: (int) level {
	[self setHiddenNode:node onIndex:index toLevel:level radiusDelta:0 marginDelta:0];
}

- (void) showFlag {
	for(int i=0; i<[flagSliderItems count]; i++) {
		[self showNodeFromRoot:[flagSliderItems objectAtIndex: i] index: [flagIndexPath indexPathByAddingIndex:i] radiusDelta:-20 marginDelata:-50];
	}
}

- (void) setFlagHidden {
	int level = [flagIndexPath length];
	for (int i=0; i<[flagSliderItems count]; i++) {
		[self setHiddenNode:[flagSliderItems objectAtIndex: i] onIndex: [flagIndexPath indexPathByAddingIndex:i] toLevel: level radiusDelta:-20 marginDelta:-50];
	}
}

- (void) hideFlagToLevel: (int) level {
	for(int i=0; i<[flagSliderItems count]; i++) {
		[self hideNode:[flagSliderItems objectAtIndex: i] onIndex:[flagIndexPath indexPathByAddingIndex:i] toLevel:level radiusDelta:-20 marginDelata:-50];
	}
}

- (void) showBrain {
	[self showNodeFromRoot: woolToggle index: woolIndexPath];
	[self showNodeFromRoot: breadToggle index: breadIndexPath];
	[self showNodeFromRoot: signpostToggle index: signpostIndexPath];
	[self showNodeFromRoot: flagToggle index: flagIndexPath];
	if ([flagToggle selectedIndex] == 0) {
		[self setFlagHidden];
	} else {
		[self showFlag];
	}
	[self showNodeFromRoot:brushToggle index: brushIndexPath];
}

- (void) setBrainHidden {
	int level = [brainIndexPath length];
	[self setHiddenNode: woolToggle onIndex:woolIndexPath toLevel: level];
	[self setHiddenNode: breadToggle onIndex: breadIndexPath toLevel: level];
	[self setHiddenNode: signpostToggle onIndex:signpostIndexPath toLevel: level];
	[self setHiddenNode: flagToggle onIndex:flagIndexPath toLevel: level];
	[self setHiddenNode: brushToggle onIndex:brushIndexPath toLevel: level];
}

- (void) hideBrainToLevel: (int) level {
	[self hideNode:woolToggle onIndex:woolIndexPath toLevel:level];
	[self hideNode:breadToggle onIndex:breadIndexPath toLevel:level];
	[self hideNode:signpostToggle onIndex:signpostIndexPath toLevel:level];
	[self hideNode:flagToggle onIndex:flagIndexPath toLevel:level];
	[self hideFlagToLevel:level];
	[self hideNode:brushToggle onIndex:brushIndexPath toLevel:level];
}

- (void) showCross {
	for(int i=0; i<[crossSliderItems count]; i++) {
		[self showNodeFromRoot:[crossSliderItems objectAtIndex: i] index: [crossIndexPath indexPathByAddingIndex:i] radiusDelta:-20 marginDelata:-50];
	}
}

- (void) setCrossHidden {
	int level = [crossIndexPath length];
	for (int i=0; i<[crossSliderItems count]; i++) {
		[self setHiddenNode:[crossSliderItems objectAtIndex: i] onIndex: [crossIndexPath indexPathByAddingIndex:i] toLevel: level radiusDelta:-20 marginDelta:-50];
	}
}

- (void) hideCrossToLevel: (int) level {
	for(int i=0; i<[crossSliderItems count]; i++) {
		[self hideNode:[crossSliderItems objectAtIndex: i] onIndex:[crossIndexPath indexPathByAddingIndex:i] toLevel:level radiusDelta:-20 marginDelata:-50];
	}
}

- (void) showPlanes {
	[self showNodeFromRoot:planesXToggle index: planesXIndexPath];
	[self showNodeFromRoot:planesYToggle index: planesYIndexPath];
	[self showNodeFromRoot:planesZToggle index: planesZIndexPath];
	[self showNodeFromRoot:crossToggle index: crossIndexPath];
	if ([crossToggle selectedIndex] == 0) {
		[self setCrossHidden];
	} else {
		[self showCross];
	}
}

- (void) setPlanesHidden {
	int level = [planesIndexPath length];
	[self setHiddenNode: planesXToggle onIndex:planesXIndexPath toLevel: level];
	[self setHiddenNode: planesYToggle onIndex: planesYIndexPath toLevel: level];
	[self setHiddenNode: planesZToggle onIndex:planesZIndexPath toLevel: level];
	[self setHiddenNode: crossToggle onIndex:crossIndexPath toLevel: level];
}

- (void) hidePlanesToLevel: (int) level {
	[self hideNode:planesXToggle onIndex:planesXIndexPath toLevel:level];
	[self hideNode:planesYToggle onIndex:planesYIndexPath toLevel:level];
	[self hideNode:planesZToggle onIndex:planesZIndexPath toLevel:level];
	[self hideNode:crossToggle onIndex:crossIndexPath toLevel:level];
	[self hideCrossToLevel:level];
}

- (void) showEye {
	[self showNodeFromRoot:mazeToggle index: mazeIndexPath];
	[self showNodeFromRoot:crosshairToggle index: crosshairIndexPath];
	[self showNodeFromRoot:compassToggle index: compassIndexPath];
	[self showNodeFromRoot:cubeToggle index: cubeIndexPath];
}

- (void) setEyeHidden {
	int level = [eyeIndexPath length];
	[self setHiddenNode: mazeToggle onIndex:mazeIndexPath toLevel: level];
	[self setHiddenNode: crosshairToggle onIndex: crosshairIndexPath toLevel: level];
	[self setHiddenNode: compassToggle onIndex:compassIndexPath toLevel: level];
	[self setHiddenNode: cubeToggle onIndex:cubeIndexPath toLevel: level];
}

- (void) hideEyeToLevel: (int) level {
	[self hideNode:mazeToggle onIndex:mazeIndexPath toLevel:level];
	[self hideNode:crosshairToggle onIndex:crosshairIndexPath toLevel:level];
	[self hideNode:compassToggle onIndex:compassIndexPath toLevel:level];
	[self hideNode:cubeToggle onIndex:cubeIndexPath toLevel:level];
}


- (void) showGear {
	[self showNodeFromRoot:speakerToggle index: speakerIndexPath];
	[self showNodeFromRoot:noteToggle index: noteIndexPath];
	[self showNodeFromRoot:xToggle index: xIndexPath];
	[self setXHidden];
	[self showNodeFromRoot:rToggle index: rIndexPath];
}

- (void) setGearHidden {
	int level = [eyeIndexPath length];
	[self setHiddenNode: speakerToggle onIndex:speakerIndexPath toLevel: level];
	[self setHiddenNode: noteToggle onIndex: noteIndexPath toLevel: level];
	[self setHiddenNode: xToggle onIndex:xIndexPath toLevel: level];
	[self setHiddenNode: rToggle onIndex:rIndexPath toLevel: level];
}

- (void) hideGearToLevel: (int) level {
	[self hideNode:speakerToggle onIndex:speakerIndexPath toLevel:level];
	[self hideNode:noteToggle onIndex:noteIndexPath toLevel:level];
	[self hideNode:xToggle onIndex:xIndexPath toLevel:level];
	[self hideXToLevel: level];
	xToggle.selectedIndex = 0;
	[self hideNode:rToggle onIndex:rIndexPath toLevel:level];
	[self hideRToLevel: level];
	rToggle.selectedIndex = 0;
}

- (void) showX {
	[self showNodeFromRoot:okXToggle index: okXIndexPath];
}

- (void) setXHidden {
	int level = [xIndexPath length];
	[self setHiddenNode: okXToggle onIndex:okXIndexPath toLevel: level];
}

- (void) hideXToLevel: (int) level {
	[self hideNode:okXToggle onIndex:okXIndexPath toLevel:level];
}

- (void) showR {
	[self showNodeFromRoot:okRToggle index: okRIndexPath];
}

- (void) setRHidden {
	int level = [xIndexPath length];
	[self setHiddenNode: okRToggle onIndex:okRIndexPath toLevel: level];
}

- (void) hideRToLevel: (int) level {
	[self hideNode:okRToggle onIndex:okRIndexPath toLevel:level];
}

- (void) showMenu {
	isMenuOpened = true;
	[background runAction:[CCSequence actions:
						   [CCCallBlock actionWithBlock:^{ [background setVisible:YES]; }],
						   [CCFadeIn actionWithDuration:0.25],
						   nil]];
	[tooltipLabel runAction:[CCSequence actions:
						   [CCCallBlock actionWithBlock:^{ [tooltipLabel setVisible:YES]; }],
						   [CCFadeIn actionWithDuration:0.25],
						   nil]];
	[self showNodeFromRoot:brainToggle index: brainIndexPath];
	if ([brainToggle selectedIndex] == 0) {
		[self setBrainHidden];
	} else {
		[self showBrain];
	}
	[self showNodeFromRoot:planesToggle index: planesIndexPath];
	if ([planesToggle selectedIndex] == 0) {
		[self setPlanesHidden];
	} else {
		[self showPlanes];
	}
	[self showNodeFromRoot:eyeToggle index: eyeIndexPath];
	if ([eyeToggle	selectedIndex] == 0) {
		[self setEyeHidden];
	} else {
		[self showEye];
	}
	[self showNodeFromRoot:gearToggle index: gearIndexPath];
	if ([gearToggle	selectedIndex] == 0) {
		[self setGearHidden];
	} else {
		[self showGear];
	}
}

- (void) hideMenu {
	isMenuOpened = false;
	[background runAction:[CCSequence actions:						   
						   [CCFadeOut actionWithDuration:0.25],
						   [CCCallBlock actionWithBlock:^{ [background setVisible:NO]; }],
						   nil]];
	[tooltipLabel runAction:[CCSequence actions:						   
						   [CCFadeOut actionWithDuration:0.25],
						   [CCCallBlock actionWithBlock:^{ [tooltipLabel setVisible:NO]; }],
						   nil]];
	[self hideNode:brainToggle onIndex:brainIndexPath toLevel:0];
	[self hideBrainToLevel: 0];
	[self hideNode:planesToggle onIndex:planesIndexPath toLevel:0];
	[self hidePlanesToLevel: 0];
	[self hideNode:eyeToggle onIndex:eyeIndexPath toLevel:0];
	[self hideEyeToLevel: 0];
	[self hideNode:gearToggle onIndex:gearIndexPath toLevel:0];
	[self hideGearToLevel: 0];
}

- (void)raiseChangeEvent:(CCMenuItemToggle *)item  {
	if (item != nil) {
		[[NSNotificationCenter defaultCenter] postNotificationName: RAD_CHANGE_EVENT object: self userInfo: [NSDictionary dictionaryWithObject: item forKey: RAD_CHANGE_USER_INFO ]];
	}

}
- (void)updateTooltipWithItem:(CCMenuItemToggle *)item  {
	NSString* string = [itemsTooltipMap objectForKey: item.description];
	if (string != nil) {
		tooltipLabel.string = string; 
	}
}

- (void)playTickIfNotNull:(CCMenuItemToggle *)item  {
	if (item!=nil) {
		[[HPSound sharedSound] playSound: SOUND_TICK];
	}
}

- (void)doCommonToggleStuff:(CCMenuItemToggle *)item  {
  [self playTickIfNotNull: item];
	[self updateTooltipWithItem: item];
	[self raiseChangeEvent: item];

}
- (void) onBrainToggle: (CCMenuItemToggle*) item {
	int currentLevel = [brainIndexPath length];
	if ([brainToggle selectedIndex] == 0) {
		[self  hideBrainToLevel: currentLevel];
	} else {
		[self showBrain];
		[planesToggle setSelectedIndex:0];
		[self onPlanesToggle:nil];
		[eyeToggle setSelectedIndex:0];
		[self onEyeToggle:nil];
		[gearToggle setSelectedIndex:0];
		[self onGearToggle:nil];
	}
	[self doCommonToggleStuff: item];
}

- (void) onWoolToggle: (CCMenuItemToggle*) item {
	[logic toggleAriadnaTool];
	[self doCommonToggleStuff: item];
}


- (void) onBreadToggle: (CCMenuItemToggle*) item {
	[logic toggleVisitedTool];
	[self doCommonToggleStuff: item];
}


- (void) onFlagToggle: (CCMenuItemToggle*) item {
	[logic toggleCheckpointTool];
	int currentLevel = [flagIndexPath length];
	if ([flagToggle selectedIndex] == 0) {
		[self hideFlagToLevel: currentLevel];
	} else {
		[self showFlag];
	}
	[self doCommonToggleStuff: item];
}

- (void) onFlagLevelToggle: (CCMenuItemToggle*) item {
	[logic setCheckpointNumber:[flagSliderItems indexOfObject:item] + 1];
	[self renderFlagSliderValue];
	[self doCommonToggleStuff: item];
}


- (void) onSignPostToggle: (CCMenuItemToggle*) item {
	[logic toggleUntakenTool];
	[self doCommonToggleStuff: item];
}

- (void) onBrushToggle: (CCMenuItemToggle*) item {
	[logic toggleMarkMask];
	[self doCommonToggleStuff: item];
}


- (void) onMenuToggle: (CCMenuItemToggle*) item {
	if ([menuToggle selectedIndex] == 1) {
		[self showMenu];
	} else {
		[self hideMenu];
	}
	[self doCommonToggleStuff: item];
}

- (void) onPlanesToggle: (CCMenuItemToggle*) item {
	int currentLevel = [planesIndexPath length];
	if ([planesToggle selectedIndex] == 0) {
		[self hidePlanesToLevel: currentLevel];
	} else {
		[self showPlanes];
		[brainToggle setSelectedIndex:0];
		[self onBrainToggle:nil];
		[eyeToggle setSelectedIndex:0];
		[self onEyeToggle:nil];
		[gearToggle setSelectedIndex:0];
		[self onGearToggle:nil];
	}
	[self doCommonToggleStuff: item];
}

- (void) onPlaneXToggle: (CCMenuItemToggle*) item {
	[logic toggleYAxisTool];
	[self doCommonToggleStuff: item];
}

- (void) onPlaneYToggle: (CCMenuItemToggle*) item {
	[logic toggleXAxisTool];
	[self doCommonToggleStuff: item];
}

- (void) onPlaneZToggle: (CCMenuItemToggle*) item {
	[logic toggleZAxisTool];
	[self doCommonToggleStuff: item];
}

- (void) onCrossToggle: (CCMenuItemToggle*) item {
	[logic toggleRecursiveTool];
	int currentLevel = [crossIndexPath length];
	if ([crossToggle selectedIndex] == 0) {
		[self hideCrossToLevel: currentLevel];
	} else {
		[self showCross];
	}
	[self doCommonToggleStuff: item];
}

- (void) onCrossLevelToggle: (CCMenuItemToggle*) item {
	[logic setRecursionDepth:[crossSliderItems indexOfObject:item] + 1];
	[self renderCrossSliderValue];
	[self doCommonToggleStuff: item];
}

- (void) onEyeToggle: (CCMenuItemToggle*) item {
	int currentLevel = [eyeIndexPath length];
	if ([eyeToggle selectedIndex] == 0) {
		[self hideEyeToLevel: currentLevel];
	} else {
		[self showEye];
		[brainToggle setSelectedIndex:0];
		[self onBrainToggle:nil];
		[planesToggle setSelectedIndex:0];
		[self onPlanesToggle:nil];
		[gearToggle setSelectedIndex:0];
		[self onGearToggle:nil];
	}
	[self doCommonToggleStuff: item];
}

- (void) onMazeToggle: (CCMenuItemToggle*) item {
	[logic toggleMazeTool];
	[self doCommonToggleStuff: item];
}

- (void) onCrosshairToggle: (CCMenuItemToggle*) item {
	[logic toggleTarget];
	[self doCommonToggleStuff: item];
}

- (void) onCubeToggle: (CCMenuItemToggle*) item {
	[logic toggleBorders];
	[self doCommonToggleStuff: item];
}

- (void) onCompassToggle: (CCMenuItemToggle*) item {
	[logic toggleCompass];
	[self doCommonToggleStuff: item];
}

- (void) onGearToggle: (CCMenuItemToggle*) item {
	int currentLevel = [gearIndexPath length];
	if ([gearToggle selectedIndex] == 0) {
		[self hideGearToLevel: currentLevel];
	} else {
		[self showGear];
		[brainToggle setSelectedIndex:0];
		[self onBrainToggle:nil];
		[planesToggle setSelectedIndex:0];
		[self onPlanesToggle:nil];
		[eyeToggle setSelectedIndex:0];
		[self onEyeToggle:nil];
	}
	[self doCommonToggleStuff: item];
}

- (void) onSpeakerToggle: (CCMenuItemToggle*) item {
	HPConfiguration* configuration = [HPConfiguration sharedConfiguration];
	configuration.sound = [NSNumber numberWithInteger: 1-[item selectedIndex]];
	[configuration save];
	[self doCommonToggleStuff: item];
}

- (void) onNoteToggle: (CCMenuItemToggle*) item {
	HPConfiguration* configuration = [HPConfiguration sharedConfiguration];
	configuration.music = [NSNumber numberWithInteger: 1-[item selectedIndex]];
	[configuration save];
	if ([[configuration music] boolValue]) {
		[[HPSound sharedSound] stopMusic];
	} else {
		[[HPSound sharedSound] playMusic];
	}
	[self doCommonToggleStuff: item];
}

- (void) onXToggle: (CCMenuItemToggle*) item {
	int currentLevel = [xIndexPath length];
	if ([xToggle selectedIndex] == 0) {
		[self hideXToLevel: currentLevel];
	} else {
		[self showX];
		[rToggle setSelectedIndex:0];
		[self onRToggle:nil];
	}
	[self doCommonToggleStuff: item];
}

- (void) onRToggle: (CCMenuItemToggle*) item {
	int currentLevel = [rIndexPath length];
	if ([rToggle selectedIndex] == 0) {
		[self hideRToLevel: currentLevel];
	} else {
		[self showR];
		[xToggle setSelectedIndex:0];
		[self onXToggle:nil];
	}
	[self doCommonToggleStuff: item];
}

- (void) onOkXToggle: (CCMenuItemToggle*) item {
	[game saveGame];
	[[CCDirector sharedDirector] purgeCachedData];
	[[CCDirector sharedDirector] replaceScene: [CCTransitionCrossFade transitionWithDuration:0.5 scene: [MainMenuLayer scene]]];
	[self doCommonToggleStuff: item];
}

- (void) onOkRToggle: (CCMenuItemToggle*) item {
	[logic reset];
	[self hideMenu];
	menuToggle.selectedIndex = 0;
	[self doCommonToggleStuff: item];
	[[HPSound sharedSound] playSound: SOUND_GONG];
}

- (void)onExit {
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
	[super onExit];
}

-(void) dealloc {
	[logic release];
	
	[brainIndexPath release];
	[planesIndexPath release];
	[eyeIndexPath release];
	[gearIndexPath release];
	
	[flagIndexPath release];
	[woolIndexPath release];
	[breadIndexPath release];
	[signpostIndexPath release];
	[brushIndexPath release];
	
	[planesXIndexPath release];
	[planesYIndexPath release];
	[planesZIndexPath release];
	[crossIndexPath release];
	
	[mazeIndexPath release];
	[crosshairIndexPath release];
	[cubeIndexPath release];
	[compassIndexPath release];
	
	[speakerIndexPath release];
	[noteIndexPath release];
	[xIndexPath release];
	[rIndexPath release];
	
	[okXIndexPath release];
	
	[okRIndexPath release];
	
	[flagSliderItems release];
	[crossSliderItems release];
	
	[aligner release];
	
	[enabilityMap release];
	[itemsTooltipMap release];
	
	[[NSNotificationCenter defaultCenter] removeObserver: self];
	[super dealloc];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	if (isMenuOpened && isEnabled) {
		[menuToggle setSelectedIndex:0];
		[self onMenuToggle:menuToggle];
		return true;
	} else {
		return false;
	}
}

@end
