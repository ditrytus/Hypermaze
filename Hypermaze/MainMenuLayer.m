//
//  MainMenuScene.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 11-07-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainMenuLayer.h"
#import "LoadingLayer.h"
#import "cocos2d.h"
#import "HPConfiguration.h"
#import "NSFileManager+ArrayOfFoldersInFolder.h"
#import "PathBuilder.h"
#import "NSArray+Reverse.h"
#import "InfoPanel.h"
#import "Game.h"
#import "CCDialog.h"
#import "DeleteConfirmDialog.h"



const int MENU_MOVE_DISTANCE = 1000;
const float MENU_TRANSITION_DURATION = 0.5;
const int MENU_TRANSTITION_EASING_RATE = 4;
const int MAX_MAZE_SIZE = 20;
const int MIN_MAZE_SIZE = 3;

const float RESUME_SCROLL_DURATION = 0.20;
const int RESUME_SCROLL_EASING_RATE = 1;

const int RESUME_ITEMS_ON_PAGE = 3;
const int RESUME_ITEM_HEIGHT = 130;
const int RESUME_ITEM_WIDTH = 790;
const int RESUME_ITEMS_MARGIN = 40;

@implementation MainMenuLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	MainMenuLayer *layer = [MainMenuLayer node];
	[scene addChild: layer];
	return scene;
}

- (CCMenuItemSprite* ) menuItemSpriteFromNormalFrameName: (NSString*)normal selectedFameName: (NSString*)selected selector: (SEL)selector {
	CCSprite *normalSprite = [CCSprite spriteWithSpriteFrameName: normal];
	CCSprite *selectedSprite = [CCSprite spriteWithSpriteFrameName: selected];
	CCSprite *disabledSprite = [CCSprite spriteWithSpriteFrameName: normal];
	[disabledSprite setColor: ccGRAY];
	CCMenuItemSprite *menuItemSprite = [CCMenuItemSprite itemFromNormalSprite: normalSprite
															   selectedSprite: selectedSprite
															   disabledSprite: disabledSprite
																	   target: self
																	 selector: selector];
	return menuItemSprite;
}

- (CCMenuItemToggle*) menuItemToggle: (SEL)selector {
	CCSprite *onSprite = [CCSprite spriteWithSpriteFrameName: @"on_en.png"];
	CCMenuItemSprite *onItem = [CCMenuItemSprite itemFromNormalSprite: onSprite selectedSprite: nil];
	CCSprite *offSprite = [CCSprite spriteWithSpriteFrameName:@"off_en.png"];
	CCMenuItemSprite *offItem = [CCMenuItemSprite itemFromNormalSprite: offSprite selectedSprite: nil];
	return [CCMenuItemToggle itemWithTarget:self
								   selector:selector
									  items:onItem, offItem, nil];
}

- (void)goBackTo: (CCMenu*) destinationMenu from: (CCMenu*) currentMenu {
	if (!isInTrasition) {
		isInTrasition = YES;
		[[HPSound sharedSound] playSound: SOUND_MENU_SILDE];
		[destinationMenu runAction:
		 [CCSequence actions:
		  [CCCallBlock actionWithBlock:^{
			 destinationMenu.visible = YES;
		  }],
		  [[showFromLeftAndFadeIn copy] autorelease],
		  [CCCallBlock actionWithBlock:^{
			 isInTrasition = NO;
			 if (destinationMenu == mainMenu) {
				 [resumeButton setIsEnabled:[savedGames count]>0];
			 }
		 }],
		  nil]];
		[currentMenu runAction:
		 [CCSequence actions:
		  [[hideToRightAndFadeOut copy] autorelease],
		  [CCCallBlock actionWithBlock:^{
			 currentMenu.visible = NO;
		 }],
		  nil]];
	}
}

- (void)goTo: (CCNode*)destinationMenu from: (CCNode*)currentMenu {
	if(!isInTrasition) {
		isInTrasition = YES;
		[[HPSound sharedSound] playSound: SOUND_MENU_SILDE];
		[currentMenu runAction:
		 [CCSequence actions:
		  [[hideToLeftAndFadeOut copy] autorelease],
		  [CCCallBlock actionWithBlock:
		   ^(){
			   currentMenu.visible = NO;
		   }],
		  nil]];
		
		[destinationMenu runAction:
		 [CCSequence actions:
		  [CCCallBlock actionWithBlock:
		   ^(){
			   destinationMenu.visible = YES;
		   }],
		  [[showFromRightAndFadeIn copy] autorelease],
		  [CCCallBlock actionWithBlock:^{
			 isInTrasition = NO;
		  }],
		  nil]];
	}
}

