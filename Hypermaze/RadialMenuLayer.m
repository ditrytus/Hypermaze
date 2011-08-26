//
//  RadialMenuLayer.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 20.08.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RadialMenuLayer.h"

#import <math.h>

@implementation RadialMenuLayer

- (CCMenuItemToggle*) menuItemFromOnFrameName: (NSString*) onFrameName offFrameName: (NSString*) offFrameName target: (SEL) target {
	CCSprite* onSprite = [CCSprite spriteWithSpriteFrameName:onFrameName];
	CCMenuItemImage* onItem = [CCMenuItemImage itemFromNormalSprite:onSprite selectedSprite:nil];
	CCSprite* offSprite = [CCSprite spriteWithSpriteFrameName:offFrameName];
	CCMenuItemImage* offItem = [CCMenuItemImage itemFromNormalSprite:offSprite selectedSprite:nil];
	CCMenuItemToggle* toggleItem = [[CCMenuItemToggle itemWithTarget:self selector:target items:offItem, onItem, nil] retain];
	toggleItem.selectedIndex = 0;
	toggleItem.position = ccp(0,0);
	return [toggleItem retain];
}
	
- (CCMenuItemToggle*) hiddenMenuItemFromOnFrameName: (NSString*) onFrameName offFrameName: (NSString*) offFrameName target: (SEL) target {
	CCMenuItemToggle* toggleItem = [self menuItemFromOnFrameName:onFrameName offFrameName:offFrameName target:target];
	[toggleItem setOpacity: 0.0];
	[toggleItem setIsEnabled: NO];
	[toggleItem setVisible:NO];
	return toggleItem;
}

