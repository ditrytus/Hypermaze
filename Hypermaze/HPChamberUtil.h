//
//  NSChamberUtil.h
//  Hypermaze
//
//  Created by Jakub Gruszecki on 22.07.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HPDirection.h"

@interface HPChamberUtil : NSObject

+ (BOOL) canGoInDirection: (HPDirection) direction fromChamber: (Byte) chamber;
+ (Byte) createPassageInDirection: (HPDirection) direction chamber: (Byte) chamber;

@end
