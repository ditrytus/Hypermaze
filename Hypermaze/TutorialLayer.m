//
//  TutorialLayer.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 15.10.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TutorialLayer.h"
#import "MainMenuLayer.h"
#import "RadialMenuLayer.h"
#import "Game.h"

@implementation TutorialLayer

- (CCSprite*)createArrow:(CGPoint)position angle:(int)angle  {
	CCSprite* arrow = [CCSprite spriteWithSpriteFrameName:@"tutorial_arrow.png"];
	arrow.position = position;
	arrow.anchorPoint = ccp(0.5,1);
	arrow.rotation = angle;
	arrow.scale = 0.75;
	[arrow runAction:
	 [CCRepeatForever actionWithAction:
	  [CCSequence actions:
	   [CCEaseSineInOut actionWithAction:
		[CCMoveBy actionWithDuration:1 position:CGPointApplyAffineTransform(ccp(0,10), CGAffineTransformMakeRotation(CC_DEGREES_TO_RADIANS(-angle)))]],
	   [CCEaseSineInOut actionWithAction:
		[CCMoveBy actionWithDuration:1	position:CGPointApplyAffineTransform(ccp(0,-10), CGAffineTransformMakeRotation(CC_DEGREES_TO_RADIANS(-angle)))]],
	   nil]]];
	return arrow;
}

- (NSString*) stepMessage {
	NSString* messageKey = [NSString stringWithFormat:@"TutorialStep%d", stepNum, nil];
	return NSLocalizedString(messageKey,@"");
}

