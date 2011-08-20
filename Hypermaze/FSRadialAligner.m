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

- (id)initWithAngle: (double) ang radius: (double) rad margin: (double) marg root: (NSMutableArray*) rt
{
    self = [super init];
    if (self) {
		angle = ang;
		radius = rad;
		root = rt;
		margin = marg;
    }
    
    return self;
}

- (CGPoint) alignElementOnIndex: (NSIndexPath*) index radiusDelta: (double) rad marginDelta: (double) marg {
	CGPoint center = ccp(0,0);
	float levelAngle = 0;
	float baseAngle = (M_PI - angle)/2.0f;
	float resultAngle = M_PI / 4.0f;
	CGPoint position = center;
	NSMutableArray* currentArray = nil;
	for (int i=0; i<[index length]; i++) {
		bool isLast = i == [index length]-1;
		bool isFirst = i == 0;
		NSUInteger elementIndex = [index indexAtPosition:i];
		float currentRadius = radius * i + (isLast ? rad : 0);
		CGPoint basePoint = ccp(-currentRadius, 0);
		if (currentArray == nil) {
			currentArray = root;
		} else {
			currentArray = [currentArray objectAtIndex:i-1];
		}
		int itemsOnLevel = [currentArray count];
		float marginAngle;
		if (isFirst) {
			marginAngle = angle / (itemsOnLevel - 1);
		} else {
			marginAngle = (margin + marg) / currentRadius;
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
		position = ccpRotateByAngle(basePoint, center, resultAngle);
	}
	return position;
}

- (CGPoint) alignElementOnIndex: (NSIndexPath*) index
{
	return [self alignElementOnIndex:index radiusDelta:0 marginDelta:0];
}

@end