- (CCMenu*) resumeItemFromString: (NSString *) savedGame {
	NSString* savedGameFolder = [PathBuilder savedGameDirectory:savedGame];
	
	CCSprite* resumePanel = [CCSprite spriteWithFile:@"resume_panel.png"];
	CCSprite* resumeLeftPanel = [CCSprite spriteWithFile:@"resume_left_panel.png"];
	CCSprite* resumeRightPanel = [CCSprite spriteWithFile:@"resume_right_panel.png"];
	
	CCSprite* calendarIcon = [CCSprite spriteWithFile:@"calendar.png"];
	CCSprite* deleteIcon = [CCSprite spriteWithFile:@"delete_info.png"];
	CCSprite* playIcon = [CCSprite spriteWithFile:@"play_info.png"];
	CCSprite* sizeIcon = [CCSprite spriteWithFile:@"size.png"];
	CCSprite* clockIcon = [CCSprite spriteWithFile:@"clock_info.png"];
	CCSprite* doorOpenIcon = [CCSprite spriteWithFile:@"door_open_info.png"];
	CCSprite* doorIcon = [CCSprite spriteWithFile:@"door_info.png"];
	CCSprite* footIcon = [CCSprite spriteWithFile:@"foot_info.png"];
	
	resumePanel.anchorPoint = ccp(0,0);
	calendarIcon.position = ccp(48, resumePanel.textureRect.size.height/2.0);
	[resumePanel addChild:calendarIcon];
	sizeIcon.position = ccp(169, resumePanel.textureRect.size.height/2.0);
	[resumePanel addChild:sizeIcon];
	clockIcon.position = ccp(222, resumePanel.textureRect.size.height/2.0);
	[resumePanel addChild:clockIcon];
	doorOpenIcon.position = ccp(492, resumePanel.textureRect.size.height/2.0);
	[resumePanel addChild:doorOpenIcon];
	doorIcon.position = ccp(378, resumePanel.textureRect.size.height/2.0);
	[resumePanel addChild:doorIcon];
	footIcon.position = ccp(309, resumePanel.textureRect.size.height/2.0);
	[resumePanel addChild:footIcon];
	
	resumeLeftPanel.anchorPoint = ccp(0,0);
	deleteIcon.position = ccp(resumeLeftPanel.textureRect.size.width/4.0, resumeLeftPanel.textureRect.size.height/2.0);
	[resumeLeftPanel addChild:deleteIcon];
	
	resumeRightPanel.anchorPoint = ccp(0,0);
	playIcon.position = ccp(resumeRightPanel.textureRect.size.width*(3.0/4.0), resumeRightPanel.textureRect.size.height/2.0);
	[resumeRightPanel addChild:playIcon];
	
	NSString* savedGameScreenshotFilePath = [savedGameFolder stringByAppendingPathComponent:SAVE_SCREENSHOT_FILE];
	[[CCTextureCache sharedTextureCache] removeTextureForKey:savedGameScreenshotFilePath];
	CCSprite* screenshot = [CCSprite spriteWithFile: savedGameScreenshotFilePath];
	
	CCMenuItemImage* screenshotMenuItem = [CCMenuItemImage itemFromNormalSprite:screenshot selectedSprite:nil];
	screenshotMenuItem.anchorPoint = ccp(0,0);
	
	CCMenuItemSprite* topPanelItem = [CCMenuItemSprite itemFromNormalSprite: resumePanel selectedSprite:nil];
	topPanelItem.anchorPoint = ccp(0.5, 1);
	topPanelItem.position = ccp(screenshot.textureRect.size.width/2.0,screenshot.textureRect.size.height);
	
	CCMenuItemSprite* leftPanelItem = [CCMenuItemSprite itemFromNormalSprite: resumeLeftPanel selectedSprite:nil target:self selector:@selector(onResumeDelete:)];
	leftPanelItem.userData = savedGame;
	leftPanelItem.anchorPoint = ccp(0,0);
	leftPanelItem.position = ccp(0,0);
	
	CCMenuItemSprite* rightPanelItem = [CCMenuItemSprite itemFromNormalSprite: resumeRightPanel selectedSprite:nil target:self selector:@selector(onResumePlay:)];
	rightPanelItem.userData = savedGame;
	rightPanelItem.anchorPoint = ccp(1,0);
	rightPanelItem.position = ccp(screenshot.textureRect.size.width,0);
	
	NSDictionary* metadata = [[[NSDictionary alloc] initWithContentsOfFile:[savedGameFolder stringByAppendingPathComponent:SAVE_METADATA_FILE]] autorelease];
	
	CGPoint resumePanelLeftMiddlePoint = ccpSub(topPanelItem.position, ccp(resumePanel.textureRect.size.width/2.0,resumePanel.textureRect.size.height/2.0));
	
	NSDate* dateValue = (NSDate*)[metadata objectForKey:@"beginDate"];
	CCMenuItemLabel* dateLabel = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString: [InfoPanel getDateLabelText:dateValue]
																				   fontName: @"Arial"
																				   fontSize: 16]];
	dateLabel.anchorPoint = ccp(0,0.5);
	dateLabel.position = ccpAdd(ccp(calendarIcon.position.x+10,0), resumePanelLeftMiddlePoint);
	dateLabel.color = ccBLACK;
	
	int sizeValue = [((NSNumber*)[metadata objectForKey:@"size"]) intValue];
	CCMenuItemLabel* sizeLabel = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString: [InfoPanel getIntegerLabelText: sizeValue]
																				   fontName: @"Arial"
																				   fontSize: 16]];
	sizeLabel.anchorPoint = ccp(0,0.5);
	sizeLabel.position = ccpAdd(ccp(sizeIcon.position.x+10,0), resumePanelLeftMiddlePoint);
	sizeLabel.color = ccBLACK;
	
	NSTimeInterval timeElapsedValue = [((NSNumber*)[metadata objectForKey:@"timeElapsed"]) doubleValue];
	CCMenuItemLabel* timeElapsedLabel = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString: [InfoPanel getTimeLabelText: timeElapsedValue]
																				   fontName: @"Arial"
																				   fontSize: 16]];
	timeElapsedLabel.anchorPoint = ccp(0,0.5);
	timeElapsedLabel.position = ccpAdd(ccp(clockIcon.position.x+10,0), resumePanelLeftMiddlePoint);
	timeElapsedLabel.color = ccBLACK;
	
	int movesMadeValue = [((NSNumber*)[metadata objectForKey:@"movesMade"]) intValue];
	CCMenuItemLabel* movesMadeLabel = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString: [InfoPanel getIntegerLabelText: movesMadeValue]
																				   fontName: @"Arial"
																				   fontSize: 16]];
	movesMadeLabel.anchorPoint = ccp(0,0.5);
	movesMadeLabel.position = ccpAdd(ccp(footIcon.position.x+10,0), resumePanelLeftMiddlePoint);
	movesMadeLabel.color = ccBLACK;
	
	int numOfVisitedValue = [((NSNumber*)[metadata objectForKey:@"numOfVisited"]) intValue];
	int totalChambersValue = [((NSNumber*)[metadata objectForKey:@"totalChambers"]) intValue];
	
	CCMenuItemLabel* numOfVisitedLabel = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString: [InfoPanel getVisitedLabelText:numOfVisitedValue total:totalChambersValue]
																				   fontName: @"Arial"
																				   fontSize: 16]];
	numOfVisitedLabel.anchorPoint = ccp(0,0.5);
	numOfVisitedLabel.position = ccpAdd(ccp(doorIcon.position.x+10,0), resumePanelLeftMiddlePoint);
	numOfVisitedLabel.color = ccBLACK;
	
	CCMenuItemLabel* totalChambersLabel = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString: [InfoPanel getUnvisitedLabelTex:numOfVisitedValue total:totalChambersValue]
																				   fontName: @"Arial"
																				   fontSize: 16]];
	totalChambersLabel.anchorPoint = ccp(0,0.5);
	totalChambersLabel.position = ccpAdd(ccp(doorOpenIcon.position.x+10,0), resumePanelLeftMiddlePoint);
	totalChambersLabel.color = ccBLACK;
	
	CCMenu* menu = [CCMenu menuWithItems: nil];
	[menu addChild:numOfVisitedLabel z:9];
	[menu addChild:totalChambersLabel z:8];
	[menu addChild:movesMadeLabel z:7];
	[menu addChild:timeElapsedLabel z:6];
	[menu addChild:sizeLabel z:5];
	[menu addChild:dateLabel z:4];
	[menu addChild:leftPanelItem z:3];
	[menu addChild:rightPanelItem z:2];
	[menu addChild:topPanelItem z:1];
	[menu addChild:screenshotMenuItem z:0];
	return menu;
}

