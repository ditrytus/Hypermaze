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

#define ARROW_SIZE			CGSizeMake(82,128)
#define ROTATE_ARROW_SIZE	CGSizeMake(100,116)

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

- (CCMenu *)createArrowSet {
	CGSize arrowSize = ARROW_SIZE;
	CGSize rotateSize = ROTATE_ARROW_SIZE;
	CCMenuItemSprite *nArrow = createArrow(@"iso_arrow_n.png",self,@selector(onN:));
	[nArrow setPosition: ccp(arrowSize.width ,arrowSize.height)];
	CCMenuItemSprite *nwArrow = createArrow(@"iso_arrow_nw.png",self,@selector(onNW:));
	[nwArrow setPosition: ccp(0,arrowSize.height)];
	CCMenuItemSprite *neArrow = createArrow(@"iso_arrow_ne.png",self,@selector(onNE:));
	[neArrow setPosition:  ccp(arrowSize.width * 2, arrowSize.height)];
	CCMenuItemSprite *swArrow = createArrow(@"iso_arrow_sw.png",self,@selector(onSW:));
	[swArrow setPosition: ccp(0,0)];
	CCMenuItemSprite *seArrow = createArrow(@"iso_arrow_se.png",self,@selector(onSE:));
	[seArrow setPosition: ccp(arrowSize.width*2,0)];
	CCMenuItemSprite *sArrow = createArrow(@"iso_arrow_s.png",self,@selector(onS:));
	[sArrow setPosition: ccp(arrowSize.width,0)];
	
	CCMenuItemSprite *clockwiseArrow = createArrow(@"rotateArrowClockwise.png",self,@selector(onClockwise:));
	[clockwiseArrow setPosition: ccp((arrowSize.width*3 - (rotateSize.width * 2))/2.0,arrowSize.height * 2)];
	
	CCMenuItemSprite *counterclockwiseArrow = createArrow(@"rotateArrowCounterclockwise.png",self,@selector(onCounterclockwise:));
	[counterclockwiseArrow setPosition:ccpAdd(clockwiseArrow.position, ccp(rotateSize.width, 0))];
	
	CCMenu* arrowsMenu = [CCMenu menuWithItems: nArrow, nwArrow, neArrow, swArrow ,seArrow, sArrow, clockwiseArrow, counterclockwiseArrow, nil];
	return arrowsMenu;
}

-(id)initWithLogic: (HPLogic*) newLogic {
	self = [super init];
	if (self) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPositionChanged:) name:EVENT_POSITION_CHANGED object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onViewChanged:) name:EVENT_VIEW_CHANGED object:nil];
		
		logic = [newLogic retain];
		
		size = [[CCDirector sharedDirector] winSize];
		middleScreen = ccp( size.width /2 , size.height/2 );
		
		mazeLayer = [[[HPMazeLayer alloc] initWithLogic: logic] retain];
		mazeLayer.positionInPixels = ccp(-80,-85);
		[self addChild: mazeLayer];
		
		compassArrow = [[CCSprite spriteWithFile:@"compass_arrow.png"] retain];
		compassArrow.anchorPoint = ccp(0.5, 116.0/(-200.0+116.0/2.0));
		compassArrow.position = middleScreen;
		compassArrow.rotation = [mazeLayer getCompassAngle];
		compassArrow.visible = NO;
		[self addChild:compassArrow];
		
		interfaceLayer = [[CCLayer node] retain];
		
		CCMenu *arrowsLeftMenu = [self createArrowSet];
		arrowsLeftMenu.position = ccp(0,0);
		[interfaceLayer	addChild:arrowsLeftMenu];
		
		
		CCMenu *arrowsRightMenu = [self createArrowSet];
		arrowsRightMenu.position = ccp(size.width - ARROW_SIZE.width*3,0);
		[interfaceLayer	addChild:arrowsRightMenu];
		
		[self addChild: interfaceLayer];
		
		
		radialMenuLayer = [[RadialMenuLayer alloc] initWithLogic:logic];
		[self addChild: radialMenuLayer];
	}
	return self;
}

- (void) onN: (CCMenuItem  *) menuItem {
	[logic moveInDirection: [HPDirectionUtil rotateDirection: dirNorth by: -logic.rotation]];
}

- (void) onNW: (CCMenuItem  *) menuItem {
	[logic moveInDirection: [HPDirectionUtil rotateDirection: dirNorthWest by: -logic.rotation]];
}

- (void) onNE: (CCMenuItem  *) menuItem {
	[logic moveInDirection: [HPDirectionUtil rotateDirection: dirNorthEast by: -logic.rotation]];
}

- (void) onSW: (CCMenuItem  *) menuItem {
	[logic moveInDirection: [HPDirectionUtil rotateDirection: dirSouthWest by: -logic.rotation]];
}

- (void) onSE: (CCMenuItem  *) menuItem {
	[logic moveInDirection: [HPDirectionUtil rotateDirection: dirSouthEast by: -logic.rotation]];
}

- (void) onS: (CCMenuItem  *) menuItem {
	[logic moveInDirection: [HPDirectionUtil rotateDirection: dirSouth by: -logic.rotation]];
}

- (void) onClockwise: (CCMenuItem  *) menuItem {
	[logic rotateClockwise];
}

- (void) onCounterclockwise: (CCMenuItem  *) menuItem {
	[logic rotateCounterclockwise];
}

- (void) onViewChanged: (NSNotification*) notification {
	if (logic.showCompass) {
		compassArrow.visible = YES;
	} else {
		compassArrow.visible = NO;
	}
}

- (void) onPositionChanged: (NSNotification*) notification {
	[compassArrow runAction: [CCRotateTo actionWithDuration:1 angle:[mazeLayer getCompassAngle]]];
}

-(void) dealloc {
	[mazeLayer release];
	[logic release];
	[interfaceLayer release];
	[super dealloc];
}

@end
