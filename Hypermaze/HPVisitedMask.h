//
//  HPVisitedMask.h
//  Hypermaze
//
//  Created by Jakub Gruszecki on 21.08.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HPArrayMask.h"
#import "HPMoveHandler.h"
#import "HPGameState.h"

@interface HPVisitedMask : HPArrayMask <HPMoveHandler> {
	HPGameState* gameState;
}

- (id)initWithSize: (int) size gameState:(HPGameState*) state;

@end