- (CGPoint) positionForResumeItemAtIndexOnPage:(int)indexOnPage  {
	double multiplier = (double)RESUME_ITEMS_ON_PAGE/2.0 - 0.5;
	CGPoint pageRootPos = ccpAdd(ccp(0,25 + multiplier * (RESUME_ITEM_HEIGHT + RESUME_ITEMS_MARGIN)),ccp(120,250));
	CGPoint position = ccpSub(pageRootPos,ccp(0,(RESUME_ITEM_HEIGHT+RESUME_ITEMS_MARGIN)*indexOnPage));
	return position;
}

- (CGPoint) hiddenDownPositionForResumeItem {
	return [self positionForResumeItemAtIndexOnPage:-3];
}

- (CGPoint) hiddenUpPositionForResumeItem {
	return [self positionForResumeItemAtIndexOnPage:RESUME_ITEMS_ON_PAGE + 2];
}

- (void) initResumeMenu {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onGameDeleteConfirm:) name:DELETE_GAME_CONFIRMED_EVENT object:nil];
	resumeGameMenuPos = 0;
	hasSavedGames = false;
	savedGames = [[NSMutableArray arrayWithArray: [[[NSFileManager arrayOfFoldersInFolder:[PathBuilder saveDirectory]]
							sortedArrayUsingSelector:@selector(compare:)] reversedArray]] retain];
	for (NSString* savedGame in savedGames) {
		NSFileManager* manager = [NSFileManager defaultManager];
		NSString* saveGameDir = [PathBuilder savedGameDirectory:savedGame];
		if (![manager fileExistsAtPath:[saveGameDir stringByAppendingPathComponent:SAVE_DATA_FILE]] ||
			![manager fileExistsAtPath:[saveGameDir stringByAppendingPathComponent:SAVE_METADATA_FILE]] ||
			![manager fileExistsAtPath:[saveGameDir stringByAppendingPathComponent:SAVE_SCREENSHOT_FILE]]) {
			NSError* error;
			[manager removeItemAtPath: saveGameDir error:&error];
			if (error!=nil) {
				NSLog(@"Corrupted save folder remove error: %@", [error description]);
			}
		}
	}
	[savedGames release];
	savedGames = [[NSMutableArray arrayWithArray: [[[NSFileManager arrayOfFoldersInFolder:[PathBuilder saveDirectory]]
													sortedArrayUsingSelector:@selector(compare:)] reversedArray]] retain];
	resumeItems = [[NSMutableArray arrayWithCapacity:[savedGames count]] retain];
	resumeGameMenu = [CCMenu menuWithItems: nil];
	
	for (int i=0; i<[savedGames count]; i++) {
		NSString* savedGame = [savedGames objectAtIndex: i];
		int indexOnPage = i-resumeGameMenuPos;
		if (indexOnPage<0 || indexOnPage > RESUME_ITEMS_ON_PAGE -1) {
			[resumeItems addObject: savedGame];
		} else {
			CCMenu *resumeMenuItem  = [self resumeItemFromString: savedGame];
			[resumeItems addObject:resumeMenuItem];
			CGPoint pos = [self positionForResumeItemAtIndexOnPage: indexOnPage];
			resumeMenuItem.position = ccpAdd(pos,ccp(menuBeginLocation.x-pos.x-RESUME_ITEM_WIDTH/2.0,0));
			[self addChild:resumeMenuItem z: 1000];
		}
	}
	if ([resumeItems count]>0) {
		hasSavedGames = true;
	}
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
	CCMenuItemSprite* backButton = [self menuItemSpriteFromNormalFrameName:@"back_off_en.png"
														  selectedFameName:@"back_on_en.png"
																  selector:@selector(onBackFromResumeGame:)];
	backButton.scale = 0.5;
	backButton.position = ccp(0,-winSize.height/2.0+120);
	[resumeGameMenu addChild:backButton];
	
	CCMenuItemSprite *nArrow = [Game createArrowWithName:@"iso_arrow_n.png" target:self selector:@selector(onUp:)];
	nArrow.anchorPoint = ccp(1,0);
	[nArrow setPosition: ccp(winSize.width/2.0-20,20)];
	[resumeGameMenu addChild:nArrow];
	
	CCMenuItemSprite *sArrow = [Game createArrowWithName:@"iso_arrow_s.png" target:self selector:@selector(onDown:)];
	sArrow.anchorPoint = ccp(1,1);
	[sArrow setPosition: ccp(winSize.width/2.0-20,20)];
	[resumeGameMenu addChild:sArrow];
	
	resumeGameMenu.position = menuBeginLocation;
	[self addChild: resumeGameMenu];
}

