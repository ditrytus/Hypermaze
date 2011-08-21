
//
//  HPZAxisMask.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 21.08.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HPZAxisMask.h"

@implementation HPZAxisMask

- (NSNumber*) getValue: (FS3DPoint) position {
	FS3DPoint currentPosition = gameState.currentPosition;
	return [NSNumber numberWithBool: currentPosition.z == position.z];
}

@end
