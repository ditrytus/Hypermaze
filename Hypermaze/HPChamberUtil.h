//
//  NSChamberUtil.h
//  Hypermaze
//
//  Created by Jakub Gruszecki on 22.07.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HPDirection.h"
#import "FS3DPoint.h"

BOOL isPositionValid(FS3DPoint position, int size);

@interface HPChamberUtil : NSObject

+ (BOOL) canGoInDirection: (HPDirection) direction fromChamber: (Byte) chamber;
+ (BOOL) canGoInDirection: (HPDirection) direction fromChamber: (Byte) chamber currentPosition: (FS3DPoint) pos size: (int) size;
+ (Byte) createPassageInDirection: (HPDirection) direction chamber: (Byte) chamber;

@end