- (void) initMainMenu {
	resumeButton = [self menuItemSpriteFromNormalFrameName:@"resume_off_en.png"
															selectedFameName:@"resume_on_en.png"
																	selector:@selector(onResumeClick:)];
	[resumeButton setIsEnabled: hasSavedGames];
	CCMenuItemSprite *newGameButton = [self menuItemSpriteFromNormalFrameName:@"new_game_off_en.png"
															 selectedFameName:@"new_game_on_en.png"
																	 selector:@selector(onNewGameClick:)];
	CCMenuItemSprite *tutorialButton = [self menuItemSpriteFromNormalFrameName:@"tutorial_off_en.png"
															  selectedFameName:@"tutorial_on_en.png"
																	  selector:@selector(onTutorialClick:)];
	progressButton = [self menuItemSpriteFromNormalFrameName:@"progress_off_en.png"
															  selectedFameName:@"progress_on_en.png"
																	  selector:@selector(onProgressClick:)];
	progressButton.isEnabled = [[HPGameCenter sharedGameCenter] isGameCenterAvailable];
	CCMenuItemSprite *optionsButton = [self menuItemSpriteFromNormalFrameName:@"options_off_en.png"
															 selectedFameName:@"options_on_en.png"
																	 selector:@selector(onOptionsClick:)];
	mainMenu = [CCMenu menuWithItems: resumeButton, newGameButton, tutorialButton, progressButton, optionsButton, nil];
	mainMenu.position = menuBeginLocation;
	[mainMenu setOpacity: 0];
	[mainMenu alignItemsInColumns: 
	 [NSNumber numberWithInt:1],
	 [NSNumber numberWithInt:1],
	 [NSNumber numberWithInt:1],
	 [NSNumber numberWithInt:1],
	 [NSNumber numberWithInt:1],
	 nil];
	[self addChild: mainMenu];
}

- (void) initOptionsMenu {
	CCMenuItemSprite *musicLabel = [self menuItemSpriteFromNormalFrameName:@"music_off_en.png"
														  selectedFameName:@"music_on_en.png"
																  selector:@selector(onMusicToggle:)];
	CCMenuItemSprite *soundLabel = [self menuItemSpriteFromNormalFrameName:@"sound_off_en.png"
														  selectedFameName:@"sound_on_en.png"
															 	  selector:@selector(onSoundToggle:)];
	CCMenuItemToggle *musicToggle = [self menuItemToggle: @selector(onMusicToggle:)];
	HPConfiguration* configuration = [HPConfiguration sharedConfiguration];
	if ([[configuration music] boolValue]) {
		[musicToggle setSelectedIndex:1];
	} else {
		[musicToggle setSelectedIndex:0];
	}
	CCMenuItemToggle *soundToggle = [self menuItemToggle: @selector(onSoundToggle:)];
	if ([[configuration sound] boolValue]) {
		[soundToggle setSelectedIndex:1];
	} else {
		[soundToggle setSelectedIndex:0];
	}
	CCMenuItemSprite* backItem = [self menuItemSpriteFromNormalFrameName:@"back_off_en.png"
														selectedFameName:@"back_on_en.png"
																selector:@selector(onBackFromOptionsClick:)];
	optionsMenu = [CCMenu menuWithItems: musicLabel, musicToggle, soundLabel, soundToggle, backItem, nil];
	optionsMenu.position = menuBeginLocation;
	[optionsMenu setOpacity: 0];
	optionsMenu.visible = YES;
	[optionsMenu alignItemsInColumns: 
	 [NSNumber numberWithInt:2],
	 [NSNumber numberWithInt:2],
	 [NSNumber numberWithInt:1],
	 nil];
	[self addChild: optionsMenu];
}

- (void) initProgressMenu {
	leaderboardsButton = [self menuItemSpriteFromNormalFrameName:@"leaderboards_off_en.png"
																  selectedFameName:@"leaderboards_on_en.png"
																	 selector:@selector(onLeaderboardsClick:)];
	leaderboardsButton.isEnabled = [[HPGameCenter sharedGameCenter] isGameCenterAvailable];
	achievementsButton = [self menuItemSpriteFromNormalFrameName:@"achievements_off_en.png"
																  selectedFameName:@"achievements_on_en.png"
																	  selector:@selector(onAchievementsClick:)];
	achievementsButton.isEnabled = [[HPGameCenter sharedGameCenter] isGameCenterAvailable];
	CCMenuItemSprite* backItem = [self menuItemSpriteFromNormalFrameName:@"back_off_en.png"
														selectedFameName:@"back_on_en.png"
																selector:@selector(onBackFromProgressClick:)];
	progressMenu = [CCMenu menuWithItems:leaderboardsButton, achievementsButton, backItem, nil];
	progressMenu.position = menuBeginLocation;
	[progressMenu setOpacity: 0];
	progressMenu.visible = YES;
	[progressMenu alignItemsInColumns: 
	 [NSNumber numberWithInt:1],
	 [NSNumber numberWithInt:1],
	 [NSNumber numberWithInt:1],
	 nil];
	[self addChild: progressMenu];
}

-(void) initNewGameMenu {
	CCMenuItemSprite *onePlayerButton = [self menuItemSpriteFromNormalFrameName:@"one_player_off_en.png"
															   selectedFameName:@"one_player_on_en.png"
																	   selector:@selector(onOnePlayerClick:)];
	CCMenuItemSprite *twoPlayersButton = [self menuItemSpriteFromNormalFrameName:@"two_players_off_en.png"
																selectedFameName:@"two_players_on_en.png"
																		selector:@selector(onTwoPlayersClick:)];
	CCMenuItemSprite* backButton = [self menuItemSpriteFromNormalFrameName:@"back_off_en.png"
														  selectedFameName:@"back_on_en.png"
																  selector:@selector(onBackFromNewGameClick:)];
	newGameMenu = [CCMenu menuWithItems: onePlayerButton, twoPlayersButton, backButton, nil];
	newGameMenu.position = menuBeginLocation;
	[newGameMenu setOpacity: 0];
	[newGameMenu alignItemsInColumns: 
	 [NSNumber numberWithInt:1],
	 [NSNumber numberWithInt:1],
	 [NSNumber numberWithInt:1],
	 nil];
	[self addChild: newGameMenu];
}

