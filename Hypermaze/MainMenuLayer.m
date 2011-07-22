//
//  MainMenuScene.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 11-07-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainMenuLayer.h"
#import "cocos2d.h"

const int MENU_MOVE_DISTANCE = 1000;
const float MENU_TRANSITION_DURATION = 0.5;
const int MENU_TRANSTITION_EASING_RATE = 4;
const int MAX_MAZE_SIZE = 20;
const int MIN_MAZE_SIZE = 3;

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
		[destinationMenu runAction:
		 [CCSequence actions:
		  [CCCallBlock actionWithBlock:^{
			 mainMenu.visible = YES;
		 }],
		  [[showFromLeftAndFadeIn copy] autorelease],
		  [CCCallBlock actionWithBlock:^{
			 isInTrasition = NO;
		 }],
		  nil]];
		[currentMenu runAction:
		 [CCSequence actions:
		  [[hideToRightAndFadeOut copy] autorelease],
		  [CCCallBlock actionWithBlock:^{
			 optionsMenu.visible = NO;
		 }],
		  nil]];
	}
}

- (void)goTo: (CCMenu*)destinationMenu from: (CCMenu*)currentMenu {
	if(!isInTrasition) {
		isInTrasition = YES;
		[currentMenu runAction:
		 [CCSequence actions:
		  [[hideToLeftAndFadeOut copy] autorelease],
		  [CCCallBlock actionWithBlock:^{
			 mainMenu.visible = NO;
		 }],
		  nil]];
		
		[destinationMenu runAction:
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

- (void) initMainMenu {
	CCMenuItemSprite *resumeButton = [self menuItemSpriteFromNormalFrameName:@"resume_off_en.png"
															selectedFameName:@"resume_on_en.png"
																	selector:@selector(onResumeClick:)];
	[resumeButton setIsEnabled: NO];
	CCMenuItemSprite *newGameButton = [self menuItemSpriteFromNormalFrameName:@"new_game_off_en.png"
															 selectedFameName:@"new_game_on_en.png"
																	 selector:@selector(onNewGameClick:)];
	CCMenuItemSprite *tutorialButton = [self menuItemSpriteFromNormalFrameName:@"tutorial_off_en.png"
															  selectedFameName:@"tutorial_on_en.png"
																	  selector:@selector(onTutorialClick:)];
	CCMenuItemSprite *optionsButton = [self menuItemSpriteFromNormalFrameName:@"options_off_en.png"
															 selectedFameName:@"options_on_en.png"
																	 selector:@selector(onOptionsClick:)];
	mainMenu = [[CCMenu menuWithItems: resumeButton, newGameButton, tutorialButton, optionsButton, nil] retain];
	mainMenu.position = menuBeginLocation;
	[mainMenu setOpacity: 0];
	[mainMenu alignItemsInColumns: 
	 [NSNumber numberWithInt:1],
	 [NSNumber numberWithInt:1],
	 [NSNumber numberWithInt:1],
	 [NSNumber numberWithInt:1],
	 nil];
}

- (void) initOptionsMenu {
	CCMenuItemSprite *musicLabel = [self menuItemSpriteFromNormalFrameName:@"music_off_en.png"
														  selectedFameName:@"music_on_en.png"
																  selector:@selector(onMusicToggle:)];
	CCMenuItemSprite *soundLabel = [self menuItemSpriteFromNormalFrameName:@"sound_off_en.png"
														  selectedFameName:@"sound_on_en.png"
															 	  selector:@selector(onSoundToggle:)];
	CCMenuItemToggle *musicToggle = [self menuItemToggle: @selector(onMusicToggle:)];
	CCMenuItemToggle *soundToggle = [self menuItemToggle: @selector(onSoundToggle:)];
	CCMenuItemSprite* facebookItem = [self menuItemSpriteFromNormalFrameName:@"facebook_off_en.png"
															selectedFameName:@"facebook_on_en.png"
																	selector:@selector(onFacebookClick:)];
	CCMenuItemSprite* twitterItem = [self menuItemSpriteFromNormalFrameName:@"twitter_off_en.png"
														   selectedFameName:@"twitter_on_en.png"
																   selector:@selector(onTwitterClick:)];
	CCMenuItemSprite* backItem = [self menuItemSpriteFromNormalFrameName:@"back_off_en.png"
														selectedFameName:@"back_on_en.png"
																selector:@selector(onBackFromOptionsClick:)];
	optionsMenu = [[CCMenu menuWithItems: musicLabel, musicToggle, soundLabel, soundToggle, facebookItem, twitterItem, backItem, nil] retain];
	optionsMenu.position = menuBeginLocation;
	[optionsMenu setOpacity: 0];
	optionsMenu.visible = YES;
	[optionsMenu alignItemsInColumns: 
	 [NSNumber numberWithInt:2],
	 [NSNumber numberWithInt:2],
	 [NSNumber numberWithInt:2],
	 [NSNumber numberWithInt:1],
	 nil];
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
	newGameMenu = [[CCMenu menuWithItems: onePlayerButton, twoPlayersButton, backButton, nil] retain];
	newGameMenu.position = menuBeginLocation;
	[newGameMenu setOpacity: 0];
	[newGameMenu alignItemsInColumns: 
	 [NSNumber numberWithInt:1],
	 [NSNumber numberWithInt:1],
	 [NSNumber numberWithInt:1],
	 nil];
}

-(void) initGameSettingsMenu {
	CCMenuItemSprite *difficultyButton = [self menuItemSpriteFromNormalFrameName:@"difficulty_off_en.png" selectedFameName:@"difficulty_off_en.png" selector:nil];
	CCMenuItemSprite *increaseSizeButton = [self menuItemSpriteFromNormalFrameName:@"plus_off_en.png"
																  selectedFameName:@"plus_on_en.png"
																		  selector:@selector(onIncreaseSizeClick:)];
	CCMenuItemSprite *decreaseSizeButton = [self menuItemSpriteFromNormalFrameName:@"minus_off_en.png"
																  selectedFameName:@"minus_on_en.png"
																		  selector:@selector(onDecreaseSizeClick:)];
	sizeItem = [[CCMenuItemToggle itemWithTarget:nil selector:nil] retain];
	NSMutableArray *numbers = [NSMutableArray array];
	for(int i=MIN_MAZE_SIZE; i<=MAX_MAZE_SIZE; i++) {
		CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:
							[NSString stringWithFormat:@"%@%@",
							 [NSString stringWithFormat:@"%d",i],
							 @".png"]];
		CCMenuItemImage *spriteItem = [CCMenuItemImage itemFromNormalSprite:sprite selectedSprite:nil];
		[numbers addObject: spriteItem];
	}
	[sizeItem setSubItems: numbers];
	[sizeItem setSelectedIndex:1];
	[sizeItem setIsEnabled:NO];
	CCMenuItemSprite* playButton = [self menuItemSpriteFromNormalFrameName:@"play_off_en.png"
														  selectedFameName:@"play_on_en.png"
																  selector:@selector(onPlayClick:)];
	CCMenuItemSprite* backButton = [self menuItemSpriteFromNormalFrameName:@"back_off_en.png"
														  selectedFameName:@"back_on_en.png"
																  selector:@selector(onBackFromGameSettingsClick:)];
	gameSettingsMenu = [[CCMenu menuWithItems:difficultyButton, decreaseSizeButton, sizeItem, increaseSizeButton, playButton, backButton, nil] retain];
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
}

- (void)initActions {
	fadeInWithEasing = [[CCEaseOut actionWithAction:
						  [CCFadeIn actionWithDuration: MENU_TRANSITION_DURATION]
												rate: MENU_TRANSTITION_EASING_RATE] retain];
	
	moveLeftWithEasing = [[CCEaseOut actionWithAction:
						   [CCMoveBy actionWithDuration: MENU_TRANSITION_DURATION
											   position: ccp(-MENU_MOVE_DISTANCE,0)]
												 rate: MENU_TRANSTITION_EASING_RATE] retain];
	
	moveRightWithEasing = [CCEaseOut actionWithAction:
						   [CCMoveBy actionWithDuration: MENU_TRANSITION_DURATION
											   position: ccp(MENU_MOVE_DISTANCE,0)]
												 rate: MENU_TRANSTITION_EASING_RATE];
	
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

}

- (void)initPoints {
	CGSize size = [[CCDirector sharedDirector] winSize];
	middleScreen = ccp( size.width /2 , size.height/2 );
	titleLocation = ccp(middleScreen.x , 648);
	menuBeginLocation = ccp(size.width / 2.0 + MENU_MOVE_DISTANCE , (size.height / 2.0) - 75);
}

- (void)loadFrameCache {
  [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"menu_spritesheet.plist"
																 textureFile:@"menu_spritesheet.png"];

}
- (void)initBackgroundAndTitle {
	background = [[CCSprite alloc] initWithFile:@"background.png"];
	background.position = middleScreen;
	background.scale = 2.0;
	
	title = [[CCSprite alloc] initWithSpriteFrameName:@"title.png"];
	title.position = middleScreen;

}
- (void)addElemntsToLayer {
	[self addChild: background];
	[self addChild: title];
	[self addChild: mainMenu];
	[self addChild: optionsMenu];
	[self addChild: newGameMenu];
	[self addChild: gameSettingsMenu];

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

-(id) init
{
	if((self=[super init])) {
		[self initActions];	
		[self initPoints];
		[self loadFrameCache];
		[self initBackgroundAndTitle];
		[self initMainMenu];
		[self initOptionsMenu];
		[self initNewGameMenu];
		[self initGameSettingsMenu];
		[self addElemntsToLayer];
		[self startBeginAnimation];
	}
	return self;
}

- (void) onIncreaseSizeClick: (CCMenuItem  *) menuItem 
{
	int currentSizeIndex = [sizeItem selectedIndex];
	if (currentSizeIndex < MAX_MAZE_SIZE - MIN_MAZE_SIZE) {
		[sizeItem setSelectedIndex: currentSizeIndex + 1];
	}
}

- (void) onDecreaseSizeClick: (CCMenuItem  *) menuItem 
{
	int currentSizeIndex = [sizeItem selectedIndex];
	if (currentSizeIndex > MIN_MAZE_SIZE - MIN_MAZE_SIZE) {
		[sizeItem setSelectedIndex: currentSizeIndex - 1];
	}
}

- (void) onPlayClick: (CCMenuItem  *) menuItem 
{
}

- (void) onBackFromGameSettingsClick: (CCMenuItem  *) menuItem 
{
	[self goBackTo: newGameMenu from: gameSettingsMenu];
}

- (void) onOnePlayerClick: (CCMenuItem  *) menuItem 
{
	[self goTo: gameSettingsMenu from: newGameMenu];
}

- (void) onTwoPlayersClick: (CCMenuItem  *) menuItem 
{
}

- (void) onBackFromNewGameClick: (CCMenuItem  *) menuItem 
{
	[self goBackTo: mainMenu from: newGameMenu];
}

- (void) onResumeClick: (CCMenuItem  *) menuItem 
{
}

- (void) onNewGameClick: (CCMenuItem  *) menuItem 
{
	[self goTo: newGameMenu from: mainMenu];

}

- (void) onTutorialClick: (CCMenuItem  *) menuItem 
{
}

- (void) onOptionsClick: (CCMenuItem  *) menuItem 
{
	if(!isInTrasition) {
		isInTrasition = YES;
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

- (void) onMusicToggle: (CCMenuItem *) menuItem
{
}

- (void) onSoundToggle: (CCMenuItem *) menuItem
{
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

- (void) dealloc
{
	[showFromRightAndFadeIn release];
	[hideToRightAndFadeOut release];
	[showFromLeftAndFadeIn release];
	[hideToLeftAndFadeOut release];
	[moveLeftWithEasing release];
	[moveRightWithEasing release];
	[fadeInWithEasing release];
	[fadeOutWithEasing release];
    [mainMenu release];
    [optionsMenu release];
	[newGameMenu release];
	[super dealloc];
}

@end
