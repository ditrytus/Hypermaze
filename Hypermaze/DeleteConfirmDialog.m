//
//  DeleteConfirmDialog.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 15.09.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DeleteConfirmDialog.h"
#import "MainMenuLayer.h"
#import "HPSound.h"


@implementation DeleteConfirmDialog

- (id) initWithSavedGame:(NSString*)_savedGame
{
	savedGame = [_savedGame retain];
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	CGPoint middle = ccp(winSize.width/2.0, winSize.height/2.0);
	CGSize dialogSize = CGSizeMake(320, 140);
    self = [super initWithSize: dialogSize position: middle closeButton:NO showOverlay:YES closeOnOverlayTouch:NO isModal:YES isDraggable:YES];
    if (self) {
		CCMenuItemLabel* yes = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"YES" fontName:@"Arial" fontSize:24]
														block:^(id sender){
															[self close];
															[[NSNotificationCenter defaultCenter] postNotificationName:DELETE_GAME_CONFIRMED_EVENT object:self userInfo: [NSDictionary dictionaryWithObject:savedGame forKey:@"savedGame"]];
														}];
		yes.color = ccBLACK;
		CCMenuItemLabel* no = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"NO" fontName:@"Arial" fontSize:24]
													   block:^(id sender) {
														   [[HPSound sharedSound] playSound: SOUND_TICK];
														   [self close];
													   }];
		no.color = ccBLACK;
		CCMenu* promptMenu = [CCMenu menuWithItems:yes, no, nil];
		[promptMenu alignItemsHorizontallyWithPadding:20];
		promptMenu.anchorPoint = ccp(0.5,0.5);
		promptMenu.position = ccp(dialogSize.width/2.0,dialogSize.height/2.0-30);
		[dialogWindow addChild:promptMenu];
		
		CCLabelTTF* message = [CCLabelTTF labelWithString:@"Are you sure you want to delete this game?" dimensions:CGSizeMake(280, 100) alignment:UITextAlignmentCenter lineBreakMode:UILineBreakModeWordWrap fontName:@"Arial" fontSize:20];
		message.color = ccBLACK;
		message.anchorPoint = ccp(0.5,0.5);
		message.position = ccp(dialogSize.width/2.0,dialogSize.height/2.0);
		[dialogWindow addChild:message];
    }
    
    return self;
}

- (void) dealloc {
	[savedGame release];
	[super dealloc];
}

@end