- (id)initWithLogic: (HPLogic*) innerLogic
{
    self = [super init];
    if (self) {
		logic = [innerLogic retain];
		
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"interface.plist" textureFile: @"interface.png"];
		
		menuToggle = [self menuItemFromOnFrameName:@"menu_on.png" offFrameName:@"menu_off.png" target:@selector(onMenuToggle:)];
		
		brainToggle = [self hiddenMenuItemFromOnFrameName:@"brain_on.png" offFrameName:@"brain_off.png" target:@selector(onBrainToggle:)];
		brainIndexPath = [NSIndexPath indexPathWithIndex:0];
		
		woolToggle = [self hiddenMenuItemFromOnFrameName:@"wool_on.png" offFrameName:@"wool_off.png" target:@selector(onWoolToggle:)];
		woolIndexPath= [brainIndexPath indexPathByAddingIndex:0];
		
		breadToggle = [self hiddenMenuItemFromOnFrameName:@"bread_on.png" offFrameName:@"bread_off.png" target:@selector(onBreadToggle:)];
		breadIndexPath= [brainIndexPath indexPathByAddingIndex:1];
			
		signpostToggle = [self hiddenMenuItemFromOnFrameName:@"signpost_on.png" offFrameName:@"signpost_off.png" target:@selector(onSignPostToggle:)];
		signpostIndexPath= [brainIndexPath indexPathByAddingIndex:2];
		
		flagToggle = [self hiddenMenuItemFromOnFrameName:@"flag_on.png" offFrameName:@"flag_off.png" target:@selector(onFlagToggle:)];
		flagIndexPath= [brainIndexPath indexPathByAddingIndex:3];
		
		brushToggle = [self hiddenMenuItemFromOnFrameName:@"brush_on.png" offFrameName:@"brush_off.png" target:@selector(onBrushToggle:)];
		brushIndexPath= [brainIndexPath indexPathByAddingIndex:4];
		
		planesToggle = [self hiddenMenuItemFromOnFrameName:@"planes_on.png" offFrameName:@"planes_off.png" target:@selector(onPlanesToggle:)];
		planesIndexPath = [NSIndexPath indexPathWithIndex:1];
		
		planesXToggle = [self hiddenMenuItemFromOnFrameName:@"plane_x_on.png" offFrameName:@"plane_x_off.png" target:@selector(onPlaneXToggle:)];
		planesXIndexPath= [planesIndexPath indexPathByAddingIndex:0];
		
		planesYToggle = [self hiddenMenuItemFromOnFrameName:@"plane_y_on.png" offFrameName:@"plane_y_off.png" target:@selector(onPlaneYToggle:)];
		planesYIndexPath= [planesIndexPath indexPathByAddingIndex:1];
		
		planesZToggle = [self hiddenMenuItemFromOnFrameName:@"plane_z_on.png" offFrameName:@"plane_z_off.png" target:@selector(onPlaneZToggle:)];
		planesZIndexPath= [planesIndexPath indexPathByAddingIndex:2];
		
		crossToggle	= [self hiddenMenuItemFromOnFrameName:@"cross_on.png" offFrameName:@"cross_off.png" target:@selector(onCrossToggle:)];
		crossIndexPath = [planesIndexPath indexPathByAddingIndex:3];
		
		eyeToggle = [self hiddenMenuItemFromOnFrameName:@"eye_on.png" offFrameName:@"eye_off.png" target:@selector(onEyeToggle:)];
		eyeIndexPath = [NSIndexPath indexPathWithIndex:2];
		
		mazeToggle = [self hiddenMenuItemFromOnFrameName:@"maze_on.png" offFrameName:@"maze_off.png" target:@selector(onMazeToggle:)];
		mazeIndexPath= [eyeIndexPath indexPathByAddingIndex:0];
		
		crosshairToggle = [self hiddenMenuItemFromOnFrameName:@"crosshair_on.png" offFrameName:@"crosshair_off.png" target:@selector(onCrosshairToggle:)];
		crosshairIndexPath = [eyeIndexPath indexPathByAddingIndex:1];
		
		cubeToggle = [self hiddenMenuItemFromOnFrameName:@"cube_on.png" offFrameName:@"cube_off.png" target:@selector(onCubeToggle:)];
		cubeIndexPath= [eyeIndexPath indexPathByAddingIndex:2];
		
		compassToggle = [self hiddenMenuItemFromOnFrameName:@"compass_on.png" offFrameName:@"compass_off.png" target:@selector(onCompassToggle:)];
		compassIndexPath = [eyeIndexPath indexPathByAddingIndex:3];
				
		gearToggle = [self hiddenMenuItemFromOnFrameName:@"gear_on.png" offFrameName:@"gear_off.png" target:@selector(onGearToggle:)];
		gearIndexPath = [NSIndexPath indexPathWithIndex:3];
		
		speakerToggle = [self hiddenMenuItemFromOnFrameName:@"speaker_on.png" offFrameName:@"speaker_off.png" target:@selector(onSpeakerToggle:)];
		speakerIndexPath = [gearIndexPath indexPathByAddingIndex:0];
		
		noteToggle = [self hiddenMenuItemFromOnFrameName:@"note_on.png" offFrameName:@"note_off.png" target:@selector(onNoteToggle:)];
		noteIndexPath = [gearIndexPath indexPathByAddingIndex:1];
		
		xToggle	= [self hiddenMenuItemFromOnFrameName:@"x_on.png" offFrameName:@"x_off.png" target:@selector(onXToggle:)];
		xIndexPath = [gearIndexPath indexPathByAddingIndex:2];
		
		okXToggle = [self hiddenMenuItemFromOnFrameName:@"ok_on.png" offFrameName:@"ok_off.png" target:@selector(onOkXToggle:)];
		okXIndexPath = [xIndexPath indexPathByAddingIndex:0];
		
		rToggle = [self hiddenMenuItemFromOnFrameName:@"r_on.png" offFrameName:@"r_off.png" target:@selector(onRToggle:)];
		rIndexPath = [gearIndexPath indexPathByAddingIndex:3];
		
		okRToggle = [self hiddenMenuItemFromOnFrameName:@"ok_on.png" offFrameName:@"ok_off.png" target:@selector(onOkRToggle:)];
		okRIndexPath = [rIndexPath indexPathByAddingIndex:0];
		
		CCMenu* radialMenu = [CCMenu menuWithItems:
							  okXToggle, okRToggle,
							  woolToggle, breadToggle, signpostToggle, flagToggle, brushToggle,
							  planesXToggle, planesYToggle, planesZToggle, crossToggle,
							  mazeToggle, crosshairToggle, cubeToggle, compassToggle,
							  speakerToggle, noteToggle, xToggle, rToggle,
							  brainToggle, planesToggle, eyeToggle, gearToggle,
							  menuToggle, nil];
		[self addChild: radialMenu];
		
		CGSize size = [[CCDirector sharedDirector] winSize];
		[self setPosition: ccp(0,-size.height/2.0 + 100)];
		aligner	= [[FSRadialAligner alloc] initWithAngle:M_PI/1.2 radius:100 margin:100 root:
				   [NSMutableArray arrayWithObjects:
					[NSMutableArray arrayWithObjects:woolToggle, breadToggle, signpostToggle, flagToggle, brushToggle, nil],
					[NSMutableArray arrayWithObjects:planesXToggle, planesYToggle, planesZToggle, crossToggle, nil],
					[NSMutableArray arrayWithObjects:mazeToggle, crosshairToggle, cubeToggle, compassToggle, nil],
					[NSMutableArray arrayWithObjects:
					 speakerToggle,
					 noteToggle,
					 [NSMutableArray arrayWithObjects:okXIndexPath, nil],
					 [NSMutableArray arrayWithObjects:okRIndexPath, nil],
					 nil],
					nil]];
    }
    
    return self;
}

