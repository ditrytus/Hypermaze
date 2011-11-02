//
//  LoadingLayer.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 23.07.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoadingLayer.h"
#import "Game.h"
#import "HPConfiguration.h"

@implementation LoadingLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	LoadingLayer *layer = [LoadingLayer node];
	[scene addChild: layer];
	return scene;
}

- (id)init
{
    self = [super init];
    if (self) {
		generator = [[HPMazeGenerator alloc] init];
		
		CGSize size = [[CCDirector sharedDirector] winSize];
		CGPoint middleScreen = ccp( size.width /2 , size.height/2 );
		
		CCSprite *background = [[CCSprite alloc] initWithFile:@"background.png"];
		background.position = middleScreen;
		background.scale = 2.0;
		
		fill = [[[CCSprite alloc] init] retain];
		[fill setColor: ccWHITE];
		[fill setTextureRect: CGRectMake(0, 0, 1, 166)];
		[fill setOpacity: 255];
		fill.anchorPoint = ccp(0,0);
		fill.position = ccp(114,301);
		
		CCSprite *jointA = [[CCSprite alloc] initWithFile:@"progressbar_joint.png"];
	    jointA.position = ccp(137,408);
		
		CCLabelTTF* labelA = [CCLabelTTF labelWithString:@"BEGIN" fontName:@"Arial" fontSize:32];
		labelA.position = ccp(jointA.position.x, jointA.position.y - 40);
		
		CCSprite *jointB = [[CCSprite alloc] initWithFile:@"progressbar_joint.png"];
		jointB.position = ccp(892,408);
		
		CCLabelTTF* labelB = [CCLabelTTF labelWithString:@"END" fontName:@"Arial" fontSize:32];
		labelB.position = ccp(jointB.position.x, jointB.position.y + 40);
		
		CCLabelTTF* loadingLabel = [CCLabelTTF labelWithString:@"LOADING" fontName:@"Arial" fontSize:64];
		loadingLabel.position = ccp(middleScreen.x,middleScreen.y * 0.5);
		
		CCSprite *mask = [[CCSprite alloc] initWithFile:@"progressbar_mask.png"];
		mask.anchorPoint = ccp(0,0);
		mask.position = ccp(114,300);
		mask.scale = 2.0;
		
		[self addChild: background];
		[self addChild: fill];
		[self addChild: mask];
		[self addChild: jointA];
		[self addChild: jointB];
		[self addChild: labelA];
		[self addChild: labelB];
		[self addChild: loadingLabel];
		
		[loadingLabel runAction: [CCRepeatForever actionWithAction:[CCSequence actions:[CCEaseSineIn actionWithAction:[CCScaleTo actionWithDuration:0.25 scale:1.025]],[CCEaseSineOut actionWithAction: [CCScaleTo actionWithDuration:0.25 scale:0.975]], nil]]];
		
		[self scheduleUpdate];
    }
    return self;
}

- (void) onEnterTransitionDidFinish {
	aQueue = [[[NSOperationQueue alloc] init] retain];
	[aQueue addOperationWithBlock:^{
		completePerformed = NO;
		[generator generateMazeInSize: [[HPConfiguration sharedConfiguration].difficulty intValue]];
	}];
}

-(void) update:(ccTime)deltaTime
{
	switch([generator getStatus])
	{
		case genBegin: break;
		case genWorking: {
			[fill setTextureRect:CGRectMake(0, 0, 794 * [generator getProgress], 166)];
		} break;
		case genComplete: {
			if (!completePerformed)
			{
				completePerformed = YES;
				[fill setTextureRect:CGRectMake(0, 0, 794, 166)];
				[[CCDirector sharedDirector] replaceScene: [[CCTransitionCrossFade transitionWithDuration:0.5 scene:[[Game alloc] initWithLogic:  [[HPLogic alloc] initWithMaze:[generator getMaze]]]] retain]];
			}
		} break;
	}
}

-(void) dealloc {
	[generator release];
	[fill release];
	[aQueue release];
	[super dealloc];
}

@end