- (id)initWithGame: (Game*) aGame radialMenu: (RadialMenuLayer*) aRadialMenu
{
    self = [super init];
    if (self) {
		game = [aGame retain];
		radialMenu = [aRadialMenu retain];
		[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(oInterfaceChanged:) name: RAD_CHANGE_EVENT object: nil];
		[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(oInterfaceChanged:) name: INTF_ARROW_CLICK_EVENT object: nil];
		stepNum = 0;
		rotationState = 0;
		planesState = 0;
		CCSprite* prototype = [CCSprite spriteWithFile:@"tutorial_arrow.png"];
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame: [CCSpriteFrame frameWithTexture:prototype.texture rect:prototype.textureRect] name:@"tutorial_arrow.png"];
		
		startArrow = [[self createArrow: POS_START_ARROW angle: ANGLE_W] retain];
		[self addChild: startArrow];
		endArrow = [[self createArrow: POS_END_ARROW angle: ANGLE_N] retain];
		[self addChild: endArrow];
		menuArrow = [[self createArrow: POS_MENU_ARROW angle: ANGLE_S] retain];
		[self addChild: menuArrow];
		
        borderTopArrow = [[self createArrow: POP_BORDERBOTTOM_ARROW angle: ANGLE_N] retain];
		[self addChild: borderTopArrow];
		borderLeftArrow = [[self createArrow: POP_BORDERLEFT_ARROW angle: ANGLE_E] retain];
		[self addChild: borderLeftArrow];
		borderRightArrow = [[self createArrow: POP_BORDERRIGHT_ARROW angle: ANGLE_W] retain];
		[self addChild: borderRightArrow];
		
		NWArrowL = [[self createArrow: POS_NWL_ARROW angle: ANGLE_S] retain];
		[self addChild: NWArrowL];
		SWArrowL = [[self createArrow: POS_SWL_ARROW angle: ANGLE_S] retain];
		[self addChild: SWArrowL];
		NArrowL = [[self createArrow: POS_NL_ARROW angle: ANGLE_S] retain];
		[self addChild: NArrowL];
		SArrowL = [[self createArrow: POS_SL_ARROW angle: ANGLE_S] retain];
		[self addChild: SArrowL];
		NEArrowL = [[self createArrow: POS_NEL_ARROW angle: ANGLE_S] retain];
		[self addChild: NEArrowL];
		SEArrowL = [[self createArrow: POS_SEL_ARROW angle: ANGLE_S] retain];
		[self addChild: SEArrowL];
		
		NWArrowR = [[self createArrow: POS_NWR_ARROW angle: ANGLE_S] retain];
		[self addChild: NWArrowR];
		SWArrowR = [[self createArrow: POS_SWR_ARROW angle: ANGLE_S] retain];
		[self addChild: SWArrowR];
		NArrowR = [[self createArrow: POS_NR_ARROW angle: ANGLE_S] retain];
		[self addChild: NArrowR];
		SArrowR = [[self createArrow: POS_SR_ARROW angle: ANGLE_S] retain];
		[self addChild: SArrowR];
		NEArrowR = [[self createArrow: POS_NER_ARROW angle: ANGLE_S] retain];
		[self addChild: NEArrowR];
		SEArrowR = [[self createArrow: POS_SER_ARROW angle: ANGLE_S] retain];
		[self addChild: SEArrowR];
		
		clockwiseArrowL = [[self createArrow: POS_CLOCKWISEL_ARROW angle: ANGLE_S] retain];
		[self addChild: clockwiseArrowL];
		countercolckwiseArrowL = [[self createArrow: POS_COUNTERCLOCKWISEL_ARROW angle: ANGLE_S] retain];
		[self addChild: countercolckwiseArrowL];
		clockwiseArrowR = [[self createArrow: POS_CLOCKWISER_ARROW angle: ANGLE_S] retain];
		[self addChild: clockwiseArrowR];
		countercolckwiseArrowR = [[self createArrow: POS_COUNTERCLOCKWISER_ARROW angle: ANGLE_S] retain];
		[self addChild: countercolckwiseArrowR];
		
		clockArrow = [[self createArrow: POS_CLOCK_ARROW angle: ANGLE_N] retain];
		[self addChild: clockArrow];
		movesArrow = [[self createArrow: POS_MOVES_ARROW angle: ANGLE_N] retain];
		[self addChild: movesArrow];
		unvisitedArrow = [[self createArrow: POS_UNVISITED_ARROW angle: ANGLE_N] retain];
		[self addChild: unvisitedArrow];
		visitedArrow = [[self createArrow: POS_VISITED_ARROW angle: ANGLE_N] retain];
		[self addChild: visitedArrow];
		
		brainArrow = [[self createArrow: POS_BRAIN_ARROW angle: ANGLE_SE] retain];
		[self addChild: brainArrow];
		planesArrow = [[self createArrow: POS_PLANES_ARROW angle: ANGLE_S] retain];
		[self addChild: planesArrow];
		eyeArrow = [[self createArrow: POS_EYE_ARROW angle: ANGLE_S] retain];
		[self addChild: eyeArrow];
		gearArrow = [[self createArrow: POS_GEAR_ARROW angle: ANGLE_SW] retain];
		[self addChild: gearArrow];
		
		speakerArrow = [[self createArrow: POS_SPEAKER_ARROW angle: ANGLE_S] retain];
		[self addChild: speakerArrow];
		noteArrow = [[self createArrow: POS_NOTE_ARROW angle: ANGLE_S] retain];
		[self addChild: noteArrow];
		xArrow = [[self createArrow: POS_X_ARROW angle: ANGLE_S] retain];
		[self addChild: xArrow];
		rArrow = [[self createArrow: POS_R_ARROW angle: ANGLE_S] retain];
		[self addChild: rArrow];
		
		mazeArrow = [[self createArrow: POS_MAZE_ARROW angle: ANGLE_S] retain];
		[self addChild: mazeArrow];
		crosshairArrow = [[self createArrow: POS_CROSSHAIR_ARROW angle: ANGLE_S] retain];
		[self addChild: crosshairArrow];
		bordersArrow = [[self createArrow: POS_BORDERS_ARROW angle: ANGLE_S] retain];
		[self addChild: bordersArrow];
		compassArrow = [[self createArrow: POS_COMPASS_ARROW angle: ANGLE_S] retain];
		[self addChild: compassArrow];
		
		xPlaneArrow = [[self createArrow: POS_XPLANE_ARROW angle: ANGLE_S] retain];
		[self addChild: xPlaneArrow];
		yPlaneArrow = [[self createArrow: POS_YPLANE_ARROW angle: ANGLE_S] retain];
		[self addChild: yPlaneArrow];
		zPlaneArrow = [[self createArrow: POS_ZPLANE_ARROW angle: ANGLE_S] retain];
		[self addChild: zPlaneArrow];
		recursiveArrow = [[self createArrow: POS_RECURSIVE_ARROW angle: ANGLE_S] retain];
		[self addChild: recursiveArrow];
		recursiveLevelsArrow = [[self createArrow: POS_RECURSIVELEVELS_ARROW angle: ANGLE_SW] retain];
		[self addChild: recursiveLevelsArrow];
		
		woolArrow = [[self createArrow: POS_WOOL_ARROW angle: ANGLE_S] retain];
		[self addChild: woolArrow];
		breadArrow = [[self createArrow: POS_BREAD_ARROW angle: ANGLE_S] retain];
		[self addChild: breadArrow];
		signArrow = [[self createArrow: POS_SIGN_ARROW angle: ANGLE_S] retain];
		[self addChild: signArrow];
		flagArrow = [[self createArrow: POS_FLAG_ARROW angle: ANGLE_S] retain];
		[self addChild: flagArrow];
		flagLevelsArrow = [[self createArrow: POS_FLAGLEVELS_ARROW angle: ANGLE_SW] retain];
		[self addChild: flagLevelsArrow];
		brushArrow = [[self createArrow: POS_BRUSH_ARROW angle: ANGLE_S] retain];
		[self addChild: brushArrow];
		
		arrows = [[NSArray arrayWithObjects: startArrow, endArrow, menuArrow, borderTopArrow, borderLeftArrow, borderRightArrow, NWArrowL, SWArrowL, NArrowL,
				   SArrowL, NEArrowL, SEArrowL, NWArrowR, SWArrowR, NArrowR, SArrowR, NEArrowR, SEArrowR, 
				   clockwiseArrowL, countercolckwiseArrowL, clockwiseArrowR, countercolckwiseArrowR,
				   clockArrow, movesArrow, unvisitedArrow, visitedArrow, brainArrow, planesArrow, eyeArrow,
				   gearArrow, speakerArrow, noteArrow, xArrow, rArrow, mazeArrow, crosshairArrow, bordersArrow,
				   compassArrow, xPlaneArrow, yPlaneArrow, zPlaneArrow, recursiveArrow, recursiveLevelsArrow,
				   woolArrow, breadArrow, signArrow, flagArrow, flagLevelsArrow, brushArrow, nil] retain];
		
		arrowButtonTree = [[NSDictionary dictionaryWithObjectsAndKeys:
						   [NSArray array], [startArrow description],
						   [NSArray array], [endArrow description],
						   [NSArray array], [menuArrow description],
						   
						   [NSArray array], [borderTopArrow description],
						   [NSArray array], [borderLeftArrow description],
						   [NSArray array], [borderRightArrow description],
						   
						   [NSArray array], [NWArrowL description],
						   [NSArray array], [SWArrowL description],
						   [NSArray array], [NArrowL description],
						   [NSArray array], [SArrowL description],
						   [NSArray array], [NEArrowL description],
						   [NSArray array], [SEArrowL description],
						   
						   [NSArray array], [NWArrowR description],
						   [NSArray array], [SWArrowR description],
						   [NSArray array], [NArrowR description],
						   [NSArray array], [SArrowR description],
						   [NSArray array], [NEArrowR description],
						   [NSArray array], [SEArrowR description],
						   
						   [NSArray array], [clockwiseArrowL description],
						   [NSArray array], [countercolckwiseArrowL description],
						   [NSArray array], [clockwiseArrowR description],
						   [NSArray array], [countercolckwiseArrowR description],
						   
						   [NSArray array], [clockArrow description],
						   [NSArray array], [movesArrow description],
						   [NSArray array], [unvisitedArrow description],
						   [NSArray array], [visitedArrow description],
						   
						   [NSArray arrayWithObjects: radialMenu.menuToggle, nil], [brainArrow  description],
						   [NSArray arrayWithObjects: radialMenu.menuToggle, nil], [planesArrow description],
						   [NSArray arrayWithObjects: radialMenu.menuToggle, nil], [eyeArrow description],
						   [NSArray arrayWithObjects: radialMenu.menuToggle, nil], [gearArrow description],
						   
						   [NSArray arrayWithObjects: radialMenu.menuToggle, radialMenu.gearToggle, nil], [speakerArrow description],
						   [NSArray arrayWithObjects: radialMenu.menuToggle, radialMenu.gearToggle, nil], [noteArrow description],
						   [NSArray arrayWithObjects: radialMenu.menuToggle, radialMenu.gearToggle, nil], [xArrow description],
   						   [NSArray arrayWithObjects: radialMenu.menuToggle, radialMenu.gearToggle, nil], [rArrow description],
						   
						   [NSArray arrayWithObjects: radialMenu.menuToggle, radialMenu.eyeToggle, nil], [mazeArrow description],
   						   [NSArray arrayWithObjects: radialMenu.menuToggle, radialMenu.eyeToggle, nil], [crosshairArrow description],
  						   [NSArray arrayWithObjects: radialMenu.menuToggle, radialMenu.eyeToggle, nil], [bordersArrow description],
   						   [NSArray arrayWithObjects: radialMenu.menuToggle, radialMenu.eyeToggle, nil], [compassArrow description],
						   
						   [NSArray arrayWithObjects: radialMenu.menuToggle, radialMenu.planesToggle, nil], [xPlaneArrow description],
						   [NSArray arrayWithObjects: radialMenu.menuToggle, radialMenu.planesToggle, nil], [yPlaneArrow description],
						   [NSArray arrayWithObjects: radialMenu.menuToggle, radialMenu.planesToggle, nil], [zPlaneArrow description],
						   [NSArray arrayWithObjects: radialMenu.menuToggle, radialMenu.planesToggle, nil], [recursiveArrow description],
						   [NSArray arrayWithObjects: radialMenu.menuToggle, radialMenu.planesToggle, radialMenu.crossToggle, nil], [recursiveLevelsArrow description],
						   
						   [NSArray arrayWithObjects: radialMenu.menuToggle, radialMenu.brainToggle, nil], [woolArrow description],
						   [NSArray arrayWithObjects: radialMenu.menuToggle, radialMenu.brainToggle, nil], [breadArrow description],
						   [NSArray arrayWithObjects: radialMenu.menuToggle, radialMenu.brainToggle, nil], [signArrow description],
						   [NSArray arrayWithObjects: radialMenu.menuToggle, radialMenu.brainToggle, nil], [flagArrow description],
						   [NSArray arrayWithObjects: radialMenu.menuToggle, radialMenu.brainToggle, radialMenu.flagToggle, nil], [flagLevelsArrow description],
						   [NSArray arrayWithObjects: radialMenu.menuToggle, radialMenu.brainToggle, nil], [brushArrow description],
							
						   nil] retain];
		
		toggleArrowDict = [[NSDictionary dictionaryWithObjectsAndKeys:
						   menuArrow, radialMenu.menuToggle.description,
						   gearArrow, radialMenu.gearToggle.description,
						   eyeArrow, radialMenu.eyeToggle.description,
						   planesArrow, radialMenu.planesToggle.description,
						   brainArrow, radialMenu.brainToggle.description,
						   recursiveArrow, radialMenu.crossToggle.description,
						   flagArrow, radialMenu.flagToggle.description,
						   nil] retain];
		
		visibleArrows = [[NSMutableSet set] retain];
		
		dialog = [[[CCDialog alloc] initWithSize:CGSizeMake(420, 290) position:ccp(20,728) closeButton:NO showOverlay:NO closeOnOverlayTouch:NO isModal:NO isDraggable:NO] retain];
		dialog.dialogWindow.anchorPoint = ccp(0,1);
		message = [[CCLabelTTF labelWithString:NSLocalizedString(@"TutorialStep61", @"FirstStep") dimensions:CGSizeMake(380, 250) alignment:UITextAlignmentLeft lineBreakMode:UILineBreakModeWordWrap fontName:@"Arial" fontSize:20] retain];
		message.color = ccBLACK;
		message.anchorPoint = ccp(0,1);
		message.position = ccp(20,270);
		[dialog.dialogWindow addChild: message];
 		nextButton = [[CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"NEXT" dimensions:CGSizeMake(360, 100) alignment:UITextAlignmentCenter fontName:@"Arial" fontSize:30] target:self selector:@selector(nextStep)] retain];
		nextButton.anchorPoint = ccp(0.5,0);
		nextButton.color = ccBLACK;
		nextButton.position = ccp(0,0);
		CCMenu* navigationMenu = [CCMenu menuWithItems:nextButton, nil];
		navigationMenu.position = ccp(210,-65);
		[dialog.dialogWindow addChild: navigationMenu];
		
		endDialog = [[CCDialog alloc] initWithSize:CGSizeMake(100, 50) position:ccp(1004,728) closeButton:NO showOverlay:NO closeOnOverlayTouch:NO isModal:NO isDraggable:NO];
		endDialog.dialogWindow.anchorPoint = ccp(1,1);
		CCMenuItemLabel* endButton = [[CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"END TUTORIAL" dimensions:CGSizeMake(100, 60) alignment:UITextAlignmentCenter fontName:@"Arial" fontSize:15] target:self selector:@selector(endTutorial)] retain];
		endButton.color = ccRED;
		endButton.anchorPoint = ccp(0.5,0.5);
		endButton.position = ccp(50,30);
		CCMenu* endMenu = [CCMenu menuWithItems:endButton, nil];
		endMenu.position = ccp(0,-20);
		[endDialog.dialogWindow addChild: endMenu];
		
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		CGPoint middle = ccp(winSize.width/2.0, winSize.height/2.0);
		CGSize dialogSize = CGSizeMake(320, 140);
		confirmEnd = [[CCDialog alloc] initWithSize: dialogSize position: middle closeButton:NO showOverlay:YES closeOnOverlayTouch:NO isModal:YES isDraggable:YES];
		CCMenuItemLabel* yes = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"YES" fontName:@"Arial" fontSize:24]
														block:^(id sender){
															[confirmEnd close];
																		[[CCDirector sharedDirector] replaceScene: [CCTransitionCrossFade transitionWithDuration:0.5 scene: [MainMenuLayer scene]]];
														}];
		yes.color = ccBLACK;
		CCMenuItemLabel* no = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"NO" fontName:@"Arial" fontSize:24]
													   block:^(id sender) {
														   [confirmEnd close];
													   }];
		no.color = ccBLACK;
		CCMenu* promptMenu = [CCMenu menuWithItems:yes, no, nil];
		[promptMenu alignItemsHorizontallyWithPadding:20];
		promptMenu.anchorPoint = ccp(0.5,0.5);
		promptMenu.position = ccp(dialogSize.width/2.0,dialogSize.height/2.0-50);
		[confirmEnd.dialogWindow addChild:promptMenu];
		
		CCLabelTTF* endMessage = [CCLabelTTF labelWithString:@"Are you sure you want to end tutorial and go back to main menu?" dimensions:CGSizeMake(280, 100) alignment:UITextAlignmentCenter lineBreakMode:UILineBreakModeWordWrap fontName:@"Arial" fontSize:20];
		endMessage.color = ccBLACK;
		endMessage.anchorPoint = ccp(0.5,0.5);
		endMessage.position = ccp(dialogSize.width/2.0,dialogSize.height/2.0);
		[confirmEnd.dialogWindow addChild:endMessage];
		
		[self nextStep];
	}
    return self;
}