-(void) initGameSettingsMenu {
	CCMenuItemSprite *difficultyButton = [self menuItemSpriteFromNormalFrameName:@"difficulty_off_en.png" selectedFameName:@"difficulty_off_en.png" selector:nil];
	CCMenuItemSprite *increaseSizeButton = [self menuItemSpriteFromNormalFrameName:@"plus_off_en.png"
																  selectedFameName:@"plus_on_en.png"
																		  selector:@selector(onIncreaseSizeClick:)];
	CCMenuItemSprite *decreaseSizeButton = [self menuItemSpriteFromNormalFrameName:@"minus_off_en.png"
																  selectedFameName:@"minus_on_en.png"
																		  selector:@selector(onDecreaseSizeClick:)];
	for(int i=MIN_MAZE_SIZE; i<=MAX_MAZE_SIZE; i++) {
		CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:
							[NSString stringWithFormat:@"%@%@",
							 [NSString stringWithFormat:@"%d",i],
							 @".png"]];
		CCMenuItemImage *spriteItem = [CCMenuItemImage itemFromNormalSprite:sprite selectedSprite:nil];
		if (sizeItem==nil) {
			sizeItem = [CCMenuItemToggle itemWithTarget:nil selector:nil items: spriteItem,nil];
		} else {
			[sizeItem.subItems addObject: spriteItem];
		}
	}
	[sizeItem setSelectedIndex: [[HPConfiguration sharedConfiguration].difficulty integerValue] - MIN_MAZE_SIZE];
	[sizeItem setIsEnabled:NO];
	CCMenuItemSprite* playButton = [self menuItemSpriteFromNormalFrameName:@"play_off_en.png"
														  selectedFameName:@"play_on_en.png"
																  selector:@selector(onPlayClick:)];
	CCMenuItemSprite* backButton = [self menuItemSpriteFromNormalFrameName:@"back_off_en.png"
														  selectedFameName:@"back_on_en.png"
																  selector:@selector(onBackFromGameSettingsClick:)];
	gameSettingsMenu = [CCMenu menuWithItems:difficultyButton, decreaseSizeButton, sizeItem, increaseSizeButton, playButton, backButton, nil];
	gameSettingsMenu.position = menuBeginLocation;
	[gameSettingsMenu setOpacity: 0];
	[gameSettingsMenu alignItemsInColumns: 
	 [NSNumber numberWithInt:1],
	 [NSNumber numberWithInt:3],
	 [NSNumber numberWithInt:1],
	 [NSNumber numberWithInt:1],
	 nil];
	CGPoint increasePosition = [increaseSizeButton position];
	increasePosition.x += -158;
	[increaseSizeButton setPosition: increasePosition];
	CGPoint decreasePosition = [decreaseSizeButton position];
	decreasePosition.x += 158;
	decreasePosition.y -= 18;
	[decreaseSizeButton setPosition: decreasePosition];
	[self addChild: gameSettingsMenu];
}

- (void)initActions {
	fadeInWithEasing = [[CCEaseOut actionWithAction:
						  [CCFadeIn actionWithDuration: MENU_TRANSITION_DURATION]
												rate: MENU_TRANSTITION_EASING_RATE] retain];
	
	moveLeftWithEasing = [[CCEaseOut actionWithAction:
						   [CCMoveBy actionWithDuration: MENU_TRANSITION_DURATION
											   position: ccp(-MENU_MOVE_DISTANCE,0)]
												 rate: MENU_TRANSTITION_EASING_RATE] retain];
	
	moveRightWithEasing = [[CCEaseOut actionWithAction:
						   [CCMoveBy actionWithDuration: MENU_TRANSITION_DURATION
											   position: ccp(MENU_MOVE_DISTANCE,0)]
												 rate: MENU_TRANSTITION_EASING_RATE] retain];
	
	showFromRightAndFadeIn = [[CCSpawn actions:
							   [[fadeInWithEasing copy] autorelease],
							   [[moveLeftWithEasing copy] autorelease],
							   nil] retain];
	
	showFromLeftAndFadeIn = [[CCSpawn actions:
							  [[fadeInWithEasing copy] autorelease],
							  [[moveRightWithEasing copy] autorelease],
							  nil] retain];
	
	fadeOutWithEasing = [[CCEaseIn actionWithAction:
						 [CCFadeOut actionWithDuration: MENU_TRANSITION_DURATION]
											  rate: MENU_TRANSTITION_EASING_RATE] retain];
	
	
	hideToRightAndFadeOut = [[CCSpawn actions:
							  [[fadeOutWithEasing copy] autorelease],
							  [[moveRightWithEasing copy] autorelease],
							  nil] retain];
	
	hideToLeftAndFadeOut = [[CCSpawn actions:
							 [[fadeOutWithEasing copy] autorelease],
							 [[moveLeftWithEasing copy] autorelease],
							 nil] retain];
	
	moveUpWithEasing = [[CCEaseOut actionWithAction:
						 [CCMoveBy actionWithDuration:RESUME_SCROLL_DURATION
											 position:ccp(0,RESUME_ITEM_HEIGHT+RESUME_ITEMS_MARGIN)]
											  rate:RESUME_SCROLL_EASING_RATE] retain];
	moveDownWithEasing = [[CCEaseOut actionWithAction:
						   [CCMoveBy actionWithDuration:RESUME_SCROLL_DURATION
											   position:ccp(0,-RESUME_ITEM_HEIGHT-RESUME_ITEMS_MARGIN)]
												rate:RESUME_SCROLL_EASING_RATE] retain];
	
	pushUp = [[CCEaseOut actionWithAction:
			   [CCMoveBy actionWithDuration:RESUME_SCROLL_DURATION
									position:ccp(0,(RESUME_ITEM_HEIGHT+RESUME_ITEMS_MARGIN)*3)]
									rate:RESUME_SCROLL_DURATION] retain];
	
	pushDown = [[CCEaseOut actionWithAction:
				[CCMoveBy actionWithDuration:RESUME_SCROLL_DURATION
									 position:ccp(0,-(RESUME_ITEM_HEIGHT+RESUME_ITEMS_MARGIN)*3)]
									  rate:RESUME_SCROLL_EASING_RATE] retain];
	
	jumpUp = [[CCSequence actions:
			  [CCMoveBy actionWithDuration:RESUME_SCROLL_DURATION/2.0 position:ccp(0,30)],
			  [CCEaseIn actionWithAction:
			   [CCMoveBy actionWithDuration:RESUME_SCROLL_DURATION/2.0 position:ccp(0,-30)]
									rate:4],
			  nil] retain];
	
	jumpDown = [[CCSequence actions:
				 [CCMoveBy actionWithDuration:RESUME_SCROLL_DURATION/2.0 position:ccp(0,-30)],
				 [CCEaseIn actionWithAction:
				  [CCMoveBy actionWithDuration:RESUME_SCROLL_DURATION/2.0 position:ccp(0,30)]
									   rate:4],
				 nil] retain];
}

