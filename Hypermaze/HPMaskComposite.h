//
//  HPMaskComposite.h
//  Hypermaze
//
//  Created by Jakub Gruszecki on 21.08.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HPVisibilityMask.h"

@interface HPMaskComposite : HPVisibilityMask {
	NSMutableArray* masks;
}
- (id)initWithMasks: (HPVisibilityMask*) firstMask, ...;

- (void) addMask: (HPVisibilityMask*) mask;
- (void) removeMask: (HPVisibilityMask*) mask;

@end
