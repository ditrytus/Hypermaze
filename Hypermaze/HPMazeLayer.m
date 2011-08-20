//
//  HPMazeLayer.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 19.08.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HPMazeLayer.h"

@implementation HPMazeLayer

#define TILE_SIZE	CGSizeMake(88,48)
#define CHAMBER_TEXTURE_SIZE CGSizeMake(62,71)
#define TILE_HEIGHT 48
#define PINK		@"pink"
#define YELLOW		@"yellow"
#define RED			@"red"
#define GREEN		@"green"

NSString * chamberFrameName(NSString *colorName, Byte chamber) {
	NSString* chamberName = [NSString stringWithFormat: @"chambers_%@_%@.png", [NSNumber numberWithChar: chamber], colorName];
	return chamberName;
}

void loadChamberSet(NSString *colorName) {
	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: [NSString stringWithFormat: @"chambers_%@.plist", colorName]
															 textureFile: [NSString stringWithFormat: @"chambers_%@.png", colorName]];
}

- (id)initWithLogic: (HPLogic*) newLogic
{
    self = [super init];
    if (self) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPositionChanged:) name:EVENT_POSITION_CHANGED object:nil];
		logic = [newLogic retain];
		mazeSize = [[logic maze] size];
		topology = [[logic maze] topology];
		isoSys = [[[FSIsoSystem alloc] initWithTileSize: TILE_SIZE mapSize:CGSizeMake(mazeSize,mazeSize)] retain];
		loadChamberSet(PINK);
		pinkChamberPrototypes = malloc(sizeof(CCSprite*)*64);
		loadChamberSet(YELLOW);
		yellowChamberPrototypes = malloc(sizeof(CCSprite*)*64);
		loadChamberSet(RED);
		greenChamberPrototypes = malloc(sizeof(CCSprite*)*64);
		loadChamberSet(GREEN);
		redChamberPrototypes = malloc(sizeof(CCSprite*)*64);
		for (int i=1; i<64; i++) {
			int index = i-1;
			pinkChamberPrototypes[index] = [[CCSprite spriteWithSpriteFrameName:chamberFrameName(PINK,i)] retain];
			pinkChamberPrototypes[index].anchorPoint = ccp(0,0);
			
			yellowChamberPrototypes[index] = [[CCSprite spriteWithSpriteFrameName:chamberFrameName(YELLOW,i)] retain];
			yellowChamberPrototypes[index].anchorPoint = ccp(0,0);
			
			greenChamberPrototypes[index] = [[CCSprite spriteWithSpriteFrameName:chamberFrameName(GREEN,i)] retain];
			greenChamberPrototypes[index].anchorPoint = ccp(0,0);
			
			redChamberPrototypes[index] = [[CCSprite spriteWithSpriteFrameName:chamberFrameName(RED,i)] retain];
			redChamberPrototypes[index].anchorPoint = ccp(0,0);
		}
		CGSize mazeTextureSize = CGSizeMake(mazeSize*(CHAMBER_TEXTURE_SIZE.width+30),(CHAMBER_TEXTURE_SIZE.height+25)*mazeSize);
		mazeTexture = [CCRenderTexture renderTextureWithWidth: mazeTextureSize.width height: mazeTextureSize.height];
		CGSize size = [[CCDirector sharedDirector] winSize];
		CGPoint middleScreen = ccp( size.width /2 , size.height/2 );
		CGPoint firstChamberPos = [self getChamberPos:point3D(0, 0, 0)];
		mazeTexture.sprite.anchorPoint = ccp((double)firstChamberPos.x/(double)mazeTextureSize.width,1.0-((double)firstChamberPos.y/(double)mazeTextureSize.height));
		mazeTexture.sprite.position = middleScreen;
		positionCache = malloc(sizeof(CGPoint**)*mazeSize);
		for (int x=0; x<mazeSize; x++) {
			positionCache[x] = malloc(sizeof(CGPoint*)*mazeSize);
			for (int y=0; y<mazeSize; y++) {
				positionCache[x][y] = malloc(sizeof(CGPoint)*mazeSize);
				for (int z=0; z<mazeSize; z++) {
					CGPoint chamberPos;
					chamberPos = [isoSys getTileRealPosition:CGPointMake(x, y)];
					chamberPos.y += z * TILE_HEIGHT;
					positionCache[x][y][z] = chamberPos;
				}
			}
		}
		[self redrawMazeTexture];
		[self addChild: mazeTexture];
    }
    return self;
}

- (void) redrawMazeTexture {
	FS3DPoint curPos = [[logic gameState] currentPosition];
	CCSprite* chamber; 
	[mazeTexture beginWithClear:0.0f g:0.0f b:0.0f a:1.0f];
	for (int z=0; z<mazeSize; z++) {
		for (int y=mazeSize-1; y>=0; y--) {
			for (int x=mazeSize-1; x>=0; x--) {
				if (curPos.x == x && curPos.y == y && curPos.z == z) {
					chamber = yellowChamberPrototypes[topology[x][y][z]-1];
				} else {
					chamber = pinkChamberPrototypes[topology[x][y][z]-1];
				}
				chamber.position = positionCache[x][y][z];
				[chamber visit];
			}
		}
	}
	[mazeTexture end];
}

-(CGPoint) getChamberPos: (FS3DPoint) coords {
	CGPoint chamberPos = [isoSys getTileRealPosition:CGPointMake(coords.x, coords.y)];
	chamberPos.y += coords.z * TILE_HEIGHT;
	return chamberPos;
}

- (void) dealloc {
	[logic release];
	for (int x=0; x<mazeSize; x++) {
		free(positionCache[x]);
		for (int y=0; y<mazeSize; y++) {
			free(positionCache[x][y]);
		}
	}
	free(positionCache);
	free(pinkChamberPrototypes);
	free(yellowChamberPrototypes);
	free(greenChamberPrototypes);
	free(redChamberPrototypes);
	[super dealloc];
}

- (void) onPositionChanged: (NSNotification*) notification {
	NSDictionary* dict = notification.userInfo;
	
	NSData* previousPositionData = [dict objectForKey:@"previousPosition"];
	FS3DPoint previousPosition;
	[previousPositionData getBytes: &previousPosition length:sizeof(FS3DPoint)];
	
	NSData* currentPositionData = [dict objectForKey:@"currentPosition"];
	FS3DPoint currentPosition;
	[currentPositionData getBytes: &currentPosition length:sizeof(FS3DPoint)];
	
	[self redrawMazeTexture];
	
	CGPoint oldPos = [self getChamberPos: previousPosition];
	CGPoint newPos = [self getChamberPos: currentPosition];
	
	[self stopAllActions];
	[self runAction: [CCEaseOut actionWithAction:
									   [CCMoveBy actionWithDuration: 1
														   position: ccpSub(oldPos, newPos)]
															 rate:4]];
}

@end
