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
	FSIsoSystem* grassIso = [[[FSIsoSystem alloc] initWithTileSize:TILE_SIZE mapSize:CGSizeMake(logicWidth+logicHeigth-1, logicWidth+logicHeigth-1)] autorelease];
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
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPositionChanged:) name:EVENT_ROTATED object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onViewChanged:) name:EVENT_VIEW_CHANGED object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMazeFinished:) name:EVENT_MAZE_FINISHED object:nil];
		
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
		isoSys = [[FSIsoSystem alloc] initWithTileSize: TILE_SIZE mapSize:CGSizeMake(mazeSize,mazeSize)];
		CGSize size = [[CCDirector sharedDirector] winSize];
		CGPoint middleScreen = ccp( size.width / 2 , size.height / 2 );
		CGPoint firstChamberPos = [self getChamberPos:point3D(0, 0, 0)];
		CGSize mazeTextureSize = CGSizeMake(mazeSize*(CHAMBER_TEXTURE_SIZE.width+30)+100,(CHAMBER_TEXTURE_SIZE.height+25)*mazeSize+100);
		
		CCSprite* backgroud = [self grassBackgroundWidth: TILE_SIZE.width * 10 height: TILE_SIZE.height * 10];
		for (int i=0; i<6; i++) {
			for (int j=0; j<7; j++) {
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
		
		borderTexture = [CCRenderTexture renderTextureWithWidth: mazeTextureSize.width height: mazeTextureSize.height];
		[borderTexture.sprite setBlendFunc:(ccBlendFunc){GL_ONE, GL_ONE_MINUS_SRC_ALPHA}];
		borderTexture.sprite.anchorPoint = ccp((double)firstChamberPos.x/(double)mazeTextureSize.width,1.0-((double)firstChamberPos.y/(double)mazeTextureSize.height));
		borderTexture.sprite.position = middleScreen;
		[borderTexture begin];
		for (int y=mazeSize-1; y>=0; y--) {
			for (int x=mazeSize-1; x>=0; x--) {
				outerSWiredPrototype.position = ccpAdd(positionCache[x][y][0],BORDER_S_CORRECTION_POINT);
				[outerSWiredPrototype visit];
			}
		}
		for (int z=0; z<mazeSize; z++) {
			for (int x=mazeSize-1; x>=0; x--) {
				outerNWWiredPrototype.position = ccpAdd(positionCache[x][mazeSize-1][z],BORDER_NW_CORRECTION_POINT);
				[outerNWWiredPrototype visit];
			}
		}
		for (int z=0; z<mazeSize; z++) {
			for (int y=mazeSize-1; y>=0; y--) {
				outerNEWiredPrototype.position = ccpAdd(positionCache[mazeSize-1][y][z],BORDER_NE_CORRECTION_POINT);
				[outerNEWiredPrototype visit];
			}
		}
		[borderTexture end];
		borderTexture.visible = logic.showBorders;
		
		[self redrawMazeTexture];
		[self addChild: borderTexture];
		[self addChild: mazeTexture];
    }
	[self onPositionChanged:nil];
    return self;
}