- (void) showNodeFromRoot:(CCMenuItem*) node index: (NSIndexPath*) index {
	[node stopAllActions];
	[node runAction: [CCSequence actions:
					  [CCCallBlock actionWithBlock:^{ [node setVisible:YES]; }],
					  [CCSpawn actions:
					   [CCEaseBounceOut actionWithAction:[CCMoveTo actionWithDuration:0.5 position:[aligner alignElementOnIndex: index]]],
					   [CCFadeIn actionWithDuration:0.5],
					   nil],
					  nil]];
	[node setIsEnabled:YES];
}

- (void) hideNode:(CCMenuItem*) item onIndex: (NSIndexPath*) index toLevel: (int) level {
	CGPoint position;
	if (level == 0){
		position = ccp(0,0);
	} else {
		position = [aligner alignElementOnIndex:index radiusDelta: [aligner getRadiusDeltaForIndex: index level: level] marginDelta:0];
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

- (void) setHiddenNode: (CCMenuItem*) node onIndex: (NSIndexPath*) index toLevel: (int) level {
	float radiusDelta = [aligner getRadiusDeltaForIndex: index level: level];
	node.position = [aligner alignElementOnIndex:index radiusDelta: radiusDelta marginDelta:0];
}

- (void) showBrain {
	[self showNodeFromRoot:woolToggle index: woolIndexPath];
	[self showNodeFromRoot:breadToggle index: breadIndexPath];
	[self showNodeFromRoot:signpostToggle index: signpostIndexPath];
	[self showNodeFromRoot:flagToggle index: flagIndexPath];
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
	[self hideNode:brushToggle onIndex:brushIndexPath toLevel:level];
}


- (void) showPlanes {
	[self showNodeFromRoot:planesXToggle index: planesXIndexPath];
	[self showNodeFromRoot:planesYToggle index: planesYIndexPath];
	[self showNodeFromRoot:planesZToggle index: planesZIndexPath];
	[self showNodeFromRoot:crossToggle index: crossIndexPath];
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
	[self hideNode:rToggle onIndex:rIndexPath toLevel:level];
	[self hideRToLevel: level];
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
	[self hideNode:brainToggle onIndex:brainIndexPath toLevel:0];
	[self hideBrainToLevel: 0];
	[self hideNode:planesToggle onIndex:planesIndexPath toLevel:0];
	[self hidePlanesToLevel: 0];
	[self hideNode:eyeToggle onIndex:eyeIndexPath toLevel:0];
	[self hideEyeToLevel: 0];
	[self hideNode:gearToggle onIndex:gearIndexPath toLevel:0];
	[self hideGearToLevel: 0];
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
}

- (void) onWoolToggle: (CCMenuItemToggle*) item {
	[logic toggleAriadnaTool];
}


- (void) onBreadToggle: (CCMenuItemToggle*) item {
	[logic toggleVisitedTool];
}


- (void) onFlagToggle: (CCMenuItemToggle*) item {
	
}


- (void) onSignPostToggle: (CCMenuItemToggle*) item {
	[logic toggleUntakenTool];
}


- (void) onBrushToggle: (CCMenuItemToggle*) item {
	
}


- (void) onMenuToggle: (CCMenuItemToggle*) item {
	if ([menuToggle selectedIndex] == 1) {
		[self showMenu];
	} else {
		[self hideMenu];
	}
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
}

- (void) onPlaneXToggle: (CCMenuItemToggle*) item {
	[logic toggleYAxisTool];
}

- (void) onPlaneYToggle: (CCMenuItemToggle*) item {
	[logic toggleXAxisTool];
}

- (void) onPlaneZToggle: (CCMenuItemToggle*) item {
	[logic toggleZAxisTool];
}

- (void) onCrossToggle: (CCMenuItemToggle*) item {
	[logic toggleRecursiveTool];
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
}

- (void) onMazeToggle: (CCMenuItemToggle*) item {
	[logic toggleMazeTool];
}

- (void) onCrosshairToggle: (CCMenuItemToggle*) item {
	
}

- (void) onCubeToggle: (CCMenuItemToggle*) item {
	
}

- (void) onCompassToggle: (CCMenuItemToggle*) item {
	
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
}

- (void) onSpeakerToggle: (CCMenuItemToggle*) item {
	
}

- (void) onNoteToggle: (CCMenuItemToggle*) item {
	
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
}

- (void) onOkXToggle: (CCMenuItemToggle*) item {
	
}

- (void) onOkRToggle: (CCMenuItemToggle*) item {
	
}

-(void) dealloc {
	[logic release];
	[super dealloc];
}

@end
