//
//  HPMoveHandler.h
//  Hypermaze
//
//  Created by Jakub Gruszecki on 30.07.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HPDirection.h"

@protocol HPMoveHandler <NSObject>

- (void) handleMove: (HPDirection) dir;

@end
