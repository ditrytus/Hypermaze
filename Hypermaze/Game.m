//
//  Game.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 29.07.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Game.h"
#import "cocos2d.h"
#import "HPDirectionUtil.h"
#import "PathBuilder.h"

#define ARROW_SIZE			CGSizeMake(82,128)
#define ROTATE_ARROW_SIZE	CGSizeMake(100,116)

@implementation Game

- (CCMenuItem*) getLeftNArrow {
	return  ((CCMenuItem*)[((CCMenu*)[interfaceLayer.children objectAtIndex:0]).children objectAtIndex:0]);
}

- (CCMenuItem*) getLeftNWArrow {
	return  ((CCMenuItem*)[((CCMenu*)[interfaceLayer.children objectAtIndex:0]).children objectAtIndex:1]);
}

- (CCMenuItem*) getLeftNEArrow {
	return  ((CCMenuItem*)[((CCMenu*)[interfaceLayer.children objectAtIndex:0]).children objectAtIndex:2]);
}

- (CCMenuItem*) getLeftSWArrow {
	return  ((CCMenuItem*)[((CCMenu*)[interfaceLayer.children objectAtIndex:0]).children objectAtIndex:3]);
}

- (CCMenuItem*) getLeftSEArrow {
	return  ((CCMenuItem*)[((CCMenu*)[interfaceLayer.children objectAtIndex:0]).children objectAtIndex:4]);
}

- (CCMenuItem*) getLeftSArrow {
	return  ((CCMenuItem*)[((CCMenu*)[interfaceLayer.children objectAtIndex:0]).children objectAtIndex:5]);
}

- (CCMenuItem*) getLeftCWArrow {
	return  ((CCMenuItem*)[((CCMenu*)[interfaceLayer.children objectAtIndex:0]).children objectAtIndex:6]);
}

- (CCMenuItem*) getLeftCCWArrow {
	return  ((CCMenuItem*)[((CCMenu*)[interfaceLayer.children objectAtIndex:0]).children objectAtIndex:7]);
}

- (CCMenuItem*) getRightNArrow {
	return  ((CCMenuItem*)[((CCMenu*)[interfaceLayer.children objectAtIndex:1]).children objectAtIndex:0]);
}

- (CCMenuItem*) getRightNWArrow {
	return  ((CCMenuItem*)[((CCMenu*)[interfaceLayer.children objectAtIndex:1]).children objectAtIndex:1]);
}

- (CCMenuItem*) getRightNEArrow {
	return  ((CCMenuItem*)[((CCMenu*)[interfaceLayer.children objectAtIndex:1]).children objectAtIndex:2]);
}

- (CCMenuItem*) getRightSWArrow {
	return  ((CCMenuItem*)[((CCMenu*)[interfaceLayer.children objectAtIndex:1]).children objectAtIndex:3]);
}

- (CCMenuItem*) getRightSEArrow {
	return  ((CCMenuItem*)[((CCMenu*)[interfaceLayer.children objectAtIndex:1]).children objectAtIndex:4]);
}

- (CCMenuItem*) getRightSArrow {
	return  ((CCMenuItem*)[((CCMenu*)[interfaceLayer.children objectAtIndex:1]).children objectAtIndex:5]);
}

- (CCMenuItem*) getRightCWArrow {
	return  ((CCMenuItem*)[((CCMenu*)[interfaceLayer.children objectAtIndex:1]).children objectAtIndex:6]);
}

- (CCMenuItem*) getRightCCWArrow {
	return  ((CCMenuItem*)[((CCMenu*)[interfaceLayer.children objectAtIndex:1]).children objectAtIndex:7]);
}

+ (CCMenuItemSprite*) createArrowWithName: (NSString*) arrowName target: (id) target selector: (SEL) selector {
	CCSprite* arrowOn = [CCSprite spriteWithFile:arrowName];
	arrowOn.opacity = 128;
	CCSprite* arrowOff = [CCSprite spriteWithFile:arrowName];
	arrowOff.opacity = 64;
	CCMenuItemSprite* arrow = [CCMenuItemSprite itemFromNormalSprite:arrowOff selectedSprite:arrowOn target:target selector:selector];
	[arrow setAnchorPoint:ccp(0,0)];
	return arrow;
}

