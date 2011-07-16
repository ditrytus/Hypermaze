//
//  MainMenuScene.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 11-07-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainMenuLayer.h"
#import "cocos2d.h"


@implementation MainMenuLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	MainMenuLayer *layer = [MainMenuLayer node];
	[scene addChild: layer];
	return scene;
}

-(id) init
{
	if( (self=[super init])) {
		CGSize size = [[CCDirector sharedDirector] winSize];
		CGPoint middle = ccp( size.width /2 , size.height/2 );
		background = [[CCSprite alloc] initWithFile:@"background.png"];
		background.position = middle;
		background.scale = 2.0;
		[self addChild: background];
		
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"menu_spritesheet.plist"
																 textureFile:@"menu_spritesheet.png"];
		
	    title = [[CCSprite alloc] initWithSpriteFrameName:@"title.png"];
		title.position = middle;
		[self addChild: title];
	
		CCSprite *resumeOnSprite = [[CCSprite alloc] initWithSpriteFrameName:@"resume_on_en.png"];
		CCSprite *resumeOffSprite = [[CCSprite alloc] initWithSpriteFrameName:@"resume_off_en.png"];
		CCSprite *resumeDisabledSprite = [[CCSprite alloc] initWithSpriteFrameName:@"resume_off_en.png"];
		[resumeDisabledSprite setColor: ccGRAY];
		CCMenuItemSprite *resumeButton = [[CCMenuItemSprite alloc] initFromNormalSprite:resumeOffSprite
																		 selectedSprite:resumeOnSprite
																		 disabledSprite:resumeDisabledSprite
																				 target:self
																			   selector:@selector(onResumeClick:)];
		[resumeButton setIsEnabled: NO];
		
		CCSprite *newGameOnSprite = [[CCSprite alloc] initWithSpriteFrameName:@"new_game_on_en.png"];
		CCSprite *newGameOffSprite = [[CCSprite alloc] initWithSpriteFrameName:@"new_game_off_en.png"];
		CCMenuItemSprite *newGameButton = [[CCMenuItemSprite alloc] initFromNormalSprite:newGameOffSprite
																		  selectedSprite:newGameOnSprite
																		  disabledSprite:nil
																				  target:self
																			    selector:@selector(onNewGameClick:)];
		
		CCSprite *tutorialOnSprite = [[CCSprite alloc] initWithSpriteFrameName:@"tutorial_on_en.png"];
		CCSprite *tutorialOffSprite = [[CCSprite alloc] initWithSpriteFrameName:@"tutorial_off_en.png"];
		CCMenuItemSprite *tutorialButton = [[CCMenuItemSprite alloc] initFromNormalSprite:tutorialOffSprite
																		  selectedSprite:tutorialOnSprite
																		  disabledSprite:nil
																				  target:self
																				selector:@selector(onTutorialClick:)];
		
		CCSprite *optionsOnSprite = [[CCSprite alloc] initWithSpriteFrameName:@"options_on_en.png"];
		CCSprite *optionsOffSprite = [[CCSprite alloc] initWithSpriteFrameName:@"options_off_en.png"];
		CCMenuItemSprite *optionsButton = [[CCMenuItemSprite alloc] initFromNormalSprite:optionsOffSprite
																		  selectedSprite:optionsOnSprite
																		  disabledSprite:nil
																				  target:self
																			    selector:@selector(onOptionsClick:)];
		
		mainMenu = [CCMenu menuWithItems: resumeButton, newGameButton, tutorialButton, optionsButton, nil];
		mainMenu.position = ccp(size.width / 2.0 + 100 , (size.height / 2.0) - 75);
		[mainMenu setOpacity: 0];
		[mainMenu alignItemsInColumns: 
			[NSNumber numberWithInt:1],
			[NSNumber numberWithInt:1],
			[NSNumber numberWithInt:1],
			[NSNumber numberWithInt:1],
			nil];
		[self addChild: mainMenu];
		
		[title runAction:
			[CCSequence actions:
				[CCEaseOut actionWithAction:
					[CCMoveTo actionWithDuration: 0.5
										position: ccp(middle.x , 648)]
										rate: 4],
				[CCCallBlock actionWithBlock:(^{
					[mainMenu runAction:
						[CCEaseOut actionWithAction:
							[CCFadeIn actionWithDuration: 0.5]
											   rate: 4]];
					[mainMenu runAction:
						[CCEaseOut actionWithAction:
							[CCMoveBy actionWithDuration: 0.5
												position: ccp(-100,0)]
											   rate: 4]];
					})],
				nil]];
	}
	return self;
}

- (void) onResumeClick: (CCMenuItem  *) menuItem 
{
}

- (void) onNewGameClick: (CCMenuItem  *) menuItem 
{
}

- (void) onTutorialClick: (CCMenuItem  *) menuItem 
{
}

- (void) onOptionsClick: (CCMenuItem  *) menuItem 
{
}

- (void) dealloc
{
	[super dealloc];
}

@end
