//
//  CCDialog.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 15.09.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CCDialog.h"
#import "CCNode+Scaling.h"

#define ANIMATION_DURATION 0.25

@implementation CCDialog

@synthesize dialogWindow;

- (id)initWithSize: (CGSize) size
		  position: (CGPoint) point
	   closeButton: (bool) showCloseButton
	   showOverlay: (bool) showOverlay
closeOnOverlayTouch: (bool) closeOverlay
		   isModal: (bool) isModalVal
	   isDraggable: (bool) isDraggableVal
{
    self = [super init];
    if (self) {
		isModal = isModalVal;
		isDraggable = isDraggableVal;
		enabilityCache = [[NSMutableDictionary alloc] init];
		if (showOverlay) {
			CGSize winSize = [[CCDirector sharedDirector] winSize];
			CCRenderTexture* overlayBkg = [CCRenderTexture renderTextureWithWidth: winSize.width height: winSize.height];
			[overlayBkg beginWithClear:0 g:0 b:0 a:0.5];
			[overlayBkg end];
			
			overlay = [CCSprite spriteWithTexture:overlayBkg.sprite.texture];
			overlay.position = ccp(winSize.width/2.0, winSize.height/2.0);
			[overlay setOpacity:0];
			[self addChild: overlay];
		}
		closeOnTouch = closeOverlay;
        CCRenderTexture* windowBkg = [CCRenderTexture renderTextureWithWidth:size.width height:size.height];
		ccBlendFunc cornetBlendFunc = (ccBlendFunc) {GL_ONE, GL_ZERO};
		CCSprite* topLeft = [CCSprite spriteWithFile:@"top_left.png"];
		topLeft.blendFunc = cornetBlendFunc;
		topLeft.anchorPoint = ccp(0,1);
		topLeft.position = ccp(0, size.height);
		CCSprite* topRight = [CCSprite spriteWithFile:@"top_right.png"];
		topRight.blendFunc = cornetBlendFunc;
		topRight.anchorPoint = ccp(1,1);
		topRight.position = ccp(size.width, size.height);
		CCSprite* bottomRight = [CCSprite spriteWithFile:@"bottom_right.png"];
		bottomRight.blendFunc = cornetBlendFunc;
		bottomRight.anchorPoint = ccp(1,0);
		bottomRight.position = ccp(size.width, 0);
		CCSprite* bottomLeft = [CCSprite spriteWithFile:@"bottom_left.png"];
		bottomLeft.blendFunc = cornetBlendFunc;
		bottomLeft.anchorPoint = ccp(0,0);
		bottomLeft.position = ccp(0,0);
		CCSprite* middle = [CCSprite spriteWithFile:@"middle.png"];
		middle.blendFunc = cornetBlendFunc;
		middle.anchorPoint = ccp(0.5,0.5);
		middle.position = ccp(size.width/2.0,size.height/2.0);
		[middle scaleToSize:size fitType:CCScaleFitFull];
		[windowBkg begin];
		[middle visit];
		[topLeft visit];
		[topRight visit];
		[bottomRight visit];
		[bottomLeft visit];
		[windowBkg end];
		dialogWindow = [CCSprite spriteWithTexture:windowBkg.sprite.texture];
		dialogWindow.position = point;
		[dialogWindow setOpacity:0];
		dialogWindow.scale = 0.75;
		if (showCloseButton) {
			closeButton = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"close_button.png"] selectedSprite:nil target:self selector: @selector(close)];
			closeMenu = [CCMenu menuWithItems:closeButton, nil];
			closeMenu.anchorPoint = ccp(1,1);
			closeMenu.position = ccp(size.width - 10, size.height - 10);
			[dialogWindow addChild: closeMenu];
		}
		self.isTouchEnabled = YES;
		[self addChild: dialogWindow];
    }
    return self;
}

- (void) menuStatus:(BOOL)_enable node:(id)_node
{
	for (id result in ((CCNode *)_node).children) {
		if ([result isKindOfClass:[CCMenu class]]) {
			for (id result1 in ((CCMenu *)result).children) {
				if ([result1 isKindOfClass:[CCMenuItem class]]) {
					if (_enable) {
						NSString* key = [NSString stringWithFormat:@"%d",result1];
						if ([enabilityCache objectForKey:key]) {
							((CCMenuItem *)result1).isEnabled = [((NSNumber*)[enabilityCache objectForKey:key]) boolValue];
						}
					} else {
						NSString* menuItemKey = [NSString stringWithFormat:@"%d",result1, nil];
						[enabilityCache setValue:[NSNumber numberWithBool:((CCMenuItem *)result1).isEnabled ] forKey:menuItemKey];
						((CCMenuItem *)result1).isEnabled = NO;
					}
				}
			}
		}
		else
			[self menuStatus:_enable node:result];
	}
}

- (void) registerWithTouchDispatcher {
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:-100 swallowsTouches:YES];
}

- (void) openInScene: (CCScene*) newScene {
	if (scene!=nil) {
		NSLog(@"Próba otwarcia okna dialogowego gdy jest już wyświetlnone");
	}
	scene = newScene;
	if (isModal) {
		[self menuStatus:NO node:scene];
	}
	[scene addChild: self];
	[overlay runAction: [CCFadeIn actionWithDuration:ANIMATION_DURATION]];
	[dialogWindow runAction:
	 [CCSpawn actions:
	  [CCEaseBounceOut actionWithAction:
	   [CCScaleTo actionWithDuration:ANIMATION_DURATION scale:1]],
	  [CCFadeIn actionWithDuration:ANIMATION_DURATION],
	  nil]];
}

- (void) close {
	[overlay runAction:[CCFadeOut actionWithDuration:ANIMATION_DURATION]];
	[dialogWindow runAction:
	 [CCSequence actions:
	  [CCSpawn actions:
	   [CCScaleTo actionWithDuration:ANIMATION_DURATION scale:0.75],
	   [CCFadeOut actionWithDuration:ANIMATION_DURATION],
	   nil],
	  [CCCallBlock actionWithBlock:^(){
		[self removeFromParentAndCleanup: YES];
		 if (isModal) {
			 [self menuStatus:YES node:scene];
		 }
	  }],
	  nil]];
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	if (primaryTouch == nil && isDraggable) {
		primaryTouch = [touch retain];
		CGPoint touchLocation = [touch locationInView: [touch view]];
		touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
		CGPoint local = [dialogWindow convertToNodeSpace:touchLocation];
		CGRect r = dialogWindow.textureRect;
		r.origin = CGPointZero;
		if(CGRectContainsPoint( r, local )) {
			isTouchingWindow = YES;
			previousTouchPosition = touchLocation;
		}
		return YES;
	} else {
		return NO;
	}
}

- (void)ccTouchMoved: (UITouch*) touch withEvent: (UIEvent*) event {
	if (isTouchingWindow) {
		CGPoint touchLocation = [touch locationInView: [touch view]];
		touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
		dialogWindow.position = ccpAdd(dialogWindow.position, ccpSub(touchLocation,previousTouchPosition));
		previousTouchPosition = touchLocation;
	}
	
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
	if (!isTouchingWindow && closeOnTouch) {
		[self close];
	}
	isTouchingWindow = NO;
	[primaryTouch release];
	primaryTouch = nil;
}

- (void) dealloc {
	[enabilityCache release];
	[primaryTouch release];
	[super dealloc];
}

@end
