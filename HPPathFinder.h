//
//  HPPathFinder.h
//  Hypermaze
//
//  Created by Jakub Gruszecki on 27.08.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FS3DPoint.h"

@interface HPPathFinder : NSObject

+ (NSArray*) findPathInTopology: (Byte***) topology size: (int) size from: (FS3DPoint) begin to: (FS3DPoint) end;

@end
