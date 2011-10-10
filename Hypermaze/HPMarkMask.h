//
//  HPMarkMask.h
//  Hypermaze
//
//  Created by Jakub Gruszecki on 27.08.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HPChamberMark.h"
#import "FS3DPoint.h"
#import "HPVisibilityMask.h"

@interface HPMarkMask : NSObject {
	HPVisibilityMask* untakenMask;
	HPVisibilityMask* visitedMask;
	HPVisibilityMask* ariadnaMask;
	HPVisibilityMask* checkpointMask;
	bool isEnabled;
}

@property(nonatomic, readonly) bool isEnabled;

- (id)initWithUntaken: (HPVisibilityMask*) untaken visited: (HPVisibilityMask*) visited ariadna: (HPVisibilityMask*)  ariadna checkpoint: (HPVisibilityMask*) checkpoint;
- (HPChamberMark) getValue: (FS3DPoint) position;
- (void) toggle;

@end
