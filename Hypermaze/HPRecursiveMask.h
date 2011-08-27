//
//  HPRecursiveMask.h
//  Hypermaze
//
//  Created by Jakub Gruszecki on 21.08.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HPArrayMask.h"
#import "HPGameState.h"
#import "HPMaze.h"
#import "HPLeveled.h"

@interface HPRecursiveMask : HPArrayMask <HPMoveHandler, HPLeveled> {
	HPGameState* gameState;
	HPMaze* maze;
	int maxDepth;
}

- (void) refresh;
- (void) visitChamber: (FS3DPoint) position depth: (int) depth;
- (id) initWithGameState: (HPGameState*) state maze: (HPMaze*) mazeParam depth: (int) d;

@end
