//
//  HPMazeLayer.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 19.08.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HPMazeLayer.h"
#import "HPPositionUtil.h"
#import "HPChamberUtil.h"

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

- (CCSprite*) grassBackgroundWidth: (int) width height: (int) height {
	CCSprite* grassTile = [CCSprite spriteWithFile:@"grass_tile.png"];
	int logicWidth = (width /  TILE_SIZE.width) + 1;
	int logicHeigth = (height / TILE_SIZE.height) + 1;
	CCRenderTexture* grassBackground = [CCRenderTexture renderTextureWithWidth: TILE_SIZE.width * (logicWidth - 1) height:TILE_SIZE.height * (logicHeigth-0.5) + 5];
	FSIsoSystem* grassIso = [[FSIsoSystem alloc] initWithTileSize:TILE_SIZE mapSize:CGSizeMake(logicWidth+logicHeigth-1, logicWidth+logicHeigth-1)];
	CGPoint viewDelta = [grassIso getTileRealPosition:ccp(0,logicWidth - 1)];
	[grassBackground beginWithClear:0 g:0 b:0 a:1];
	for (int i=0; i<2*logicHeigth-1; i++) {
		int x = logicWidth-1+i/2;
		int y = (i+1)/2;
		int jLimit = i%2==0?logicWidth:logicWidth-1;
		for (int j=0; j<jLimit; j++) {
			CGPoint isoPosition = [grassIso getTileRealPosition:ccp(x-j,y+j)];
			grassTile.position = ccpSub(isoPosition, viewDelta);
			[grassTile visit];
		}
	}
	[grassBackground end];
	return [CCSprite spriteWithTexture:grassBackground.sprite.texture];
}

- (id)initWithLogic: (HPLogic*) newLogic
{
    self = [super init];
    if (self) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPositionChanged:) name:EVENT_POSITION_CHANGED object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onViewChanged:) name:EVENT_VIEW_CHANGED object:nil];
		
		mark = [[CCSprite spriteWithFile:@"mark.png"] retain];
		mark.anchorPoint = ccp(0,0);
		
		outerNEWiredPrototype = [[CCSprite spriteWithFile:@"outer-NE-wire.png"] retain];
		outerNEWiredPrototype.anchorPoint = ccp(0,0);
		outerNEFilledPrototype = [[CCSprite spriteWithFile:@"outer-NE-filled.png"] retain];
		outerNEFilledPrototype.anchorPoint = ccp(0,0);
		
		outerNWWiredPrototype = [[CCSprite spriteWithFile:@"outer-NW-wire.png"] retain];
		outerNWWiredPrototype.anchorPoint = ccp(0,0);
		outerNWFilledPrototype = [[CCSprite spriteWithFile:@"outer-NW-filled.png"] retain];
		outerNWFilledPrototype.anchorPoint = ccp(0,0);
		
		outerSWiredPrototype = [[CCSprite spriteWithFile:@"outer-S-wire.png"] retain];
		outerSWiredPrototype.anchorPoint = ccp(0,0);
		outerSFilledPrototype = [[CCSprite spriteWithFile:@"outer-S-filled.png"] retain];
		outerSFilledPrototype.anchorPoint = ccp(0,0);
		
		logic = [newLogic retain];
		mazeSize = [[logic maze] size];
		topology = [[logic maze] topology];
		isoSys = [[[FSIsoSystem alloc] initWithTileSize: TILE_SIZE mapSize:CGSizeMake(mazeSize,mazeSize)] retain];
		CGSize size = [[CCDirector sharedDirector] winSize];
		CGPoint middleScreen = ccp( size.width / 2 , size.height / 2 );
		CGPoint firstChamberPos = [self getChamberPos:point3D(0, 0, 0)];
		CGSize mazeTextureSize = CGSizeMake(mazeSize*(CHAMBER_TEXTURE_SIZE.width+30)+100,(CHAMBER_TEXTURE_SIZE.height+25)*mazeSize+100);
		
		CCSprite* backgroud = [self grassBackgroundWidth: TILE_SIZE.width * 10 height: TILE_SIZE.height * 10];
		for (int i=0; i<5; i++) {
			for (int j=0; j<5; j++) {
				CCSprite* bkg = [CCSprite spriteWithTexture:backgroud.texture];
				bkg.position = ccpAdd(middleScreen, ccp(bkg.textureRect.size.width * (i-3) - 9, bkg.textureRect.size.height*(j-1)+14));
				[self addChild: bkg];
			}
		}
		
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
		
		mazeTexture = [CCRenderTexture renderTextureWithWidth: mazeTextureSize.width height: mazeTextureSize.height];
		[mazeTexture.sprite setBlendFunc:(ccBlendFunc){GL_ONE, GL_ONE_MINUS_SRC_ALPHA}];
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
		chamberRotationCache = malloc(sizeof(Byte*)*64);
		for (int i=0; i<64; i++) {
			chamberRotationCache[i] = malloc(sizeof(Byte)*4);
			for (int j=0; j<4; j++) {
				chamberRotationCache[i][j] = [HPChamberUtil rotateChamber:i by:j];
			}
		}
		[self redrawMazeTexture];
		[self addChild: mazeTexture];
    }
    return self;
}

