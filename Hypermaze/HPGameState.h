//
//  HPGameState.h
//  Hypermaze
//
//  Created by Jakub Gruszecki on 30.07.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HPMoveHandler.h"
#import	"FS3DPoint.h"
#import "HPMaze.h"

@interface HPGameState : NSObject <HPMoveHandler,NSCoding> {
	int movesMade;
	NSDate* lastResume;
	NSTimeInterval previousTimeElapsed;
	NSTimeInterval finishTimeElapsed;
	BOOL hasFinished;
	FS3DPoint currentPosition;
	HPMaze* maze;
}

@property(readonly, nonatomic) int movesMade;
@property(readonly, nonatomic) FS3DPoint currentPosition;
@property(readonly, nonatomic) BOOL hasFinished;

- (id)initWithMaze: (HPMaze*) _maze;
- (NSTimeInterval) getTimeElapsed;
- (void) reset;

@end