- (void)initPoints {
	CGSize size = [[CCDirector sharedDirector] winSize];
	middleScreen = ccp( size.width /2 , size.height/2 );
	titleLocation = ccp(middleScreen.x , 678);
	menuBeginLocation = ccp(size.width / 2.0 + MENU_MOVE_DISTANCE , (size.height / 2.0) - 75);
}

- (void)loadFrameCache {
	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"menu_spritesheet.plist" 
															 textureFile:@"menu_spritesheet.png"];
	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"progress_menu.plist"
															  textureFile:@"progress_menu.png"];
	

}
- (void)initBackgroundAndTitle {
	background = [[[CCSprite alloc] initWithFile: @"background.png"] autorelease];
	background.position = middleScreen;
	background.scale = 2.0;
	[self addChild: background];
	
	title = [[[CCSprite alloc] initWithSpriteFrameName: @"title.png"] autorelease];
	title.position = middleScreen;
	[self addChild: title];

}

- (void)startBeginAnimation {
	isInTrasition = YES;
		
	[title runAction:
	 [CCEaseOut actionWithAction:
	  [CCMoveTo actionWithDuration: MENU_TRANSITION_DURATION
						  position: titleLocation]
							rate: 4]];
	
	[mainMenu runAction:
	 [CCSequence actions:
	  [CCDelayTime actionWithDuration: MENU_TRANSITION_DURATION],
	  [[showFromRightAndFadeIn copy] autorelease],
	  [CCCallBlock actionWithBlock:^{
		 isInTrasition = NO;
	  }],
	  nil]];
}

- (void) onLocalPlayerAuthorised: (NSNotification*) notification {
	self.isProgressMenuEnable = YES;
}

- (void) onLocalPlayerNotAuthorised: (NSNotification*) notification {
	self.isProgressMenuEnable = NO;
}

-(id) init
{
	if((self=[super init])) {
		[[NSNotificationCenter defaultCenter] addObserver: self
												 selector: @selector(onLocalPlayerAuthorised:)
													 name: EVENT_LOCAL_PLAYER_AUTHORISED
												   object: [HPGameCenter sharedGameCenter]];
		[[NSNotificationCenter defaultCenter] addObserver: self
												 selector: @selector(onLocalPlayerNotAuthorised:)
													 name:EVENT_LOCAL_PLAYER_NOT_AUTHORISED
												   object: [HPGameCenter sharedGameCenter]];
		[[HPSound sharedSound] preloadSounds];
		[[HPSound sharedSound] playMainMenuPlaylist];
		[self initActions];	
		[self initPoints];
		[self loadFrameCache];
		[self initBackgroundAndTitle];
		[self initResumeMenu];
		[self initMainMenu];
		[self initOptionsMenu];
		[self initNewGameMenu];
		[self initGameSettingsMenu];
		[self initProgressMenu];
		[self startBeginAnimation];
	}
	return self;
}

void UpdateDifficultyConfig(CCMenuItemToggle *sizeItem) {
  HPConfiguration* configuration = [HPConfiguration sharedConfiguration];
	configuration.difficulty = [NSNumber numberWithInteger: [sizeItem selectedIndex] + MIN_MAZE_SIZE];
	[configuration save];

}
- (void) onIncreaseSizeClick: (CCMenuItem  *) menuItem 
{
	[[HPSound sharedSound] playSound: SOUND_TICK];
	int currentSizeIndex = [sizeItem selectedIndex];
	if (currentSizeIndex < MAX_MAZE_SIZE - MIN_MAZE_SIZE) {
		[sizeItem setSelectedIndex: currentSizeIndex + 1];
	}
	UpdateDifficultyConfig(sizeItem);
}

- (void) onDecreaseSizeClick: (CCMenuItem  *) menuItem 
{
	[[HPSound sharedSound] playSound: SOUND_TICK];
	int currentSizeIndex = [sizeItem selectedIndex];
	if (currentSizeIndex > MIN_MAZE_SIZE - MIN_MAZE_SIZE) {
		[sizeItem setSelectedIndex: currentSizeIndex - 1];
	}
	UpdateDifficultyConfig(sizeItem);
}

- (void) onPlayClick: (CCMenuItem  *) menuItem 
{
	[[CCDirector sharedDirector] purgeCachedData];
	[[CCDirector sharedDirector] replaceScene: [CCTransitionCrossFade transitionWithDuration:0.5 scene:[LoadingLayer scene]]];
}

- (void) onLeaderboardsClick: (CCMenuItem*) menuItem {
	[[HPGameCenter sharedGameCenter] showLeaderboard];
}

- (void) onAchievementsClick: (CCMenuItem*) menuItem {
	[[HPGameCenter sharedGameCenter] showAchievements];
}

- (void) onBackFromGameSettingsClick: (CCMenuItem  *) menuItem 
{
	[self goBackTo: mainMenu from: gameSettingsMenu];
}

- (void) onOnePlayerClick: (CCMenuItem  *) menuItem 
{
}

- (void) onTwoPlayersClick: (CCMenuItem  *) menuItem 
{
}

- (void) onBackFromNewGameClick: (CCMenuItem  *) menuItem 
{
	[self goBackTo: mainMenu from: newGameMenu];
}

- (void) onBackFromProgressClick: (CCMenuItem*) menuItem {
	[self goBackTo: mainMenu from: progressMenu];
	isInProgressMenu = NO;
}



- (void) onResumeClick: (CCMenuItem  *) menuItem 
{
	[self goTo: resumeGameMenu from: mainMenu];
	for (int i=resumeGameMenuPos; i <= MIN(resumeGameMenuPos + RESUME_ITEMS_ON_PAGE - 1, [resumeItems count]-1); i++) {
		CCMenu* currentItem = [resumeItems objectAtIndex:i];
		[currentItem runAction:[[showFromRightAndFadeIn copy] autorelease]];
	}
}

