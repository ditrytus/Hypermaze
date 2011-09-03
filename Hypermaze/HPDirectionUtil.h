//
//  HPDirectionUtil.h
//  Hypermaze
//
//  Created by Jakub Gruszecki on 22.07.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HPDirection.h"
#import "FS3DPoint.h"

#define INVALID_POINT point3D(-1,-1,-1)

@interface HPDirectionUtil : NSObject

+ (HPDirection) rotateDirection: (HPDirection) dir by: (int) rot;
+ (HPDirection) getOpositeDirectionTo: (HPDirection) direction;
+ (HPDirection*) getAllDirections;
+ (HPDirection) getNextDirection: (HPDirection) direction;
+ (FS3DPoint) moveInDirection: (HPDirection) direction fromPoint: (FS3DPoint) currentPosition;

@end
