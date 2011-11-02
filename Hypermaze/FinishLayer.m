//
//  FinishLayer.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 10.10.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FinishLayer.h"

@implementation FinishLayer

- (id) initWithLogic: (HPLogic*) newLogic
{
    self = [super init];
    if (self) {
		score = [newLogic getScore];
		currentScoreCounter = 0;
		
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		
		CCSprite* congratulationsCloud = [CCSprite spriteWithFile:@"congratulation_cloud.png"];
		congratulationsCloud.opacity = 0;
		congratulationsCloud.anchorPoint = ccp(0.5,0.5);
		congratulationsCloud.position = ccp(winSize.width/2.0, 640);
		[self addChild: congratulationsCloud];
		
		CCSprite* summaryCloud = [CCSprite spriteWithFile:@"summary_cloud.png"];
		summaryCloud.opacity = 0;
		summaryCloud.anchorPoint = ccp(0.5,0.5);
		summaryCloud.position = ccp(winSize.width/2.0, winSize.height/2.0);
		summaryCloud.scale = 2;
		[self addChild: summaryCloud];
		
		backCloud = [CCSprite spriteWithFile:@"back_cloud.png"];
		backCloud.opacity = 0;
		backCloud.anchorPoint = ccp(0.5,0.5);
		backCloud.position = ccp(winSize.width/2.0, 150);
		[self addChild: backCloud];
		
		CCLabelTTF* congratulationsLabel = [CCLabelTTF labelWithString:@"CONGRATULATIONS" fontName:@"Arial" fontSize:68];
		congratulationsLabel.color = ccBLACK;
		congratulationsLabel.anchorPoint = ccp(0.5,0.5);
		congratulationsLabel.scale = 2.0;
		congratulationsLabel.position = ccp(winSize.width/2.0, winSize.height/2.0);
		congratulationsLabel.opacity = 0;
		[self addChild: congratulationsLabel];
		
		CCLabelTTF* timeLabel = [CCLabelTTF labelWithString:@"TIME" fontName:@"Arial" fontSize:48];
		timeLabel.color = ccBLACK;
		timeLabel.anchorPoint = ccp(1,0.5);
		timeLabel.position = ccp(0, 456);
		[self addChild: timeLabel];
		
		CCLabelTTF* timeValueLabel = [CCLabelTTF labelWithString:[InfoPanel getTimeLabelText: [newLogic.gameState getTimeElapsed]] fontName:@"Arial" fontSize:48];
		timeValueLabel.color = ccBLACK;
		timeValueLabel.anchorPoint = ccp(0,0.5);
		timeValueLabel.position = ccp(winSize.width, 456);
		[self addChild: timeValueLabel];
		
		CCLabelTTF* movesLabel = [CCLabelTTF labelWithString:@"MOVES" fontName:@"Arial" fontSize:48];
		movesLabel.color = ccBLACK;
		movesLabel.anchorPoint = ccp(1,0.5);
		movesLabel.position = ccp(0, 398);
		[self addChild: movesLabel];
		
		CCLabelTTF* movesValueLabel = [CCLabelTTF labelWithString: [NSString stringWithFormat: @"%d", newLogic.gameState.movesMade, nil] fontName:@"Arial" fontSize:48];
		movesValueLabel.color = ccBLACK;
		movesValueLabel.anchorPoint = ccp(0,0.5);
		movesValueLabel.position = ccp(winSize.width, 398);
		[self addChild: movesValueLabel];
		
		CCLabelTTF* backLabel = [CCLabelTTF labelWithString:@"BACK TO MENU" fontName:@"Arial" fontSize:48];
		backLabel.color = ccBLACK;
		backItem = [[CCMenuItemLabel itemWithLabel:backLabel target:self selector:@selector(onBack)] retain];
		backMenu = [[CCMenu menuWithItems:backItem, nil] retain];
		backMenu.anchorPoint = ccp(0,0);
		backMenu.position = ccp(0,0);
		backItem.anchorPoint = ccp(0.5,0.5);
		backItem.position = ccp(winSize.width/2.0, 150);
		backItem.scale = 1.5;
		[backItem setOpacity: 0];
		[backItem setIsEnabled:NO];
		[self addChild:backMenu];
		
		[congratulationsCloud runAction:[CCFadeIn actionWithDuration:1]];
		
		[congratulationsLabel runAction:
		 [CCEaseIn actionWithAction:
		  [CCSpawn actions:
		   [CCMoveTo actionWithDuration:2 position:ccp(winSize.width/2.0,640)],
		   [CCScaleTo actionWithDuration:2 scale:1],
		   [CCFadeIn actionWithDuration:2],
		   nil]
							   rate:4]];
		
		[summaryCloud runAction:
		 [CCSequence actions:
		  [CCDelayTime actionWithDuration:2],
		  [CCFadeIn actionWithDuration:1],
		  nil]];
		
		[timeLabel runAction:
		 [CCSequence actions:
		  [CCDelayTime actionWithDuration:2],
		  [CCEaseIn actionWithAction:
		   [CCMoveTo actionWithDuration:1 position:ccp(winSize.width/2.0-12, 456)]
								rate:4],
		  nil]];
		
		[timeValueLabel runAction:
		 [CCSequence actions:
		  [CCDelayTime actionWithDuration:2],
		  [CCEaseIn actionWithAction:
		   [CCMoveTo actionWithDuration:1 position:ccp(winSize.width/2.0+12, 456)]
								rate:4],
		  nil]];
		
		[movesLabel runAction:
		 [CCSequence actions:
		  [CCDelayTime actionWithDuration:3],
		  [CCEaseIn actionWithAction:
		   [CCMoveTo actionWithDuration:1 position:ccp(winSize.width/2.0-12, 398)]
								rate:4],
		  nil]];
		
		[movesValueLabel runAction:
		 [CCSequence actions:
		  [CCDelayTime actionWithDuration:3],
		  [CCEaseIn actionWithAction:
		   [CCMoveTo actionWithDuration:1 position:ccp(winSize.width/2.0+12, 398)]
								rate:4],
		  nil]];
		[backCloud runAction:
		 [CCFadeIn actionWithDuration:1]];
		[backItem runAction:
		 [CCSequence actions:
		  [CCCallBlock actionWithBlock:^(){
			 [backItem setIsEnabled:YES];
		  }],
		  [CCEaseIn actionWithAction:
		   [CCSpawn actions:
			[CCFadeIn actionWithDuration:1],
			[CCScaleTo actionWithDuration:1 scale:1],
			nil] rate:4],
		  nil]];
    }
    return self;
}

- (void) onBack {
	[[CCDirector sharedDirector] replaceScene: [CCTransitionCrossFade transitionWithDuration:0.5 scene: [MainMenuLayer scene]]];
}

- (void) dealloc {
	[backItem release];
	[backMenu release];
	[super dealloc];
}

@end