//
//  Game.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 29.07.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Game.h"
#import "cocos2d.h"

#define TILE_SIZE	CGSizeMake(88,48)
#define TILE_HEIGHT 48
#define ARROW_SIZE	CGSizeMake(82,128)
#define PINK		@"pink"
#define YELLOW		@"yellow"
#define RED			@"red"
#define GREEN		@"green"

@implementation Game

NSString * chamberFrameName(NSString *colorName,FS3DPoint position,Byte ***mazeTopology) {
  NSString* chamberName = [NSString stringWithFormat: @"chambers_%@_%@.png", [NSNumber numberWithChar:mazeTopology[position.x][position.y][position.z]], colorName];
  return chamberName;
}

void loadChamberSet(NSString *colorName) {
  [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: [NSString stringWithFormat: @"chambers_%@.plist", colorName]
														   textureFile: [NSString stringWithFormat: @"chambers_%@.png", colorName]];

}

void loadChamberLayer(int mazeSize,CCSprite *****chambers,FSIsoSystem *isoSys,Byte ***mazeTopology,NSString* colorName, BOOL visible) {  
	(*chambers) = malloc(mazeSize*sizeof(CCSprite***));
	for (int z=0; z<mazeSize; z++) {
		(*chambers)[z] = malloc(mazeSize*sizeof(CCSprite**));
		for (int y=mazeSize-1; y>=0; y--) {
			(*chambers)[z][y] = malloc(mazeSize*sizeof(CCSprite*));
			for (int x=mazeSize-1; x>=0; x--) {
				NSString *chamberName = chamberFrameName(colorName,point3D(x, y, z),mazeTopology);
				CCSprite* chamber = [CCSprite spriteWithSpriteFrameName:chamberName];
				chamber.anchorPoint = ccp(0,0);
				CGPoint chamberPos = [isoSys getTileRealPosition:CGPointMake(x, y)];
				chamberPos.y += z * TILE_HEIGHT;
				chamber.position = chamberPos;
				int depth = MIN(MIN(x, y),mazeSize - z - 1);
//				[chamber setColor:ccc3(255- depth,255 - depth,255 - depth)];
				[chamber setVisible: depth < 3 ? visible : NO];
				(*chambers)[z][y][x] = chamber;
			}
		}
	}
}

CCMenuItemSprite * createArrow(NSString* arrowName, id target, SEL selector) {
	CCSprite* arrowOn = [CCSprite spriteWithFile:arrowName];
	arrowOn.opacity = 128;
	CCSprite* arrowOff = [CCSprite spriteWithFile:arrowName];
	arrowOff.opacity = 64;
	CCMenuItemSprite* arrow = [CCMenuItemSprite itemFromNormalSprite:arrowOff selectedSprite:arrowOn target:target selector:selector];
	[arrow setAnchorPoint:ccp(0,0)];
	return arrow;
}

void setChamberColor(Byte ***mazeTopology,FS3DPoint position,CCSprite ****chambers, NSString* colorName) {
  [chambers[position.z][position.y][position.x] setDisplayFrame: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: chamberFrameName(colorName,position,mazeTopology)]];

}
-(id)initWithLogic: (HPLogic*) newLogic {
	self = [super init];
	if (self) {
		logic = [newLogic retain];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPositionChanged:) name:EVENT_POSITION_CHANGED object:nil];
		
		size = [[CCDirector sharedDirector] winSize];
		middleScreen = ccp( size.width /2 , size.height/2 );
		
//		CCSprite *background = [[CCSprite alloc] initWithFile:@"background.png"];
//		background.position = middleScreen;
//		background.scale = 2.0;
//		
//		backgroundLayer = [[CCLayer node] retain];
//		[backgroundLayer addChild:background];
		
//		[self addChild:backgroundLayer];
		
		mazeLayer = [[CCLayer node] retain];
		
		Byte*** mazeTopology = logic.maze.topology;
		int mazeSize = logic.maze.size;
		
		isoSys = [[[FSIsoSystem alloc] initWithTileSize: TILE_SIZE mapSize:CGSizeMake(mazeSize,mazeSize)] retain];
		
		loadChamberSet(PINK);
		loadChamberSet(YELLOW);
		loadChamberSet(RED);
		loadChamberSet(GREEN);
		
		loadChamberLayer(mazeSize,&pinkChambers,isoSys,mazeTopology,PINK, YES);
		
		for (int z=0; z<mazeSize; z++) {
			for (int y=mazeSize-1; y>=0; y--) {
				for (int x=mazeSize-1; x>=0; x--) {
					[mazeLayer addChild: pinkChambers[z][y][x]];
					if (x==0 && y==0 && z==0) {
						setChamberColor(mazeTopology,point3D(x, y, z),pinkChambers,YELLOW);
					}
				}
			}
		}
		
		mazeLayer.position = CGPointMake(middleScreen.x - [isoSys getTileRealPosition:CGPointMake(0, 0)].x - TILE_SIZE.width/2.0, middleScreen.y - TILE_SIZE.height/2.0);
		
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

- (void) onPositionChanged: (NSNotification*) notification {
	NSDictionary* dict = notification.userInfo;
	
	NSData* previousPositionData = [dict objectForKey:@"previousPosition"];
	FS3DPoint previousPosition;
	[previousPositionData getBytes: &previousPosition length:sizeof(FS3DPoint)];
	
	NSData* currentPositionData = [dict objectForKey:@"currentPosition"];
	FS3DPoint currentPosition;
	[currentPositionData getBytes: &currentPosition length:sizeof(FS3DPoint)];
	
	setChamberColor(logic.maze.topology, previousPosition, pinkChambers, PINK);
	setChamberColor(logic.maze.topology, currentPosition, pinkChambers, YELLOW);
	
	CGPoint newPos = pinkChambers[currentPosition.z][currentPosition.y][currentPosition.x].position;
	
	[mazeLayer stopAllActions];
	[mazeLayer runAction: [CCEaseOut actionWithAction:
						   [CCMoveBy actionWithDuration:1
											   position: ccpSub(middleScreen,
																ccpAdd(newPos,mazeLayer.position))]
												 rate:4
						   ]];
}

-(void) dealloc {
	//[backgroundLayer release];
	[mazeLayer release];
	[isoSys release];
	for(int i=0; i<logic.maze.size; i++) {
		for (int j=0; j<logic.maze.size; j++) {
			free(pinkChambers[i][j]);
		}
		free(pinkChambers[i]);
	}
	free(pinkChambers);
	[logic release];
	[interfaceLayer release];
	[super dealloc];
}

@end