- (void) onUp: (CCMenuItem *) menuItem
{
	if (!isInTrasition) {
		[[HPSound sharedSound] playSound: SOUND_MENU_SILDE];
		if (resumeGameMenuPos > 0) {
			for (int i=MAX(resumeGameMenuPos-1,0); i<= MIN(resumeGameMenuPos + RESUME_ITEMS_ON_PAGE - 1, [resumeItems count]-1); i++) {
				if (i==resumeGameMenuPos-1) {
					CCMenu* currentItem = [self resumeItemFromString: [resumeItems objectAtIndex:i]];
					currentItem.position = [self hiddenDownPositionForResumeItem];
					[self addChild:currentItem];
					[resumeItems replaceObjectAtIndex:i withObject:currentItem];
					[currentItem runAction:[[pushDown copy] autorelease]];
				} else if (i==resumeGameMenuPos + RESUME_ITEMS_ON_PAGE - 1) {
					CCMenuItem* currentItem = [resumeItems objectAtIndex:i];
					[currentItem runAction:
					 [CCSequence actions:
					  [[pushDown copy] autorelease],
					  [CCCallBlock actionWithBlock:^(){
						 [currentItem removeFromParentAndCleanup:YES];
						 [resumeItems replaceObjectAtIndex:i withObject:[savedGames objectAtIndex:i]];
					  }],
					  nil]];
				} else {
					isInTrasition = YES;
					CCMenu* currentItem = [resumeItems objectAtIndex:i];
					[currentItem runAction:
					 [CCSequence actions:
					  [[moveDownWithEasing copy] autorelease],
					  [CCCallBlock actionWithBlock:^(){
						isInTrasition = NO;
					  }],
					  nil]];
				}
			}
			resumeGameMenuPos = MAX(--resumeGameMenuPos,0);
		} else {
			for (int i=resumeGameMenuPos; i <= MIN(resumeGameMenuPos + RESUME_ITEMS_ON_PAGE - 1, [resumeItems count]-1); i++) {
				isInTrasition = true;
				CCMenu* currentItem = [resumeItems objectAtIndex:i];
				[currentItem runAction:
				 [CCSequence actions:
				  [[jumpDown copy] autorelease],
				  [CCCallBlock actionWithBlock:^(){
					 isInTrasition = NO;
				 }],
				  nil]];
			}
		}
		[[CCTextureCache sharedTextureCache] removeUnusedTextures];
	}
}

- (void) onDown: (CCMenuItem *) menuItem
{
	if (!isInTrasition) {
		[[HPSound sharedSound] playSound: SOUND_MENU_SILDE];
		int x = ([resumeItems count]-RESUME_ITEMS_ON_PAGE);
		if (resumeGameMenuPos < x) {
			for (int i=resumeGameMenuPos; i<= MIN(resumeGameMenuPos + RESUME_ITEMS_ON_PAGE, [resumeItems count]-1); i++) {
				if (i==resumeGameMenuPos) {
					CCMenu* currentItem = [resumeItems objectAtIndex:i];
					[currentItem runAction:
					 [CCSequence actions:
					  [[pushUp copy] autorelease],
					  [CCCallBlock actionWithBlock:^(){
						 [currentItem removeFromParentAndCleanup:YES];
						 [resumeItems replaceObjectAtIndex:i withObject:[savedGames objectAtIndex:i]];
					  }],
					  nil]];
				} else if (i==resumeGameMenuPos + RESUME_ITEMS_ON_PAGE) {
					CCMenu* currentItem = [self resumeItemFromString: [resumeItems objectAtIndex:i]];
					currentItem.position = [self hiddenUpPositionForResumeItem];
					[self addChild:currentItem];
					[resumeItems replaceObjectAtIndex:i withObject:currentItem];
					[currentItem runAction:[[pushUp copy] autorelease]];
				} else {
					isInTrasition = YES;
					CCMenu* currentItem = [resumeItems objectAtIndex:i];
					[currentItem runAction:
					 [CCSequence actions:
					  [[moveUpWithEasing copy] autorelease],
					  [CCCallBlock actionWithBlock:^(){
						 isInTrasition = NO;
					  }],
					  nil]];
				}
			}
			resumeGameMenuPos = MIN(++resumeGameMenuPos,MAX([resumeItems count]-RESUME_ITEMS_ON_PAGE,0));
		} else {
			for (int i=resumeGameMenuPos; i <= MIN(resumeGameMenuPos + RESUME_ITEMS_ON_PAGE - 1, [resumeItems count]-1); i++) {
				isInTrasition = true;
				CCMenuItem* currentItem = [resumeItems objectAtIndex:i];
				[currentItem runAction:
				 [CCSequence actions:
				  [[jumpUp copy] autorelease],
				  [CCCallBlock actionWithBlock:^(){
					 isInTrasition = NO;
				  }],
				  nil]];
			}
		}
		[[CCTextureCache sharedTextureCache] removeUnusedTextures];
	}
}

- (void) onResumeDelete: (CCMenuItem*) item {
	[[HPSound sharedSound] playSound: SOUND_TICK];
	CCDialog* dialog = [[[DeleteConfirmDialog alloc] initWithSavedGame: [PathBuilder savedGameDirectory:item.userData]] autorelease];
	[dialog openInScene: (CCScene*)[self parent]];
}

- (void) onResumePlay: (CCMenuItem*) item {
	NSString* filePath = [[PathBuilder savedGameDirectory:item.userData] stringByAppendingPathComponent:SAVE_DATA_FILE];
	HPLogic* logic = [NSKeyedUnarchiver unarchiveObjectWithFile: filePath];
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionCrossFade transitionWithDuration: 0.5
											  scene: [Game sceneWithLogic:logic]]];
}

- (void) onBackFromResumeGame: (CCMenuItem  *) menuItem {
	[self goBackTo:mainMenu from:resumeGameMenu];
	if ([resumeItems count] > 0) {
		for (int i=resumeGameMenuPos; i <= MIN(resumeGameMenuPos + RESUME_ITEMS_ON_PAGE - 1, [resumeItems count]-1); i++) {
			CCMenu* currentItem = [resumeItems objectAtIndex:i];
			[currentItem runAction:[[hideToRightAndFadeOut copy] autorelease]];
		}
	}
}

