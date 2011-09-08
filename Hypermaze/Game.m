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

- (void)updateLabels {
	movesMadeLabel.string = [NSString stringWithFormat:@"%d", logic.gameState.movesMade, nil];
	int visited = [logic getNumOfVisited];
	int total = [logic getTotalChambers];
	visitedLabel.string = [NSString stringWithFormat:@"%d (%d%%)", visited, (visited*100)/total, nil];
	unvisitedLabel.string = [NSString stringWithFormat:@"%d (%d%%)", total - visited, ((total - visited)*100)/total, nil];
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
		compassArrow.opacity = 150;
		compassArrow.anchorPoint = ccp(0.5, (-200.0+116.0/2.0)/116.0);
		compassArrow.position = middleScreen;
		compassArrow.rotation = [mazeLayer getCompassAngle];
		compassArrow.visible = NO;
		[self addChild:compassArrow];
		
		CCSprite* infoPanel = [CCSprite spriteWithFile:@"info_panel.png"];
		infoPanel.anchorPoint = ccp(0,0);
		infoPanel.position = ccp((size.width - [infoPanel textureRect].size.width) / 2.0, size.height - [infoPanel textureRect].size.height);
		[self addChild: infoPanel];
		
		CCSprite* clockInfo = [CCSprite spriteWithFile:@"clock_info.png"];
		clockInfo.position = ccp(infoPanel.position.x + 37, infoPanel.position.y + [infoPanel textureRect].size.height / 2.0);
		[self addChild: clockInfo];
		
		timeElapsedLabel = [[CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:16] retain];
		timeElapsedLabel.position = ccp(infoPanel.position.x + 52, infoPanel.position.y + [infoPanel textureRect].size.height / 2.0);
		timeElapsedLabel.anchorPoint = ccp(0,0.5);
		timeElapsedLabel.color = ccBLACK;
		[self addChild: timeElapsedLabel];
		
		CCSprite* footInfo = [CCSprite spriteWithFile:@"foot_info.png"];
		footInfo.position = ccp(infoPanel.position.x + 145, infoPanel.position.y + [infoPanel textureRect].size.height / 2.0);
		[self addChild: footInfo];
		
		movesMadeLabel = [[CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:16] retain];
		movesMadeLabel.anchorPoint = ccp(0,0.5);
		movesMadeLabel.position = ccp(infoPanel.position.x + 158, infoPanel.position.y + [infoPanel textureRect].size.height / 2.0);
		movesMadeLabel.color = ccBLACK;
		[self addChild: movesMadeLabel];
		
		CCSprite* doorInfo = [CCSprite spriteWithFile:@"door_info.png"];
		doorInfo.position = ccp(infoPanel.position.x + 223, infoPanel.position.y + [infoPanel textureRect].size.height / 2.0);
		[self addChild: doorInfo];
		
		unvisitedLabel =[[CCLabelTTF labelWithString:[NSString stringWithFormat:@"",(int)pow(logic.maze.size,3)-1, nil] fontName:@"Arial" fontSize:16] retain];
		unvisitedLabel.anchorPoint = ccp(0,0.5);
		unvisitedLabel.position = ccp(infoPanel.position.x + 234, infoPanel.position.y + [infoPanel textureRect].size.height / 2.0);
		unvisitedLabel.color = ccBLACK;
		[self addChild: unvisitedLabel];
		
		CCSprite* doorOpenInfo = [CCSprite spriteWithFile:@"door_open_info.png"];
		doorOpenInfo.position = ccp(infoPanel.position.x + 345, infoPanel.position.y + [infoPanel textureRect].size.height / 2.0);
		[self addChild: doorOpenInfo];
		
		visitedLabel = [[CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:16] retain];
		visitedLabel.anchorPoint = ccp(0,0.5);
		visitedLabel.position = ccp(infoPanel.position.x + 357, infoPanel.position.y + [infoPanel textureRect].size.height / 2.0);
		visitedLabel.color = ccBLACK;
		[self addChild:visitedLabel];
		
		[self updateLabels];
		[self schedule:@selector(updateTimeLabel:) interval:1];
		
		interfaceLayer = [[CCLayer node] retain];
		
		CCMenu *arrowsLeftMenu = [self createArrowSet];
		arrowsLeftMenu.position = ccp(0,0);
		[interfaceLayer	addChild:arrowsLeftMenu];
		
		
		CCMenu *arrowsRightMenu = [self createArrowSet];
		arrowsRightMenu.position = ccp(size.width - ARROW_SIZE.width*3,0);
		[interfaceLayer	addChild:arrowsRightMenu];
		
		[self addChild: interfaceLayer];
		
		radialMenuLayer = [[RadialMenuLayer alloc] initWithLogic:logic game:self];
		[self addChild: radialMenuLayer];
	}
	return self;
}

- (void) saveGame {
	NSFileManager *fileManager= [NSFileManager defaultManager];
	
	NSString* baseDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString* saveGameDir = [[baseDirectory stringByAppendingPathComponent:@"Save"]
							 stringByAppendingPathComponent:[logic.beginDate description]];
	
	if (![fileManager fileExistsAtPath:saveGameDir]) {
		NSError* error;
		if(![fileManager createDirectoryAtPath:saveGameDir withIntermediateDirectories:YES attributes:nil error:&error]) {
			NSLog(@"%@", [error description], nil);
		}
	}
	
	if ([NSKeyedArchiver archiveRootObject:logic
									toFile:[saveGameDir stringByAppendingPathComponent:@"data.hmz"]]) {
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
	[screenshot saveBuffer:[saveGameDir stringByAppendingPathComponent:@"screenshot.png"]];
	if (![metadata writeToFile:[saveGameDir stringByAppendingPathComponent:@"metadata.hmz"] atomically:YES]) {
		NSLog(@"METADATA ERROR");
	}
}

- (void) updateTimeLabel: (ccTime) time {
	NSTimeInterval interval = [logic.gameState getTimeElapsed];
	int hours = floor(interval / 3600);
	int minutes = floor(((int)interval % 3600) / 60);
	NSString* minutesLeadingZero = (minutes < 10 ? @"0" : @"");
	int seconds = floor((int)interval % 60);
	NSString* secondsLeadingZero = (seconds < 10 ? @"0" : @"");
	timeElapsedLabel.string = [NSString stringWithFormat:@"%d:%@%d:%@%d", hours, minutesLeadingZero, minutes, secondsLeadingZero, seconds, nil];
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
	[compassArrow runAction:
	 [CCEaseOut actionWithAction:
	  [CCRotateTo actionWithDuration:1
							   angle:[mazeLayer getCompassAngle]]
						   rate:2]];
	[self updateLabels];

}

-(void) dealloc {
	[mazeLayer release];
	[logic release];
	[interfaceLayer release];
	[timeElapsedLabel release];
	[movesMadeLabel release];
	[super dealloc];
}

@end
