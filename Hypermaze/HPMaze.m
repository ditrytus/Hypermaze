//
//  HPMaze.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 22.07.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HPMaze.h"

@implementation HPMaze

-(id)initWithTopology:(NSArray*) arrayWithTopology {
	self = [super init];
    if (self) {
		topology = arrayWithTopology;
    }
    return self;
}

@end