-(void) endTutorial {
	[confirmEnd openInScene: game];
}

- (void) hideAllArrows {
	for (CCSprite* arrow in arrows) {
		arrow.visible = NO;
	}
}

- (void) displayArrows {
	[self hideAllArrows];
	 for (CCSprite* arrow in visibleArrows) {
		 bool canShow = YES;
		 for (CCMenuItemToggle* toggle in [arrowButtonTree objectForKey: arrow.description]) {
			 if (toggle.selectedIndex == 0) {
				 canShow = NO;
				 [((CCSprite*)[toggleArrowDict objectForKey: toggle.description]) setVisible: YES];
				 break;
			 }
		 }
		 if (canShow) {
			 [arrow setVisible:YES];
		 }
	 }
}

- (void)raiseEvenet:(NSString *)event  {
  [[NSNotificationCenter defaultCenter] postNotificationName:event object:self userInfo: nil];
}

- (void) oInterfaceChanged: (NSNotification*) notification {
	if ([[notification.object class] isSubclassOfClass: [RadialMenuLayer class]]) {
		CCMenuItemToggle* toggledItem = [notification.userInfo objectForKey: RAD_CHANGE_USER_INFO];
		switch (stepNum) {
			case 26:
				if (toggledItem == radialMenu.menuToggle && toggledItem.selectedIndex == 1) {
					[visibleArrows removeObject: menuArrow];
					[nextButton setVisible: YES];
					[self raiseEvenet: TUT_DISABLE_ALL_EVENT];
				}
				break;
			case 30:
				if (toggledItem == radialMenu.eyeToggle && toggledItem.selectedIndex == 1) {
					[visibleArrows removeObject: eyeArrow];
					[nextButton setVisible: YES];
					[self raiseEvenet: TUT_DISABLE_ALL_EVENT];
				}
				break;
			case 31:
				if (toggledItem == radialMenu.mazeToggle && toggledItem.selectedIndex == 1) {
					[visibleArrows removeObject: mazeArrow];
					[nextButton setVisible: YES];
					[self raiseEvenet: TUT_DISABLE_ALL_EVENT];
				}
				break;
			case 32:
				if (toggledItem == radialMenu.crosshairToggle && toggledItem.selectedIndex == 1) {
					[visibleArrows removeObject: crosshairArrow];
					[nextButton setVisible: YES];
					[self raiseEvenet: TUT_DISABLE_ALL_EVENT];
				}
				break;
			case 34:
				if (toggledItem == radialMenu.crosshairToggle && toggledItem.selectedIndex == 0) {
					[visibleArrows removeObject: crosshairArrow];
					[nextButton setVisible: YES];
					[self raiseEvenet: TUT_DISABLE_ALL_EVENT];
				}
				break;
			case 35:
				if (toggledItem == radialMenu.cubeToggle && toggledItem.selectedIndex == 0) {
					[visibleArrows removeObject: bordersArrow];
					[nextButton setVisible: YES];
					[self raiseEvenet: TUT_DISABLE_ALL_EVENT];
				}
				break;
			case 36:
				if (toggledItem == radialMenu.cubeToggle && toggledItem.selectedIndex == 1) {
					[visibleArrows removeObject: bordersArrow];
					[nextButton setVisible: YES];
					[self raiseEvenet: TUT_DISABLE_ALL_EVENT];
				}
				break;
			case 37:
				if (toggledItem == radialMenu.compassToggle && toggledItem.selectedIndex == 1) {
					[visibleArrows removeObject: menuArrow];
					compassArrow.visible = NO;
					[nextButton setVisible: YES];
					[self raiseEvenet: TUT_DISABLE_ALL_EVENT];
				}
				break;
			case 38:
				if (toggledItem == radialMenu.compassToggle && toggledItem.selectedIndex == 0) {
					[visibleArrows removeObject: compassArrow];
					[nextButton setVisible: YES];
					[self raiseEvenet: TUT_DISABLE_ALL_EVENT];
				}
				break;
			case 40:
				if (toggledItem == radialMenu.mazeToggle && toggledItem.selectedIndex == 0) {
					[visibleArrows removeObject: mazeArrow];
					[nextButton setVisible: YES];
					[self raiseEvenet: TUT_DISABLE_ALL_EVENT];
				}
				break;
			case 41:
				if (toggledItem == radialMenu.planesToggle && toggledItem.selectedIndex == 1) {
					[visibleArrows removeObject: planesArrow];
					[nextButton setVisible: YES];
					[self raiseEvenet: TUT_DISABLE_ALL_EVENT];
				}
				break;
			case 43:
				if (toggledItem == radialMenu.planesXToggle) {
					if (toggledItem.selectedIndex == 0) {
						planesState--;
						[visibleArrows addObject: xPlaneArrow];
					} else {
						planesState++;
						[visibleArrows removeObject: xPlaneArrow];
					}
				}
				if (toggledItem == radialMenu.planesYToggle) {
					if (toggledItem.selectedIndex == 0) {
						planesState--;
						[visibleArrows addObject: yPlaneArrow];
					} else {
						planesState++;
						[visibleArrows removeObject: yPlaneArrow];
					}
				}
				if (toggledItem == radialMenu.planesZToggle) {
					if (toggledItem.selectedIndex == 0) {
						planesState--;
						[visibleArrows addObject: zPlaneArrow];
					} else {
						planesState++;
						[visibleArrows removeObject: zPlaneArrow];
					}
				}
				if (planesState == 3) {
					[nextButton setVisible: YES];
					[self raiseEvenet: TUT_DISABLE_ALL_EVENT];
				}
				break;
			case 45:
				if (toggledItem == radialMenu.planesXToggle) {
					if (toggledItem.selectedIndex == 0) {
						planesState--;
						[visibleArrows removeObject: xPlaneArrow];
					} else {
						planesState++;
						[visibleArrows addObject: xPlaneArrow];
					}
				}
				if (toggledItem == radialMenu.planesYToggle) {
					if (toggledItem.selectedIndex == 0) {
						planesState--;
						[visibleArrows removeObject: yPlaneArrow];
					} else {
						planesState++;
						[visibleArrows addObject: yPlaneArrow];
					}
				}
				if (toggledItem == radialMenu.planesZToggle) {
					if (toggledItem.selectedIndex == 0) {
						planesState--;
						[visibleArrows removeObject: zPlaneArrow];
					} else {
						planesState++;
						[visibleArrows addObject: zPlaneArrow];
					}
				}
				if (planesState == 0) {
					[nextButton setVisible: YES];
					[self raiseEvenet: TUT_DISABLE_ALL_EVENT];
				}
				break;
			case 46:
				if (toggledItem == radialMenu.crossToggle && toggledItem.selectedIndex == 1) {
					[visibleArrows removeObject: recursiveArrow];
					[nextButton setVisible: YES];
					[self raiseEvenet: TUT_DISABLE_ALL_EVENT];
				}
				break;
			case 47:
				if ([radialMenu.crossSliderItems containsObject: toggledItem] && toggledItem.selectedIndex == 1) {
					[visibleArrows removeObject: recursiveLevelsArrow];
					[nextButton setVisible: YES];
					[self raiseEvenet: TUT_DISABLE_ALL_EVENT];
				}
			case 49:
				if (toggledItem == radialMenu.planesXToggle && toggledItem.selectedIndex == 1) {
					[visibleArrows removeObject: xPlaneArrow];
					[nextButton setVisible: YES];
					[self raiseEvenet: TUT_DISABLE_ALL_EVENT];
				}
				break;
			case 50:
				if (toggledItem == radialMenu.planesXToggle) {
					if (toggledItem.selectedIndex == 0) {
						[visibleArrows removeObject: xPlaneArrow];
					} else {
						[visibleArrows addObject: xPlaneArrow];
					}
				}
				if (toggledItem == radialMenu.crossToggle) {
					if (toggledItem.selectedIndex == 0) {
						[visibleArrows removeObject: recursiveArrow];
					} else {
						[visibleArrows addObject: recursiveArrow];
					}
				}
				if (radialMenu.planesXToggle.selectedIndex == 0 && radialMenu.crossToggle.selectedIndex == 0) {
					[nextButton setVisible: YES];
					[self raiseEvenet: TUT_DISABLE_ALL_EVENT];
				}
				break;
			case 51:
				if (radialMenu.brainToggle.selectedIndex == 1) {
					[visibleArrows removeObject: brainArrow];
					[nextButton setVisible: YES];
					[self raiseEvenet: TUT_DISABLE_ALL_EVENT];
				}
				break;
			case 53:
				if (radialMenu.woolToggle.selectedIndex == 1) {
					[visibleArrows removeObject: woolArrow];
					[nextButton setVisible: YES];
					[self raiseEvenet: TUT_DISABLE_ALL_EVENT];
				}
				break;
			case 54:
				if (radialMenu.woolToggle.selectedIndex == 0) {
					[visibleArrows removeObject: woolArrow];
					[nextButton setVisible: YES];
					[self raiseEvenet: TUT_DISABLE_ALL_EVENT];
				}
				break;
			case 56:
				if (radialMenu.breadToggle.selectedIndex == 1) {
					[visibleArrows removeObject: breadArrow];
					[nextButton setVisible: YES];
					[self raiseEvenet: TUT_DISABLE_ALL_EVENT];
				}
				break;
			case 57:
				if (radialMenu.breadToggle.selectedIndex == 0) {
					[visibleArrows removeObject: breadArrow];
					[nextButton setVisible: YES];
					[self raiseEvenet: TUT_DISABLE_ALL_EVENT];
				}
				break;
			case 59:
				if (radialMenu.signpostToggle.selectedIndex == 1) {
					[visibleArrows removeObject: signArrow];
					[nextButton setVisible: YES];
					[self raiseEvenet: TUT_DISABLE_ALL_EVENT];
				}
				break;
			case 60:
				if (radialMenu.signpostToggle.selectedIndex == 0) {
					[visibleArrows removeObject: signArrow];
					[nextButton setVisible: YES];
					[self raiseEvenet: TUT_DISABLE_ALL_EVENT];
				}
				break;
			case 62:
				if (radialMenu.flagToggle.selectedIndex == 1) {
					[visibleArrows removeObject: flagArrow];
					[nextButton setVisible: YES];
					[self raiseEvenet: TUT_DISABLE_ALL_EVENT];
				}
				break;
			case 64:
				if (radialMenu.flagToggle.selectedIndex == 0) {
					[visibleArrows removeObject: flagArrow];
					[nextButton setVisible: YES];
					[self raiseEvenet: TUT_DISABLE_ALL_EVENT];
				}
				break;
			case 67:
				if (toggledItem == radialMenu.breadToggle) {
					if (toggledItem.selectedIndex == 0) {
						[visibleArrows addObject: breadArrow];
					} else {
						[visibleArrows removeObject: breadArrow];
					}
				}
				if (toggledItem == radialMenu.brushToggle) {
					if (toggledItem.selectedIndex == 0) {
						[visibleArrows addObject: brushArrow];
					} else {
						[visibleArrows removeObject: brushArrow];
					}
				}
				if (radialMenu.breadToggle.selectedIndex == 1 && radialMenu.brushToggle.selectedIndex == 1) {
					[visibleArrows removeObject: breadArrow];
					[visibleArrows removeObject: brushArrow];
					[nextButton setVisible: YES];
					[self raiseEvenet: TUT_DISABLE_ALL_EVENT];
				}
				break;
			case 68:
				if (toggledItem == radialMenu.breadToggle) {
					if (toggledItem.selectedIndex == 0) {
						[visibleArrows removeObject: breadArrow];
					} else {
						[visibleArrows addObject: breadArrow];
					}
				}
				if (toggledItem == radialMenu.brushToggle) {
					if (toggledItem.selectedIndex == 0) {
						[visibleArrows removeObject: brushArrow];
					} else {
						[visibleArrows addObject: brushArrow];
					}
				}
				if (radialMenu.breadToggle.selectedIndex == 0 && radialMenu.brushToggle.selectedIndex == 0) {
					[nextButton setVisible: YES];
					[self raiseEvenet: TUT_DISABLE_ALL_EVENT];
				}
				break;
			case 69:
				if (radialMenu.gearToggle.selectedIndex == 1) {
					[visibleArrows removeObject: gearArrow];
					[nextButton setVisible: YES];
					[self raiseEvenet: TUT_DISABLE_ALL_EVENT];
				}
				break;
		}
	} else if ([[notification.object class] isSubclassOfClass: [Game class]]) {
		CCMenuItem* menuItem = [notification.userInfo objectForKey: INTF_ARROW_CLICK_USER_INFO];
		switch (stepNum) {
			case 15:
				if (menuItem == [game getLeftNWArrow] || menuItem == [game getRightNWArrow]) {
					[visibleArrows removeObject: NWArrowL];
					[visibleArrows removeObject: NWArrowR];
					[nextButton setVisible: YES];
					[self raiseEvenet: TUT_DISABLE_ALL_EVENT];
				}
				break;
			case 16:
				if (menuItem == [game getLeftNWArrow] || menuItem == [game getRightNWArrow]) {
					[visibleArrows removeObject: NWArrowL];
					[visibleArrows removeObject: NWArrowR];
					[nextButton setVisible: YES];
					[self raiseEvenet: TUT_DISABLE_ALL_EVENT];
				}
				break;
			case 17:
				if (menuItem == [game getLeftNArrow] || menuItem == [game getRightNArrow]) {
					[visibleArrows removeObject: NArrowL];
					[visibleArrows removeObject: NArrowR];
					[nextButton setVisible: YES];
					[self raiseEvenet: TUT_DISABLE_ALL_EVENT];
				}
				break;
			case 18:
				if (menuItem == [game getLeftNEArrow] || menuItem == [game getRightNEArrow]) {
					[visibleArrows removeObject: NEArrowL];
					[visibleArrows removeObject: NEArrowR];
					[nextButton setVisible: YES];
					[self raiseEvenet: TUT_DISABLE_ALL_EVENT];
				}
				break;
			case 19:
				if (menuItem == [game getLeftSArrow] || menuItem == [game getRightSArrow]) {
					[visibleArrows removeObject: SArrowL];
					[visibleArrows removeObject: SArrowR];
					[nextButton setVisible: YES];
					[self raiseEvenet: TUT_DISABLE_ALL_EVENT];
				}
				break;
			case 20:
				if (menuItem == [game getLeftCWArrow] || menuItem == [game getRightCWArrow]) {
					rotationState++;
				} else if (menuItem == [game getLeftCCWArrow] || menuItem == [game getRightCCWArrow]) {
					rotationState--;
				}
				if (rotationState % 4 == 0) {
					[visibleArrows removeObject: clockwiseArrowL];
					[visibleArrows removeObject: countercolckwiseArrowL];
					[visibleArrows removeObject: clockwiseArrowR];
					[visibleArrows removeObject: countercolckwiseArrowR];
					[nextButton setVisible: YES];
					[self raiseEvenet: TUT_DISABLE_ALL_EVENT];
				}
				break;
		}
	}
	[self displayArrows];
}