- (void) redrawMazeTexture {
	borderTexture.visible = logic.showBorders;
	FS3DPoint curPos = [[logic gameState] currentPosition];
	FS3DPoint rotCurPos = [HPPositionUtil rotatePoint:curPos by:logic.rotation withSize:mazeSize];
	HPVisibilityMask* visibilityMask = logic.visibilityMask;
	HPMarkMask* markMask = logic.markMask;
	CCSprite* chamber;
	[mazeTexture clear:0.0f g:0.0f b:0.0f a:0.0f];
	[mazeTexture begin];
	if (logic.showBorders) {
		outerSFilledPrototype.position = ccpAdd(positionCache[rotCurPos.x][rotCurPos.y][0],BORDER_S_CORRECTION_POINT);
		[outerSFilledPrototype visit];
		outerNWFilledPrototype.position = ccpAdd(positionCache[rotCurPos.x][mazeSize-1][rotCurPos.z],BORDER_NW_CORRECTION_POINT);
		[outerNWFilledPrototype visit];
		outerNEFilledPrototype.position = ccpAdd(positionCache[mazeSize-1][rotCurPos.y][rotCurPos.z],BORDER_NE_CORRECTION_POINT);
		[outerNEFilledPrototype visit];
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

- (void)launchFireworkAfterRandomTime {
	[[CCScheduler sharedScheduler] scheduleSelector:@selector(firework) forTarget:self interval:(double)(arc4random()%10)/5.0 paused:NO];
}
- (void) onMazeFinished: (NSNotification*) notification {
	CCSprite* chamber;
	[mazeTexture clear:0.0f g:0.0f b:0.0f a:0.0f];
	[mazeTexture begin];
	for (int z=0; z<mazeSize; z++) {
		for (int y=mazeSize-1; y>=0; y--) {
			for (int x=mazeSize-1; x>=0; x--) {
				FS3DPoint point = point3D(x,y,z);
				FS3DPoint rotPoint = [HPPositionUtil rotatePoint: point3D(x,y,z) by:-logic.rotation withSize:mazeSize];
				mark.position = ccpAdd(positionCache[point.x][point.y][point.z],ccp(35, 35));
				[mark visit];
				chamber = yellowChamberPrototypes[chamberRotationCache[topology[rotPoint.x][rotPoint.y][rotPoint.z]][logic.rotation]-1];
				chamber.position = ccpAdd(positionCache[point.x][point.y][point.z],ccp(50, 50));
				[chamber visit];
			}
		}
	}
	[mazeTexture end];
	CGPoint destination = ccpSub([self convertToNodeSpace:ccp(-80,-80)], ccpSub(ccpAdd(positionCache[0][0][mazeSize-1],ccp(35, 35)), ccpAdd(positionCache[0][0][0],ccp(35, 35))));
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	destination = ccpAdd(destination, ccp(winSize.width * 0.5, winSize.height * 0.5));
	[self launchFireworkAfterRandomTime];
	[mazeTexture.sprite runAction:
	 [CCEaseInOut actionWithAction:
	  [CCSpawn actions:
	   [CCMoveTo actionWithDuration:3 position:destination],
	   [CCScaleBy actionWithDuration:3 scale:1],
	   nil]
							  rate: 4.0]];
}

- (void) firework {
	[[CCScheduler sharedScheduler] unscheduleSelector:@selector(firework) forTarget:self];
	CCParticleSystem* particleSystem = [CCParticleSystemQuad particleWithFile:@"Firework.plist"];
	particleSystem.position = ccp(arc4random()%1024, arc4random()%768+300);
	[self addChild: particleSystem];
	[[HPSound sharedSound] playSound: SOUND_FIREWORKS];
	[self launchFireworkAfterRandomTime];
}


-(double) getCompassAngle {
	FS3DPoint rotCurPos = [HPPositionUtil rotatePoint:logic.gameState.currentPosition by:logic.rotation withSize:mazeSize];
	FS3DPoint rotEnd = [HPPositionUtil rotatePoint:[logic.maze getFinishPosition] by:logic.rotation withSize:mazeSize];
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
	[self unscheduleAllSelectors];
	[logic release];
	for (int x=0; x<mazeSize; x++) {
		for (int y=0; y<mazeSize; y++) {
			free(positionCache[x][y]);
		}
		free(positionCache[x]);
	}
	free(positionCache);
	for (int i=0; i<64; i++) {
		free(chamberRotationCache[i]);
		if (i<63) {
			[pinkChamberPrototypes[i] release];
			[yellowChamberPrototypes[i] release];
			[redChamberPrototypes[i] release];
			[greenChamberPrototypes[i] release];
		}
	}
	free(chamberRotationCache);
	free(pinkChamberPrototypes);
	free(yellowChamberPrototypes);
	free(greenChamberPrototypes);
	free(redChamberPrototypes);
	[isoSys release];
	[outerNEFilledPrototype release];
	[outerNEWiredPrototype release];
	[outerNWFilledPrototype release];
	[outerNWWiredPrototype release];
	[outerSFilledPrototype release];
	[outerSWiredPrototype release];
	[mark release];
	[[NSNotificationCenter defaultCenter] removeObserver: self];
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
