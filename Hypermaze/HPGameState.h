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

@interface HPGameState : NSObject <HPMoveHandler> {
	int movesMade;
	NSDate* lastResume;
	NSTimeInterval previousTimeElapsed;
	BOOL hasFinished;
	FS3DPoint currentPosition;
}

@property(readonly, nonatomic) int movesMade;
@property(readonly, nonatomic) FS3DPoint currentPosition;
@property(readonly, nonatomic) BOOL hasFinished;

- (NSTimeInterval) getTimeElapsed;

@end
