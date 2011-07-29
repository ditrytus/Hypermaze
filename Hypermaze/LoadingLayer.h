//
//  LoadingLayer.h
//  Hypermaze
//
//  Created by Jakub Gruszecki on 23.07.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "HPMazeGenerator.h"

@interface LoadingLayer : CCLayer {
	HPMazeGenerator* generator;
	NSOperationQueue* aQueue;
	CCSprite *fill;
}

+(CCScene *) scene;

@end
