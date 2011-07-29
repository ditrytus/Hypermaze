//
//  HPDirectionUtil.h
//  Hypermaze
//
//  Created by Jakub Gruszecki on 22.07.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HPDirection.h"

@interface HPDirectionUtil : NSObject

+ (HPDirection) getOpositeDirectionTo: (HPDirection) direction;
+ (HPDirection*) getAllDirections;
+ (HPDirection) getNextDirection: (HPDirection) direction;
@end
