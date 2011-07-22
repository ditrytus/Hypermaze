//
//  NSChamberUtil.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 22.07.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HPChamberUtil.h"

@implementation HPChamberUtil

+ (BOOL) canGoInDirection: (HPDirection) direction fromChamber: (Byte) chamber {
	return (direction & chamber) > 0;
}

+ (Byte) createPassageInDirection: (HPDirection) direction chamber: (Byte) chamber {
	return (chamber | direction);
}

@end