- (CCMenu *)createArrowSet {
	CGSize arrowSize = ARROW_SIZE;
	CGSize rotateSize = ROTATE_ARROW_SIZE;	
	CCMenuItemSprite *nArrow = [Game createArrowWithName:@"iso_arrow_n.png" target:self selector:@selector(onN:)];
	[nArrow setPosition: ccp(arrowSize.width ,arrowSize.height)];
	CCMenuItemSprite *sArrow = [Game createArrowWithName:@"iso_arrow_s.png" target:self selector:@selector(onS:)];
	[sArrow setPosition: ccp(arrowSize.width,0)];
	CCMenuItemSprite *nwArrow = [Game createArrowWithName:@"iso_arrow_nw.png" target:self selector:@selector(onNW:)];
	[nwArrow setPosition: ccp(0,arrowSize.height)];
	CCMenuItemSprite *neArrow = [Game createArrowWithName:@"iso_arrow_ne.png" target:self selector:@selector(onNE:)];
	[neArrow setPosition:  ccp(arrowSize.width * 2, arrowSize.height)];
	CCMenuItemSprite *swArrow = [Game createArrowWithName:@"iso_arrow_sw.png" target:self selector:@selector(onSW:)];
	[swArrow setPosition: ccp(0,0)];
	CCMenuItemSprite *seArrow = [Game createArrowWithName:@"iso_arrow_se.png" target:self selector:@selector(onSE:)];
	[seArrow setPosition: ccp(arrowSize.width*2,0)];
	
	CCMenuItemSprite *clockwiseArrow = [Game createArrowWithName:@"rotateArrowClockwise.png" target:self selector:@selector(onClockwise:)];
	[clockwiseArrow setPosition: ccp((arrowSize.width*3 - (rotateSize.width * 2))/2.0,arrowSize.height * 2)];
	
	CCMenuItemSprite *counterclockwiseArrow = [Game createArrowWithName:@"rotateArrowCounterclockwise.png" target:self selector:@selector(onCounterclockwise:)];
	[counterclockwiseArrow setPosition:ccpAdd(clockwiseArrow.position, ccp(rotateSize.width, 0))];
	
	CCMenu* arrowsMenu = [CCMenu menuWithItems: nArrow, nwArrow, neArrow, swArrow ,seArrow, sArrow, clockwiseArrow, counterclockwiseArrow, nil];
	return arrowsMenu;
}

- (void) changeMusicTrack {
	[[HPSound sharedSound] playMusic];
}

-(id)initWithLogic: (HPLogic*) newLogic {
	self = [super init];
	if (self) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPositionChanged:) name:EVENT_POSITION_CHANGED object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRotated:) name:EVENT_ROTATED object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onViewChanged:) name:EVENT_VIEW_CHANGED object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMazeFinished:) name:EVENT_MAZE_FINISHED object:nil];
		
		logic = [newLogic retain];
		
		size = [[CCDirector sharedDirector] winSize];
		middleScreen = ccp( size.width /2 , size.height/2 );
		
		mazeLayer = [[[HPMazeLayer alloc] initWithLogic: logic] retain];
		mazeLayer.positionInPixels = ccp(-80,-85);
		[self addChild: mazeLayer];
		
		compassArrow = [[CCSprite spriteWithFile:@"compass_arrow.png"] retain];
		compassArrow.opacity = 150;
		compassArrow.anchorPoint = ccp(0.5, (-200.0+116.0/2.0)/116.0);
		compassArrow.position = middleScreen;
		compassArrow.rotation = [mazeLayer getCompassAngle];
		compassArrow.visible = NO;
		[self addChild:compassArrow];
		
		infoPanel = [[InfoPanel alloc] initWithLogic:logic];
		[self addChild: infoPanel];
		
		interfaceLayer = [[CCLayer node] retain];
		
		CCMenu *arrowsLeftMenu = [self createArrowSet];
		arrowsLeftMenu.position = ccp(0,0);
		[interfaceLayer	addChild:arrowsLeftMenu];
		
		CCMenu *arrowsRightMenu = [self createArrowSet];
		arrowsRightMenu.position = ccp(size.width - ARROW_SIZE.width*3,0);
		[interfaceLayer	addChild:arrowsRightMenu];
		
		[self addChild: interfaceLayer];
		
		radialMenuLayer = [[RadialMenuLayer alloc] initWithLogic:logic game:self isInTutorial: isTutorial];
		[self addChild: radialMenuLayer];
		
		if (isTutorial) {
			tutorialLayer = [[TutorialLayer alloc] initWithGame:self radialMenu:radialMenuLayer];
			[self addChild: tutorialLayer];
			[tutorialLayer openDialog:self];
		}
		
		[[HPSound sharedSound] playGamePlaylist];
		[self schedule:@selector(changeMusicTrack) interval:2];
	}
	return self;
}

