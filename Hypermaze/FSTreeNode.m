//
//  FSTreeNode.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 19.08.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FSTreeNode.h"

@implementation FSTreeNode

@synthesize parent;
@synthesize children;

- (id)initWithParent: (FSTreeNode*) par, ...
{
    self = [super init];
    if (self) {
        parent = [par retain];
		va_list args;
		va_start(args, par);
		children = [[NSMutableArray alloc] init];
		for (FSTreeNode *arg = par; arg != nil; arg = va_arg(args, FSTreeNode*))
		{
			[children addObject: arg];
		}
		va_end(args);
    }
    return self;
}

- (void) dealloc {
	[parent release];
	[children release];
	[super dealloc];
}

@end
