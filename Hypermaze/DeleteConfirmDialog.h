//
//  DeleteConfirmDialog.h
//  Hypermaze
//
//  Created by Jakub Gruszecki on 15.09.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CCDialog.h"

#define DELETE_GAME_CONFIRMED_EVENT @"deleteGameConfirmedEvent"

@interface DeleteConfirmDialog : CCDialog {
	NSString* savedGame;
}

- (id) initWithSavedGame: (NSString*)_savedGame;

@end
