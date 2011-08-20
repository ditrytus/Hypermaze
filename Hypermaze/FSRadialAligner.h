//
//  FSRadialAligner.h
//  Hypermaze
//
//  Created by Jakub Gruszecki on 19.08.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSTreeNode.h"

@interface FSRadialAligner : NSObject {
	double angle;
	double radius;
	double margin;
	NSMutableArray* root;
}

@property(nonatomic, readwrite) double radius;

- (id)initWithAngle: (double) ang radius: (double) rad margin: (double) marg root: (NSMutableArray*) rt;
- (CGPoint) alignElementOnIndex: (NSIndexPath*) index;
- (CGPoint) alignElementOnIndex: (NSIndexPath*) index radiusDelta: (double) rad marginDelta: (double) marg;
- (float) getRadiusDeltaForIndex: (NSIndexPath*) index level: (int) level;

@end
