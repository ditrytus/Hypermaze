//
//  HPVisibilityMask.h
//  Hypermaze
//
//  Created by Jakub Gruszecki on 21.08.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FS3DPoint.h"

@interface HPVisibilityMask : NSObject<NSCoding>

- (NSNumber*) getValue: (FS3DPoint) position;

@end