- (void) onGameDeleteConfirm: (NSNotification*) notification {
	[[HPSound sharedSound] playSound: SOUND_TICK];
	NSString* savedGame = [notification.userInfo objectForKey: @"savedGame"];
	int deletedIndex = INT_MAX;
	for (int i=resumeGameMenuPos; i<= MIN(resumeGameMenuPos + RESUME_ITEMS_ON_PAGE, [resumeItems count]-1); i++) {
		NSRange range = [savedGame rangeOfString:[savedGames objectAtIndex:i]];
		if (range.location!=NSNotFound) {
			deletedIndex = i;
			NSError* error;
			if (![[NSFileManager defaultManager] removeItemAtPath:savedGame error: &error]) {
				NSLog(@"%@", [error description]);
			}
			CCMenu* currentItem = [resumeItems objectAtIndex:i];
			[currentItem runAction:
			 [CCSequence actions:
			  [CCFadeOut actionWithDuration:RESUME_SCROLL_DURATION],
			  [CCCallBlock actionWithBlock:
			   ^(){
				   [self removeChild:currentItem cleanup:NO];
			   }],
			  nil]];
		} else if (i==resumeGameMenuPos + RESUME_ITEMS_ON_PAGE) {
			CCMenu* currentItem = [self resumeItemFromString: [resumeItems objectAtIndex:i]];
			currentItem.position = [self hiddenUpPositionForResumeItem];
			[self addChild:currentItem];
			[resumeItems replaceObjectAtIndex:i withObject:currentItem];
			[currentItem runAction:[[pushUp copy] autorelease]];
		} else if (i>deletedIndex) {
			CCMenu* currentItem = [resumeItems objectAtIndex:i];
			isInTrasition = true;
			[currentItem runAction:
			 [CCSequence actions:
			  [[moveUpWithEasing copy] autorelease],
			  [CCCallBlock actionWithBlock:^(){
				 isInTrasition = NO;
			  }],
			  nil]];
		}
	}
	[resumeItems removeObjectAtIndex:deletedIndex];
	[savedGames removeObjectAtIndex:deletedIndex];
	if ([resumeItems count] == 0) {
		[self onBackFromResumeGame: nil];
	}
	[[CCTextureCache sharedTextureCache] removeUnusedTextures];
}

- (void) onNewGameClick: (CCMenuItem  *) menuItem 
{
	[self goTo: gameSettingsMenu from: mainMenu];
}


- (void) onProgressClick: (CCMenuItem*) menuItem {
	[self goTo: progressMenu from:mainMenu];
	isInProgressMenu = YES;
}

- (void) onTutorialClick: (CCMenuItem  *) menuItem 
{
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionCrossFade transitionWithDuration: 0.5
											  scene: [Game sceneWithTutorial]]];
}

- (void) onOptionsClick: (CCMenuItem  *) menuItem 
{
	if(!isInTrasition) {
		isInTrasition = YES;
		[[HPSound sharedSound] playSound: SOUND_MENU_SILDE];
		[mainMenu runAction:
		 [CCSequence actions:
		  [[hideToLeftAndFadeOut copy] autorelease],
		  [CCCallBlock actionWithBlock:^{
			 mainMenu.visible = NO;
		  }],
		  nil]];
		[optionsMenu runAction:
		 [CCSequence actions:
		  [CCCallBlock actionWithBlock:^{
			 optionsMenu.visible = YES;
		  }],
		  [[showFromRightAndFadeIn copy] autorelease],
		  [CCCallBlock actionWithBlock:^{
			 isInTrasition = NO;
		  }],
		  nil]];
	}
}

- (void) onMusicToggle: (CCMenuItemToggle *) menuItem
{
	[[HPSound sharedSound] playSound: SOUND_TOGGLE];
	HPConfiguration* configuration = [HPConfiguration sharedConfiguration];
	configuration.music = [NSNumber numberWithInteger: [menuItem selectedIndex]];
	[configuration save];
	if ([[configuration music] boolValue]) {
		[[HPSound sharedSound] stopMusic];
	} else {
		[[HPSound sharedSound] playMusic];
	}
}

- (void) onSoundToggle: (CCMenuItemToggle *) menuItem
{
	[[HPSound sharedSound] playSound: SOUND_TOGGLE];
	HPConfiguration* configuration = [HPConfiguration sharedConfiguration];
	configuration.sound = [NSNumber numberWithInteger: [menuItem selectedIndex]];
	[configuration save];
}

- (void) onFacebookClick: (CCMenuItem *) menuItem
{
}

- (void) onTwitterClick: (CCMenuItem *) menuItem
{
}

- (void) onBackFromOptionsClick: (CCMenuItem *) menuItem
{
	if (!isInTrasition) {
		[[HPSound sharedSound] playSound: SOUND_MENU_SILDE];
		[mainMenu runAction:
		 [CCSequence actions:
		  [CCCallBlock actionWithBlock:^{
			 mainMenu.visible = YES;
		  }],
		  [[showFromLeftAndFadeIn copy] autorelease],
		  [CCCallBlock actionWithBlock:^{
			 isInTrasition = NO;
		  }],
		  nil]];
		
		[optionsMenu runAction:
		 [CCSequence actions:
		  [[hideToRightAndFadeOut copy] autorelease],
		  [CCCallBlock actionWithBlock:^{
			 optionsMenu.visible = NO;
		  }],
		  nil]];
	}
}

- (void) setIsProgressMenuEnable: (BOOL) isEnable {
	if (isEnable) {
		if (!isProgressMenuEnable) {
			isProgressMenuEnable = isEnable;
			progressButton.isEnabled = YES;
			leaderboardsButton.isEnabled = YES;
			achievementsButton.isEnabled = YES;
		}
	} else {
		if (isProgressMenuEnable) {
			isProgressMenuEnable = isEnable;
			progressButton.isEnabled = NO;
			leaderboardsButton.isEnabled = NO;
			achievementsButton.isEnabled = NO;
		}
		if (isInProgressMenu) {
			[self onBackFromProgressClick:nil];
		}
	}
}

- (BOOL) isProgressMenuEnable {
	return isProgressMenuEnable;
}

- (void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver: self];
	[showFromRightAndFadeIn release];
	[hideToRightAndFadeOut release];
	[showFromLeftAndFadeIn release];
	[hideToLeftAndFadeOut release];
	[moveLeftWithEasing release];
	[moveRightWithEasing release];
	[fadeInWithEasing release];
	[fadeOutWithEasing release];
	
	[resumeItems release];
	
	[moveUpWithEasing release];
	[moveDownWithEasing release];
	[pushUp release];
	[pushDown release];
	[jumpUp release];
	[jumpDown release];
	
	[savedGames release];
	
	[super dealloc];
	
	[[CCDirector sharedDirector] purgeCachedData];
}

@end