- (void) redrawMazeTexture {
	FS3DPoint curPos = [[logic gameState] currentPosition];
	FS3DPoint rotCurPos = [HPPositionUtil rotatePoint:curPos by:logic.rotation withSize:mazeSize];
	HPVisibilityMask* visibilityMask = logic.visibilityMask;
	HPMarkMask* markMask = logic.markMask;
	CCSprite* chamber;
	[mazeTexture clear:0.0f g:0.0f b:0.0f a:0.0f];
	[mazeTexture begin];
	if (logic.showBorders) {
		CGPoint correctionPoint = ccp(50-16,50-12);
		for (int y=mazeSize-1; y>=0; y--) {
			for (int x=mazeSize-1; x>=0; x--) {
				if (y == rotCurPos.y && x == rotCurPos.x) {
					outerSFilledPrototype.position = ccpAdd(positionCache[x][y][0],correctionPoint);
					[outerSFilledPrototype visit];
				} else {
					outerSWiredPrototype.position = ccpAdd(positionCache[x][y][0],correctionPoint);
					[outerSWiredPrototype visit];
				}
			}
		}
		correctionPoint = ccp(50-16+3,50-12-1);
		for (int z=0; z<mazeSize; z++) {
			for (int x=mazeSize-1; x>=0; x--) {
				if (x == rotCurPos.x && z == rotCurPos.z) {
					outerNWFilledPrototype.position = ccpAdd(positionCache[x][mazeSize-1][z],correctionPoint);
					[outerNWFilledPrototype visit];
				} else {
					outerNWWiredPrototype.position = ccpAdd(positionCache[x][mazeSize-1][z],correctionPoint);
					[outerNWWiredPrototype visit];
				}
			}
		}
		correctionPoint = ccp(50-16-2,50-12-1);
		for (int z=0; z<mazeSize; z++) {
			for (int y=mazeSize-1; y>=0; y--) {
				if (y == rotCurPos.y && z == rotCurPos.z) {
					outerNEFilledPrototype.position = ccpAdd(positionCache[mazeSize-1][y][z],correctionPoint);
					[outerNEFilledPrototype visit];
				} else {
					outerNEWiredPrototype.position = ccpAdd(positionCache[mazeSize-1][y][z],correctionPoint);
					[outerNEWiredPrototype visit];
				}
			}
		}
	}
	for (int z=0; z<mazeSize; z++) {
		for (int y=mazeSize-1; y>=0; y--) {
			for (int x=mazeSize-1; x>=0; x--) {
				FS3DPoint point = point3D(x,y,z);
				FS3DPoint rotPoint = [HPPositionUtil rotatePoint: point3D(x,y,z) by:-logic.rotation withSize:mazeSize];
				if ([[visibilityMask getValue: rotPoint] boolValue])
				{
					if (rotCurPos.x == point.x && rotCurPos.y == point.y && rotCurPos.z == point.z) {
						if (![logic showTarget]) {
							mark.position = ccpAdd(positionCache[point.x][point.y][point.z],ccp(35, 35));
							[mark visit];
							chamber = yellowChamberPrototypes[chamberRotationCache[topology[rotPoint.x][rotPoint.y][rotPoint.z]][logic.rotation]-1];
							chamber.position = ccpAdd(positionCache[point.x][point.y][point.z],ccp(50, 50));
							[chamber visit];
						}
					} else {
						switch ([markMask getValue: rotPoint]) {
							case cmVisited:
								chamber = yellowChamberPrototypes[chamberRotationCache[topology[rotPoint.x][rotPoint.y][rotPoint.z]][logic.rotation]-1];
								break;
							case cmAriadna:
								chamber = greenChamberPrototypes[chamberRotationCache[topology[rotPoint.x][rotPoint.y][rotPoint.z]][logic.rotation]-1]; 
								break;
							case cmUntaken:
								chamber = redChamberPrototypes[chamberRotationCache[topology[rotPoint.x][rotPoint.y][rotPoint.z]][logic.rotation]-1];
								break;
							default:
								chamber = pinkChamberPrototypes[chamberRotationCache[topology[rotPoint.x][rotPoint.y][rotPoint.z]][logic.rotation]-1];
								break;
						}
						chamber.position = ccpAdd(positionCache[point.x][point.y][point.z],ccp(50, 50));
						[chamber visit];
					}
				}
			}
		}
	}
	if ([logic showTarget]) {
		mark.position = ccpAdd(positionCache[rotCurPos.x][rotCurPos.y][rotCurPos.z],ccp(35, 35));
		[mark visit];
		chamber = yellowChamberPrototypes[chamberRotationCache[topology[curPos.x][curPos.y][curPos.z]][logic.rotation]-1];
		chamber.position = ccpAdd(positionCache[rotCurPos.x][rotCurPos.y][rotCurPos.z],ccp(50, 50));
		[chamber visit];
	}
	[mazeTexture end];
}

