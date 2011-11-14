//
//  CCDialog.h
//  Hypermaze
//
//  Created by Jakub Gruszecki on 15.09.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface CCDialog : CCLayer<CCTargetedTouchDelegate> {
	CCSprite* dialogWindow;
	CCSprite* overlay;
	CCMenuItem* closeButton;
	UITouch* primaryTouch;
	bool isTouchingWindow;
	bool isModal;
	bool closeOnTouch;
	bool isDraggable;
	CGPoint previousTouchPosition;
	CCMenu* closeMenu;
	NSMutableDictionary* enabilityCache;
	CCScene* scene; //Weak
}

@property(nonatomic,readonly) CCSprite* dialogWindow;

- (id)initWithSize: (CGSize) size
		  position: (CGPoint) point
	   closeButton: (bool) showCloseButton
	   showOverlay: (bool) showOverlay
closeOnOverlayTouch: (bool) closeOverlay
		   isModal: (bool) isModalVal
	   isDraggable: (bool) isDraggableVal;
- (void) openInScene: (CCScene*) scene;
- (void) close;

@end