- (void) refreshTutotial {
	message.string = [self stepMessage];
	[visibleArrows removeAllObjects];
	[self raiseEvenet: TUT_DISABLE_ALL_EVENT];
	switch (stepNum) {
		case 2:
			[visibleArrows addObject: startArrow];
			[visibleArrows addObject: endArrow];
			break;
		case 3:
			[visibleArrows addObject: startArrow];
			break;
		case 4:
			[visibleArrows addObject: borderLeftArrow];
			[visibleArrows addObject: borderRightArrow];
			[visibleArrows addObject: borderTopArrow];
			break;
		case 6:
			[visibleArrows addObject: NArrowL];
			[visibleArrows addObject: NArrowR];
			break;
		case 7:
			[visibleArrows addObject: NArrowL];
			[visibleArrows addObject: NArrowR];
			break;
		case 8:
			[visibleArrows addObject: NArrowL];
			[visibleArrows addObject: NArrowR];
			break;
		case 9:
			[visibleArrows addObject: SArrowL];
			[visibleArrows addObject: SArrowR];
			break;
		case 10:
			[visibleArrows addObject: SWArrowL];
			[visibleArrows addObject: SWArrowR];
			break;
		case 11:
			[visibleArrows addObject: NEArrowL];
			[visibleArrows addObject: NEArrowR];
			break;
		case 12:
			[visibleArrows addObject: NWArrowL];
			[visibleArrows addObject: NWArrowR];
			break;
		case 13:
			[visibleArrows addObject: SEArrowL];
			[visibleArrows addObject: SEArrowR];
			break;
		case 14:
			[visibleArrows addObject: NWArrowL];
			[visibleArrows addObject: NEArrowL];
			[visibleArrows addObject: NWArrowR];
			[visibleArrows addObject: NEArrowR];
			break;
		case 15:
			[self raiseEvenet: TUT_ENABLE_NW_EVENT];
			[visibleArrows addObject: NWArrowL];
			[visibleArrows addObject: NWArrowR];
			[nextButton setVisible: NO];
			break;
		case 16:
			[self raiseEvenet: TUT_ENABLE_NW_EVENT];
			[visibleArrows addObject: NWArrowL];
			[visibleArrows addObject: NWArrowR];
			[nextButton setVisible: NO];
			break;
		case 17:
			[self raiseEvenet: TUT_ENABLE_N_EVENT];
			[visibleArrows addObject: NArrowL];
			[visibleArrows addObject: NArrowR];
			[nextButton setVisible: NO];
			break;
		case 18:
			[self raiseEvenet: TUT_ENABLE_NE_EVENT];
			[visibleArrows addObject: NEArrowL];
			[visibleArrows addObject: NEArrowR];
			[nextButton setVisible: NO];
			break;
		case 19:
			[self raiseEvenet: TUT_ENABLE_S_EVENT];
			[visibleArrows addObject: SArrowL];
			[visibleArrows addObject: SArrowR];
			[nextButton setVisible: NO];
			break;
		case 20:
			[self raiseEvenet: TUT_ENABLE_ROTATIONS_EVENT];
			[visibleArrows addObject: clockwiseArrowL];
			[visibleArrows addObject: countercolckwiseArrowL];
			[visibleArrows addObject: clockwiseArrowR];
			[visibleArrows addObject: countercolckwiseArrowR];
			[nextButton setVisible: NO];
			break;
		case 22:
			[visibleArrows addObject: clockArrow];
			break;
		case 23:
			[visibleArrows addObject: movesArrow];
			break;
		case 24:
			[visibleArrows addObject: unvisitedArrow];
			break;
		case 25:
			[visibleArrows addObject: visitedArrow];
			break;
		case 26:
			[self raiseEvenet: TUT_ENABLE_MENU_EVENT];
			[visibleArrows addObject: menuArrow];
			[nextButton setVisible: NO];
			break;
		case 27:
			[self raiseEvenet: TUT_ENABLE_MENU_EVENT];
			[visibleArrows addObject: menuArrow];
			break;
		case 28:
			[self raiseEvenet: TUT_ENABLE_MENU_EVENT];
			break;
		case 29:
			[self raiseEvenet: TUT_ENABLE_MENU_EVENT];
			[visibleArrows addObject: eyeArrow];
			break;
		case 30:
			[self raiseEvenet: TUT_ENABLE_MENU_EVENT];
			[self raiseEvenet: TUT_ENABLE_EYE_EVENT];
			[visibleArrows addObject: eyeArrow];
			[nextButton setVisible: NO];
			break;
		case 31:
			[self raiseEvenet: TUT_ENABLE_MENU_EVENT];
			[self raiseEvenet: TUT_ENABLE_EYE_EVENT];
			[self raiseEvenet: TUT_ENABLE_MAZE_EVENT];
			[visibleArrows addObject: mazeArrow];
			[nextButton setVisible: NO];
			break;
		case 32:
			[self raiseEvenet: TUT_ENABLE_MENU_EVENT];
			[self raiseEvenet: TUT_ENABLE_EYE_EVENT];
			[self raiseEvenet: TUT_ENABLE_CROSSHAIR_EVENT];
			[visibleArrows addObject: crosshairArrow];
			[nextButton setVisible: NO];
			break;
		case 33:
			[self raiseEvenet: TUT_ENABLE_MENU_EVENT];
			[self raiseEvenet: TUT_ENABLE_EYE_EVENT];
			break;
		case 34:
			[self raiseEvenet: TUT_ENABLE_MENU_EVENT];
			[self raiseEvenet: TUT_ENABLE_EYE_EVENT];
			[self raiseEvenet: TUT_ENABLE_CROSSHAIR_EVENT];
			[visibleArrows addObject: crosshairArrow];
			[nextButton setVisible: NO];
			break;
		case 35:
			[self raiseEvenet: TUT_ENABLE_MENU_EVENT];
			[self raiseEvenet: TUT_ENABLE_EYE_EVENT];
			[self raiseEvenet: TUT_ENABLE_CUBE_EVENT];
			[visibleArrows addObject: bordersArrow];
			[nextButton setVisible: NO];
			break;
		case 36:
			[self raiseEvenet: TUT_ENABLE_MENU_EVENT];
			[self raiseEvenet: TUT_ENABLE_EYE_EVENT];
			[self raiseEvenet: TUT_ENABLE_CUBE_EVENT];
			[visibleArrows addObject: bordersArrow];
			[nextButton setVisible: NO];
			break;
		case 37:
			[self raiseEvenet: TUT_ENABLE_MENU_EVENT];
			[self raiseEvenet: TUT_ENABLE_EYE_EVENT];
			[self raiseEvenet: TUT_ENABLE_COMPASS_EVENT];
			[visibleArrows addObject: compassArrow];
			[nextButton setVisible: NO];
			break;
		case 38:
			[self raiseEvenet: TUT_ENABLE_MENU_EVENT];
			[self raiseEvenet: TUT_ENABLE_EYE_EVENT];
			[self raiseEvenet: TUT_ENABLE_COMPASS_EVENT];
			[visibleArrows addObject: compassArrow];
			[nextButton setVisible: NO];
			break;
		case 39:
			[self raiseEvenet: TUT_ENABLE_MENU_EVENT];
			[self raiseEvenet: TUT_ENABLE_EYE_EVENT];
			[visibleArrows addObject: mazeArrow];
			break;
		case 40:
			[self raiseEvenet: TUT_ENABLE_MENU_EVENT];
			[self raiseEvenet: TUT_ENABLE_EYE_EVENT];
			[self raiseEvenet:TUT_ENABLE_MAZE_EVENT];
			[visibleArrows addObject: mazeArrow];
			[nextButton setVisible: NO];
			break;
		case 41:
			[self raiseEvenet: TUT_ENABLE_MENU_EVENT];
			[self raiseEvenet: TUT_ENABLE_PLANES_EVENT];
			[visibleArrows addObject: planesArrow];
			[nextButton setVisible: NO];
			break;
		case 42:
			[self raiseEvenet: TUT_ENABLE_MENU_EVENT];
			[self raiseEvenet: TUT_ENABLE_PLANES_EVENT];
			[visibleArrows addObject: xPlaneArrow];
			[visibleArrows addObject: yPlaneArrow];
			[visibleArrows addObject: zPlaneArrow];
			break;
		case 43:
			[self raiseEvenet: TUT_ENABLE_MENU_EVENT];
			[self raiseEvenet: TUT_ENABLE_PLANES_EVENT];
			[self raiseEvenet: TUT_ENABLE_PLANES_X_EVENT];
			[self raiseEvenet: TUT_ENABLE_PLANES_Y_EVENT];
			[self raiseEvenet: TUT_ENABLE_PLANES_Z_EVENT];
			[visibleArrows addObject: xPlaneArrow];
			[visibleArrows addObject: yPlaneArrow];
			[visibleArrows addObject: zPlaneArrow];
			[nextButton setVisible: NO];
			break;
		case 44:
			[self raiseEvenet: TUT_ENABLE_MENU_EVENT];
			[self raiseEvenet: TUT_ENABLE_PLANES_EVENT];
			break;
		case 45:
			[self raiseEvenet: TUT_ENABLE_MENU_EVENT];
			[self raiseEvenet: TUT_ENABLE_PLANES_EVENT];
			[self raiseEvenet: TUT_ENABLE_PLANES_X_EVENT];
			[self raiseEvenet: TUT_ENABLE_PLANES_Y_EVENT];
			[self raiseEvenet: TUT_ENABLE_PLANES_Z_EVENT];
			[visibleArrows addObject: xPlaneArrow];
			[visibleArrows addObject: yPlaneArrow];
			[visibleArrows addObject: zPlaneArrow];
			[nextButton setVisible: NO];
			break;
		case 46:
			[self raiseEvenet: TUT_ENABLE_MENU_EVENT];
			[self raiseEvenet: TUT_ENABLE_PLANES_EVENT];
			[self raiseEvenet: TUT_ENABLE_CROSS_EVENT];
			[visibleArrows addObject: recursiveArrow];
			[nextButton setVisible: NO];
			break;
		case 47:
			[self raiseEvenet: TUT_ENABLE_MENU_EVENT];
			[self raiseEvenet: TUT_ENABLE_PLANES_EVENT];
			[self raiseEvenet: TUT_ENABLE_CROSS_EVENT];
			[self raiseEvenet: TUT_ENABLE_CROSS_SLIDER_EVENT];
			[visibleArrows addObject: recursiveLevelsArrow];
			[nextButton setVisible: NO];
			break;
		case 48:
			[self raiseEvenet: TUT_ENABLE_MENU_EVENT];
			[self raiseEvenet: TUT_ENABLE_PLANES_EVENT];
			break;
		case 49:
			[self raiseEvenet: TUT_ENABLE_MENU_EVENT];
			[self raiseEvenet: TUT_ENABLE_PLANES_EVENT];
			[self raiseEvenet: TUT_ENABLE_PLANES_X_EVENT];
			[visibleArrows addObject: xPlaneArrow];
			[nextButton setVisible: NO];
			break;
		case 50:
			[self raiseEvenet: TUT_ENABLE_MENU_EVENT];
			[self raiseEvenet: TUT_ENABLE_PLANES_EVENT];
			[self raiseEvenet: TUT_ENABLE_PLANES_X_EVENT];
			[self raiseEvenet: TUT_ENABLE_CROSS_EVENT];
			[visibleArrows addObject: recursiveArrow];
			[visibleArrows addObject: xPlaneArrow];
			[nextButton setVisible: NO];
			break;
		case 51:
			[self raiseEvenet: TUT_ENABLE_MENU_EVENT];
			[self raiseEvenet: TUT_ENABLE_BRAIN_EVENT];
			[visibleArrows addObject: brainArrow];
			[nextButton setVisible: NO];
			break;
		case 52:
			[self raiseEvenet: TUT_ENABLE_MENU_EVENT];
			[self raiseEvenet: TUT_ENABLE_BRAIN_EVENT];
			[visibleArrows addObject: woolArrow];
			break;
		case 53:
			[self raiseEvenet: TUT_ENABLE_MENU_EVENT];
			[self raiseEvenet: TUT_ENABLE_BRAIN_EVENT];
			[self raiseEvenet: TUT_ENABLE_WOOL_EVENT];
			[visibleArrows addObject: woolArrow];
			[nextButton setVisible: NO];
			break;
		case 54:
			[self raiseEvenet: TUT_ENABLE_MENU_EVENT];
			[self raiseEvenet: TUT_ENABLE_BRAIN_EVENT];
			[self raiseEvenet: TUT_ENABLE_WOOL_EVENT];
			[visibleArrows addObject: woolArrow];
			[nextButton setVisible: NO];
			break;
		case 55:
			[self raiseEvenet: TUT_ENABLE_MENU_EVENT];
			[self raiseEvenet: TUT_ENABLE_BRAIN_EVENT];
			[visibleArrows addObject: breadArrow];
			break;
		case 56:
			[self raiseEvenet: TUT_ENABLE_MENU_EVENT];
			[self raiseEvenet: TUT_ENABLE_BRAIN_EVENT];
			[self raiseEvenet: TUT_ENABLE_BREAD_EVENT];
			[visibleArrows addObject: breadArrow];
			[nextButton setVisible: NO];
			break;
		case 57:
			[self raiseEvenet: TUT_ENABLE_MENU_EVENT];
			[self raiseEvenet: TUT_ENABLE_BRAIN_EVENT];
			[self raiseEvenet: TUT_ENABLE_BREAD_EVENT];
			[visibleArrows addObject: breadArrow];
			[nextButton setVisible: NO];
			break;
		case 58:
			[self raiseEvenet: TUT_ENABLE_MENU_EVENT];
			[self raiseEvenet: TUT_ENABLE_BRAIN_EVENT];
			[visibleArrows addObject: signArrow];
			break;
		case 59:
			[self raiseEvenet: TUT_ENABLE_MENU_EVENT];
			[self raiseEvenet: TUT_ENABLE_BRAIN_EVENT];
			[self raiseEvenet: TUT_ENABLE_SIGNPOST_EVENT];
			[visibleArrows addObject: signArrow];
			[nextButton setVisible: NO];
			break;
		case 60:
			[self raiseEvenet: TUT_ENABLE_MENU_EVENT];
			[self raiseEvenet: TUT_ENABLE_BRAIN_EVENT];
			[self raiseEvenet: TUT_ENABLE_SIGNPOST_EVENT];
			[visibleArrows addObject: signArrow];
			[nextButton setVisible: NO];
			break;
		case 61:
			[self raiseEvenet: TUT_ENABLE_MENU_EVENT];
			[self raiseEvenet: TUT_ENABLE_BRAIN_EVENT];
			[visibleArrows addObject: flagArrow];
			break;
		case 62:
			[self raiseEvenet: TUT_ENABLE_MENU_EVENT];
			[self raiseEvenet: TUT_ENABLE_BRAIN_EVENT];
			[self raiseEvenet: TUT_ENABLE_FLAG_EVENT];
			[visibleArrows addObject: flagArrow];
			[nextButton setVisible: NO];
			break;
		case 63:
			[self raiseEvenet: TUT_ENABLE_MENU_EVENT];
			[self raiseEvenet: TUT_ENABLE_BRAIN_EVENT];
			[self raiseEvenet: TUT_ENABLE_FLAG_EVENT];
			[self raiseEvenet: TUT_ENABLE_FLAG_SLIDER_EVENT];
			[visibleArrows addObject: flagLevelsArrow];
			break;
		case 64:
			[self raiseEvenet: TUT_ENABLE_MENU_EVENT];
			[self raiseEvenet: TUT_ENABLE_BRAIN_EVENT];
			[self raiseEvenet: TUT_ENABLE_FLAG_EVENT];
			[visibleArrows addObject: flagArrow];
			[nextButton setVisible: NO];
			break;
		case 65:
			[self raiseEvenet: TUT_ENABLE_MENU_EVENT];
			[self raiseEvenet: TUT_ENABLE_BRAIN_EVENT];
			[visibleArrows addObject: brushArrow];
			break;
		case 66:
			[self raiseEvenet: TUT_ENABLE_MENU_EVENT];
			[self raiseEvenet: TUT_ENABLE_BRAIN_EVENT];
			[visibleArrows addObject: brushArrow];
			break;
		case 67:
			[self raiseEvenet: TUT_ENABLE_MENU_EVENT];
			[self raiseEvenet: TUT_ENABLE_BRAIN_EVENT];
			[self raiseEvenet: TUT_ENABLE_BRUSH_EVENT];
			[self raiseEvenet: TUT_ENABLE_BREAD_EVENT];
			[visibleArrows addObject: breadArrow];
			[visibleArrows addObject: brushArrow];
			[nextButton setVisible: NO];
			break;
		case 68:
			[self raiseEvenet: TUT_ENABLE_MENU_EVENT];
			[self raiseEvenet: TUT_ENABLE_BRAIN_EVENT];
			[self raiseEvenet: TUT_ENABLE_BRUSH_EVENT];
			[self raiseEvenet: TUT_ENABLE_BREAD_EVENT];
			[visibleArrows addObject: breadArrow];
			[visibleArrows addObject: brushArrow];
			[nextButton setVisible: NO];
			break;
		case 69:
			[self raiseEvenet: TUT_ENABLE_MENU_EVENT];
			[self raiseEvenet: TUT_ENABLE_GEAR_EVENT];
			[visibleArrows addObject: gearArrow];
			[nextButton setVisible: NO];
			break;
		case 70:
			[self raiseEvenet: TUT_ENABLE_MENU_EVENT];
			[self raiseEvenet: TUT_ENABLE_GEAR_EVENT];
			[self raiseEvenet: TUT_ENABLE_NOTE_EVENT];
			[self raiseEvenet: TUT_ENABLE_SPEAKER_EVENT];
			[visibleArrows addObject: noteArrow];
			[visibleArrows addObject: speakerArrow];
			break;
		case 71:
			[self raiseEvenet: TUT_ENABLE_MENU_EVENT];
			[self raiseEvenet: TUT_ENABLE_GEAR_EVENT];
			[visibleArrows addObject: rArrow];
			break;
		case 72:
			[self raiseEvenet: TUT_ENABLE_MENU_EVENT];
			[self raiseEvenet: TUT_ENABLE_GEAR_EVENT];
			[visibleArrows addObject: xArrow];
			break;
		case 73:
			[nextButton.label setString: @"End tutorial"];
			break;
		case 74:
			[[CCDirector sharedDirector] replaceScene: [CCTransitionCrossFade transitionWithDuration:0.5 scene: [MainMenuLayer scene]]];
			break;
		default:
			break;
	}
	[self displayArrows];
}

