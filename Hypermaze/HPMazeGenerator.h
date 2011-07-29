//
//  HPMazeGenerator.h
//  Hypermaze
//
//  Created by Jakub Gruszecki on 22.07.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HPMaze.h"

typedef enum {
	genBegin,
	genWorking,
	genComplete
} HPMazeGeneratorState;

@interface HPMazeGenerator : NSObject {
	HPMazeGeneratorState status;
	HPMaze *maze;
	double progress;
}

- (void) generateMazeInSize: (int) size;
- (HPMazeGeneratorState) getStatus;
- (double) getProgress;
- (HPMaze*) getMaze;

@end