-(double) getCompassAngle {
	FS3DPoint rotCurPos = [HPPositionUtil rotatePoint:logic.gameState.currentPosition by:logic.rotation withSize:mazeSize];
	FS3DPoint rotEnd = [HPPositionUtil rotatePoint:point3D(mazeSize-1, mazeSize-1, mazeSize-1) by:logic.rotation withSize:mazeSize];
	CGPoint position = ccpAdd(positionCache[rotCurPos.x][rotCurPos.y][rotCurPos.z],ccp(35, 35));
	CGPoint vector = ccpSub(ccpAdd(positionCache[rotEnd.x][rotEnd.y][rotEnd.z],ccp(35, 35)),position);
	int corrector = (vector.x < 0) ? -1 : 1;
	return CC_RADIANS_TO_DEGREES(corrector * ccpAngle(ccp(0,1), vector));
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
	for (int i=0; i<64; i++) {
		free(chamberRotationCache[i]);
	}
	free(chamberRotationCache);
	free(pinkChamberPrototypes);
	free(yellowChamberPrototypes);
	free(greenChamberPrototypes);
	free(redChamberPrototypes);
	[outerNEFilledPrototype release];
	[outerNEWiredPrototype release];
	[outerNWFilledPrototype release];
	[outerNWWiredPrototype release];
	[outerSFilledPrototype release];
	[outerSWiredPrototype release];
	[mark release];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_POSITION_CHANGED object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_VIEW_CHANGED object:nil];
	[super dealloc];
}
- (void) onViewChanged: (NSNotification*) notification {
	[self redrawMazeTexture];
}

- (CGPoint) getTranslation {
	CGPoint beginPos = [self getChamberPos: point3D(0, 0, 0)];
	CGPoint newPos = [self getChamberPos: [HPPositionUtil rotatePoint: logic.gameState.currentPosition by: logic.rotation withSize:mazeSize]];
	CGPoint translation = ccpSub(newPos,beginPos);
	return translation;
}

- (CGPoint) getDestination {
	CGPoint translation;
  translation = [self getTranslation];

	CGPoint destination = ccpAdd(translation,ccp(80,85));
	destination = ccp(-destination.x, -destination.y);
	return destination;
}

- (void) onPositionChanged: (NSNotification*) notification {	
	CGPoint destination = [self getDestination];

	[self redrawMazeTexture];
	[self stopAllActions];
	
	[self runAction: [CCEaseOut actionWithAction:
									   [CCMoveTo actionWithDuration: 1
														   position: destination]
															 rate:4]];
}

@end
