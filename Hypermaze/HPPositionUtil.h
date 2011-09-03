//
//  HPPositionUtil.h
//  Hypermaze
//
//  Created by Jakub Gruszecki on 03.09.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FS3DPoint.h"

@interface HPPositionUtil : NSObject

+ (FS3DPoint) rotatePoint: (FS3DPoint)point by: (int) rot withSize: (int) size;

@end