- (void)wireUpTutorialEvents {
  [[NSNotificationCenter defaultCenter] addObserverForName: TUT_DISABLE_ALL_EVENT
													  object: nil
													   queue: nil
												  usingBlock: ^(NSNotification* noification){
													  //LEFT
													  ((CCMenuItem*)[((CCMenu*)[interfaceLayer.children objectAtIndex:0]).children objectAtIndex:0]).isEnabled = NO; //N
													  ((CCMenuItem*)[((CCMenu*)[interfaceLayer.children objectAtIndex:0]).children objectAtIndex:1]).isEnabled = NO; //NW
													  ((CCMenuItem*)[((CCMenu*)[interfaceLayer.children objectAtIndex:0]).children objectAtIndex:2]).isEnabled = NO; //NE
													  ((CCMenuItem*)[((CCMenu*)[interfaceLayer.children objectAtIndex:0]).children objectAtIndex:3]).isEnabled = NO; //SW
													  ((CCMenuItem*)[((CCMenu*)[interfaceLayer.children objectAtIndex:0]).children objectAtIndex:4]).isEnabled = NO; //SE
													  ((CCMenuItem*)[((CCMenu*)[interfaceLayer.children objectAtIndex:0]).children objectAtIndex:5]).isEnabled = NO; //S
													  ((CCMenuItem*)[((CCMenu*)[interfaceLayer.children objectAtIndex:0]).children objectAtIndex:6]).isEnabled = NO; //CW
													  ((CCMenuItem*)[((CCMenu*)[interfaceLayer.children objectAtIndex:0]).children objectAtIndex:7]).isEnabled = NO; //CCW
													  
													  //RIGHT
													  ((CCMenuItem*)[((CCMenu*)[interfaceLayer.children objectAtIndex:1]).children objectAtIndex:0]).isEnabled = NO; //N
													  ((CCMenuItem*)[((CCMenu*)[interfaceLayer.children objectAtIndex:1]).children objectAtIndex:1]).isEnabled = NO; //NW
													  ((CCMenuItem*)[((CCMenu*)[interfaceLayer.children objectAtIndex:1]).children objectAtIndex:2]).isEnabled = NO; //NE
													  ((CCMenuItem*)[((CCMenu*)[interfaceLayer.children objectAtIndex:1]).children objectAtIndex:3]).isEnabled = NO; //SW
													  ((CCMenuItem*)[((CCMenu*)[interfaceLayer.children objectAtIndex:1]).children objectAtIndex:4]).isEnabled = NO; //SE
													  ((CCMenuItem*)[((CCMenu*)[interfaceLayer.children objectAtIndex:1]).children objectAtIndex:5]).isEnabled = NO; //S
													  ((CCMenuItem*)[((CCMenu*)[interfaceLayer.children objectAtIndex:1]).children objectAtIndex:6]).isEnabled = NO; //CW
													  ((CCMenuItem*)[((CCMenu*)[interfaceLayer.children objectAtIndex:1]).children objectAtIndex:7]).isEnabled = NO; //CCW
												  }];
	[[NSNotificationCenter defaultCenter] addObserverForName: TUT_ENABLE_N_EVENT
													  object: nil
													   queue: nil
												  usingBlock: ^(NSNotification* noification){
													  ((CCMenuItem*)[((CCMenu*)[interfaceLayer.children objectAtIndex:0]).children objectAtIndex:0]).isEnabled = YES; //N
													  ((CCMenuItem*)[((CCMenu*)[interfaceLayer.children objectAtIndex:1]).children objectAtIndex:0]).isEnabled = YES; //N
												  }];
	[[NSNotificationCenter defaultCenter] addObserverForName: TUT_ENABLE_NE_EVENT
													  object: nil
													   queue: nil
												  usingBlock: ^(NSNotification* noification){
													  ((CCMenuItem*)[((CCMenu*)[interfaceLayer.children objectAtIndex:0]).children objectAtIndex:2]).isEnabled = YES; //NE
													  ((CCMenuItem*)[((CCMenu*)[interfaceLayer.children objectAtIndex:1]).children objectAtIndex:2]).isEnabled = YES; //NE
												  }];
	[[NSNotificationCenter defaultCenter] addObserverForName: TUT_ENABLE_NW_EVENT
													  object: nil
													   queue: nil
												  usingBlock: ^(NSNotification* noification){
													  ((CCMenuItem*)[((CCMenu*)[interfaceLayer.children objectAtIndex:0]).children objectAtIndex:1]).isEnabled = YES; //NW
													  ((CCMenuItem*)[((CCMenu*)[interfaceLayer.children objectAtIndex:1]).children objectAtIndex:1]).isEnabled = YES; //NW
												  }];
	[[NSNotificationCenter defaultCenter] addObserverForName: TUT_ENABLE_S_EVENT
													  object: nil
													   queue: nil
												  usingBlock: ^(NSNotification* noification){
													  ((CCMenuItem*)[((CCMenu*)[interfaceLayer.children objectAtIndex:0]).children objectAtIndex:5]).isEnabled = YES; //S
													  ((CCMenuItem*)[((CCMenu*)[interfaceLayer.children objectAtIndex:1]).children objectAtIndex:5]).isEnabled = YES; //S
												  }];
	[[NSNotificationCenter defaultCenter] addObserverForName: TUT_ENABLE_SW_EVENT
													  object: nil
													   queue: nil
												  usingBlock: ^(NSNotification* noification){
													  ((CCMenuItem*)[((CCMenu*)[interfaceLayer.children objectAtIndex:0]).children objectAtIndex:3]).isEnabled = YES; //SW
													  ((CCMenuItem*)[((CCMenu*)[interfaceLayer.children objectAtIndex:1]).children objectAtIndex:3]).isEnabled = YES; //SW
												  }];
	[[NSNotificationCenter defaultCenter] addObserverForName: TUT_ENABLE_SE_EVENT
													  object: nil
													   queue: nil
												  usingBlock: ^(NSNotification* noification){
													  ((CCMenuItem*)[((CCMenu*)[interfaceLayer.children objectAtIndex:0]).children objectAtIndex:4]).isEnabled = YES; //SE
													  ((CCMenuItem*)[((CCMenu*)[interfaceLayer.children objectAtIndex:1]).children objectAtIndex:4]).isEnabled = YES; //SE
												  }];
	[[NSNotificationCenter defaultCenter] addObserverForName: TUT_ENABLE_ROTATIONS_EVENT
													  object: nil
													   queue: nil
												  usingBlock: ^(NSNotification* noification){
													  ((CCMenuItem*)[((CCMenu*)[interfaceLayer.children objectAtIndex:0]).children objectAtIndex:6]).isEnabled = YES; //CW
													  ((CCMenuItem*)[((CCMenu*)[interfaceLayer.children objectAtIndex:0]).children objectAtIndex:7]).isEnabled = YES; //CCW
													  ((CCMenuItem*)[((CCMenu*)[interfaceLayer.children objectAtIndex:1]).children objectAtIndex:6]).isEnabled = YES; //CW
													  ((CCMenuItem*)[((CCMenu*)[interfaceLayer.children objectAtIndex:1]).children objectAtIndex:7]).isEnabled = YES; //CCW
												  }];

}
- (id) initTutorial {
	[self wireUpTutorialEvents];
	NSString* filePath = [[PathBuilder resourceDirectory] stringByAppendingPathComponent: TUTORIAL_DATA_FILE];
	NSLog(@"%@", filePath);
	HPLogic* tutorialLogic = [[NSKeyedUnarchiver unarchiveObjectWithFile: filePath] autorelease];
	isTutorial = true;
	return [self initWithLogic: tutorialLogic];
}

