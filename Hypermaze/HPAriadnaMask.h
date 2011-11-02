//
//  HPAriadnaMask.h
//  Hypermaze
//
//  Created by Jakub Gruszecki on 26.08.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HPPathMask.h"
#import "HPMoveHandler.h"
#import "HPGameState.h"

@interface HPAriadnaMask : HPPathMask <HPMoveHandler> {
	HPGameState* gameState;
}

- (void) reset;
- (id) initWithGameState: (HPGameState*) state;

@end