- (void) nextStep {
	stepNum++;
	[self hideAllArrows];
	[self refreshTutotial];
}

- (void) dealloc {
	[startArrow release];
	[endArrow release];
	[menuArrow release];
	
	[NWArrowL release];
	[SWArrowL release];
	[NArrowL release];
	[SArrowL release];
	[NEArrowL release];
	[SEArrowL release];
	
	[NWArrowR release];
	[SWArrowR release];
	[NArrowR release];
	[SArrowR release];
	[NEArrowR release];
	[SEArrowR release];
	
	[clockwiseArrowL release];
	[countercolckwiseArrowL release];
	[clockwiseArrowR release];
	[countercolckwiseArrowR release];
	
	[clockArrow release];
	[movesArrow release];
	[unvisitedArrow release];
	[visitedArrow release];
	
	[brainArrow release];
	[planesArrow release];
	[eyeArrow release];
	[gearArrow release];
	
	[speakerArrow release];
	[noteArrow release];
	[xArrow release];
	[rArrow release];
	
	[mazeArrow release];
	[crosshairArrow release];
	[bordersArrow release];
	[compassArrow release];
	
	[xPlaneArrow release];
	[yPlaneArrow release];
	[zPlaneArrow release];
	[recursiveArrow release];
	[recursiveLevelsArrow release];
	
	[woolArrow release];
	[breadArrow release];
	[signArrow release];
	[flagArrow release];
	[flagLevelsArrow release];
	
	[dialog release];
	[message release];
	[nextButton release];
	
	[game release];
	[radialMenu release];
	
	[arrowButtonTree release];
	[visibleArrows release];
	[toggleArrowDict release];
	
	[confirmEnd release];
	[endDialog release];
	
	[super dealloc];
}

- (void) openDialog: (CCScene*) scene {
	[dialog openInScene: scene];
	[endDialog openInScene: scene];
}

@end
