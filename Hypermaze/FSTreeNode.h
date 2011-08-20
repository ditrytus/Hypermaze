//
//  FSTreeNode.h
//  Hypermaze
//
//  Created by Jakub Gruszecki on 19.08.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSTreeNode : NSObject {
	FSTreeNode* parent;
	NSMutableArray* children;
}

@property(readwrite, retain) FSTreeNode* parent;
@property(readwrite, retain) NSMutableArray* children;

- (id)initWithParent: (FSTreeNode*) par, ...;

@end
