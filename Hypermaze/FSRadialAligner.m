//
//  FSRadialAligner.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 19.08.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FSRadialAligner.h"
#import "cocos2d.h"
#include <math.h>

@implementation FSRadialAligner

@synthesize radius;

- (id)initWithAngle: (double) ang radius: (double) rad margin: (double) marg root: (NSMutableArray*) rt
{
    self = [super init];
    if (self) {
		angle = ang;
		radius = rad;
		root = [rt retain];
		margin = marg;
    }
    
    return self;
}

- (float) getRadiusDeltaForIndex: (NSIndexPath*) index level: (int) level {
	int currentLevel = [index length];
	float radiusDelta = radius * (level - currentLevel);
	return radiusDelta;
}

- (CGPoint) alignElementOnIndex: (NSIndexPath*) index radiusDelta: (double) rad marginDelta: (double) marg {
	CGPoint center = ccp(0,0);
	float levelAngle = 0;
	float baseAngle = (M_PI - angle)/2.0f;
	float resultAngle = M_PI / 2.0f;
	CGPoint position = center;
	NSUInteger previousIndex = 0;
	NSUInteger elementIndex = 0;
	NSMutableArray* currentArray = nil;
	for (int i=0; i<(int)[index length]; i++) {
		bool isLast = i == (int)[index length]-1;
		bool isFirst = i == 0;
		previousIndex = elementIndex;
		elementIndex = [index indexAtPosition:i];
		float currentRadius = radius * (i+1);
		CGPoint basePoint = ccp(-(currentRadius  + (isLast ? rad : 0)), 0);
		if (currentArray == nil) {
			currentArray = root;
		} else {
			currentArray = (NSMutableArray*)[currentArray objectAtIndex:previousIndex];
		}
		int itemsOnLevel = [currentArray count];
		float marginAngle;
		if (isFirst) {
			marginAngle = angle / (itemsOnLevel - 1);
		} else {
			marginAngle = (margin + (isLast ? marg : 0)) / currentRadius;
		}
		levelAngle = marginAngle * (itemsOnLevel - 1);
		float beginAngle = resultAngle - levelAngle / 2.0f;
		float endAngle = resultAngle + levelAngle / 2.0f;
		if (endAngle > baseAngle + angle) {
			beginAngle = baseAngle + angle - levelAngle;
		}
		if (beginAngle < baseAngle) {
			beginAngle = baseAngle;
		}
		resultAngle = beginAngle + marginAngle * elementIndex;
		position = ccpRotateByAngle(basePoint, center, -resultAngle);
	}
	return position;
}

- (CGPoint) alignElementOnIndex: (NSIndexPath*) index
{
	return [self alignElementOnIndex:index radiusDelta:0 marginDelta:0];
}

- (void) dealloc {
	[root release];
	[super dealloc];
}

@end