- (void) saveGame {
	if (!isTutorial) {
		NSFileManager *fileManager= [NSFileManager defaultManager];
		NSString* saveGameDir = [PathBuilder savedGameDirectory:[logic.beginDate description]];
		if (![fileManager fileExistsAtPath:saveGameDir]) {
			NSError* error;
			if(![fileManager createDirectoryAtPath:saveGameDir withIntermediateDirectories:YES attributes:nil error:&error]) {
				NSLog(@"%@", [error description]);
			}
		}
		
		if ([NSKeyedArchiver archiveRootObject:logic
										toFile:[saveGameDir stringByAppendingPathComponent:SAVE_DATA_FILE]]) {
			NSLog(@"Save OK");
		} else {
			NSLog(@"Save ERROR");
		}
		
		NSDictionary* metadata = [NSDictionary dictionaryWithObjectsAndKeys:
								  logic.beginDate, @"beginDate",
								  [NSNumber numberWithInt: logic.maze.size], @"size",
								  [NSNumber numberWithDouble: [logic.gameState getTimeElapsed]], @"timeElapsed",
								  [NSNumber numberWithInt: logic.gameState.movesMade], @"movesMade",
								  [NSNumber numberWithInt: [logic getNumOfVisited]], @"numOfVisited",
								  [NSNumber numberWithInt: [logic getTotalChambers]], @"totalChambers",
								  nil];
		
		CGSize screenshotSize = CGSizeMake(790, 130);
		CCRenderTexture* screenshot = [CCRenderTexture renderTextureWithWidth:screenshotSize.width height:screenshotSize.height];
		[screenshot begin];
		mazeLayer.position = ccpSub(ccpAdd(ccpSub(ccp(screenshotSize.width/2.0,screenshotSize.height/2.0),middleScreen),ccp(-80,-85)),[mazeLayer getTranslation]);
		[mazeLayer visit];
		[screenshot end];
		[screenshot saveBuffer:[saveGameDir stringByAppendingPathComponent:SAVE_SCREENSHOT_FILE] format:kCCImageFormatJPG];
		if (![metadata writeToFile:[saveGameDir stringByAppendingPathComponent:SAVE_METADATA_FILE] atomically:YES]) {
			NSLog(@"METADATA ERROR");
		}
	}
}

