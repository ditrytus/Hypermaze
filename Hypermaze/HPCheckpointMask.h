//
//  HPCheckpointMask.h
//  Hypermaze
//
//  Created by Jakub Gruszecki on 27.08.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HPPathMask.h"
#import "HPMaze.h"
#import "HPLeveled.h"

@interface HPCheckpointMask : HPPathMask<HPLeveled> {
	int numOfCheckPoints;
	HPMaze* maze;
}

- (void) refresh;
- (id) initWithMaze: (HPMaze*) newMaze numOfCheckPoints: (int) num;

@end
