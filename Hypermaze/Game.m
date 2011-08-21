//
//  Game.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 29.07.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Game.h"
#import "cocos2d.h"

#define ARROW_SIZE	CGSizeMake(82,128)

@implementation Game

CCMenuItemSprite * createArrow(NSString* arrowName, id target, SEL selector) {
	CCSprite* arrowOn = [CCSprite spriteWithFile:arrowName];
	arrowOn.opacity = 128;
	CCSprite* arrowOff = [CCSprite spriteWithFile:arrowName];
	arrowOff.opacity = 64;
	CCMenuItemSprite* arrow = [CCMenuItemSprite itemFromNormalSprite:arrowOff selectedSprite:arrowOn target:target selector:selector];
	[arrow setAnchorPoint:ccp(0,0)];
	return arrow;
}

-(id)initWithLogic: (HPLogic*) newLogic {
	self = [super init];
	if (self) {
		logic = [newLogic retain];
		
		size = [[CCDirector sharedDirector] winSize];
		middleScreen = ccp( size.width /2 , size.height/2 );
		
		mazeLayer = [[[HPMazeLayer alloc] initWithLogic: logic] retain];
		[self addChild: mazeLayer];
		
		interfaceLayer = [[CCLayer node] retain];
		
		CGSize arrowSize = ARROW_SIZE;
		
		CCMenuItemSprite *nArrow = createArrow(@"iso_arrow_n.png",self,@selector(onN:));
		[nArrow setPosition: ccp(size.width - arrowSize.width *2,arrowSize.height)];
		CCMenuItemSprite *nwArrow = createArrow(@"iso_arrow_nw.png",self,@selector(onNW:));
		[nwArrow setPosition: ccp(0,arrowSize.height)];
		CCMenuItemSprite *neArrow = createArrow(@"iso_arrow_ne.png",self,@selector(onNE:));
		[neArrow setPosition:  ccp(size.width - arrowSize.width,arrowSize.height)];
		CCMenuItemSprite *swArrow = createArrow(@"iso_arrow_sw.png",self,@selector(onSW:));
		[swArrow setPosition: ccp(0,0)];
		CCMenuItemSprite *seArrow = createArrow(@"iso_arrow_se.png",self,@selector(onSE:));
		[seArrow setPosition: ccp(size.width - arrowSize.width,0)];
		CCMenuItemSprite *sArrow = createArrow(@"iso_arrow_s.png",self,@selector(onS:));
		[sArrow setPosition: ccp(arrowSize.width,0)];
		
		CCMenu* arrowsMenu = [CCMenu menuWithItems: nArrow, nwArrow, neArrow, swArrow ,seArrow, sArrow, nil];
		arrowsMenu.position = ccp(0,0);
		[interfaceLayer	addChild:arrowsMenu];
		[self addChild: interfaceLayer];
		
		radialMenuLayer = [[RadialMenuLayer alloc] initWithLogic:logic];
		[self addChild: radialMenuLayer];
	}
	return self;
}

- (void) onN: (CCMenuItem  *) menuItem {
	[logic moveInDirection: dirNorth];
}

- (void) onNW: (CCMenuItem  *) menuItem {
	[logic moveInDirection: dirNorthWest];
}

- (void) onNE: (CCMenuItem  *) menuItem {
	[logic moveInDirection: dirNorthEast];
}

- (void) onSW: (CCMenuItem  *) menuItem {
	[logic moveInDirection: dirSouthWest];
}

- (void) onSE: (CCMenuItem  *) menuItem {
	[logic moveInDirection: dirSouthEast];
}

- (void) onS: (CCMenuItem  *) menuItem {
	[logic moveInDirection: dirSouth];
}

-(void) dealloc {
	[mazeLayer release];
	[logic release];
	[interfaceLayer release];
	[super dealloc];
}

@end