- (void)raiseArrowClickEvent:(CCMenuItem *)menuItem  {
  [[NSNotificationCenter defaultCenter] postNotificationName: INTF_ARROW_CLICK_EVENT
														object: self
													  userInfo: [NSDictionary dictionaryWithObject:menuItem
																							forKey:INTF_ARROW_CLICK_USER_INFO]];

}
- (void) onN: (CCMenuItem  *) menuItem {
	[logic moveInDirection: [HPDirectionUtil rotateDirection: dirNorth by: -logic.rotation]];
	[self raiseArrowClickEvent: menuItem];

}

- (void) onNW: (CCMenuItem  *) menuItem {
	[logic moveInDirection: [HPDirectionUtil rotateDirection: dirNorthWest by: -logic.rotation]];
	[self raiseArrowClickEvent: menuItem];
}

- (void) onNE: (CCMenuItem  *) menuItem {
	[logic moveInDirection: [HPDirectionUtil rotateDirection: dirNorthEast by: -logic.rotation]];
	[self raiseArrowClickEvent: menuItem];
}

- (void) onSW: (CCMenuItem  *) menuItem {
	[logic moveInDirection: [HPDirectionUtil rotateDirection: dirSouthWest by: -logic.rotation]];
	[self raiseArrowClickEvent: menuItem];
}

- (void) onSE: (CCMenuItem  *) menuItem {
	[logic moveInDirection: [HPDirectionUtil rotateDirection: dirSouthEast by: -logic.rotation]];
	[self raiseArrowClickEvent: menuItem];
}

- (void) onS: (CCMenuItem  *) menuItem {
	[logic moveInDirection: [HPDirectionUtil rotateDirection: dirSouth by: -logic.rotation]];
	[self raiseArrowClickEvent: menuItem];
}

- (void) onClockwise: (CCMenuItem  *) menuItem {
	[logic rotateClockwise];
	[self raiseArrowClickEvent: menuItem];
	[[HPSound sharedSound] playSound: SOUND_DOUBLE_TICK];
}

- (void) onCounterclockwise: (CCMenuItem  *) menuItem {
	[logic rotateCounterclockwise];
	[self raiseArrowClickEvent: menuItem];
	[[HPSound sharedSound] playSound: SOUND_DOUBLE_TICK];
}

- (void) onViewChanged: (NSNotification*) notification {
	if (logic.showCompass) {
		compassArrow.visible = YES;
	} else {
		compassArrow.visible = NO;
	}
}

- (void)updateCompassArrow {
  [compassArrow runAction:
	 [CCEaseOut actionWithAction:
	  [CCRotateTo actionWithDuration:1
							   angle:[mazeLayer getCompassAngle]]
						   rate:2]];

}
- (void) onPositionChanged: (NSNotification*) notification {
	[[HPSound sharedSound] playFootstep];
	[self updateCompassArrow];
}

- (void) onRotated: (NSNotification*) notification {
	[self updateCompassArrow];
}

- (void) onMazeFinished: (NSNotification*) notification {
	[[HPSound sharedSound] playSound: SOUND_APPLAUSE];
	compassArrow.visible = NO;
	infoPanel.visible = NO;
	radialMenuLayer.visible = NO;
	interfaceLayer.visible = NO;
	[self addChild: [[FinishLayer alloc] initWithLogic: logic]];
	NSError* error;
	if (![[NSFileManager defaultManager] removeItemAtPath:[PathBuilder savedGameDirectory:[logic.beginDate description]] error: &error]) {
		NSLog(@"%@", error);
	}
	if ([[HPGameCenter sharedGameCenter] isGameCenterAvailable]) {
		[[HPAchievementsManager sharedAchievementsManager] increaseWinCountForMazeSize: logic.maze.size];
	}
}

-(void) dealloc {
	[mazeLayer release];
	[logic release];
	[interfaceLayer release];
	[tutorialLayer release];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_POSITION_CHANGED object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_ROTATED object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_VIEW_CHANGED object:nil];
	[super dealloc];
}

@end
