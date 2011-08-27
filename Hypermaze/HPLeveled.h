//
//  HPRefreshable.h
//  Hypermaze
//
//  Created by Jakub Gruszecki on 27.08.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HPVisibilityMask.h"

@protocol HPLeveled <NSObject>

- (void) setLevel: (int) level;
- (int) getLevel;

@end
