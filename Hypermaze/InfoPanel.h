//
//  InfoPanel.h
//  Hypermaze
//
//  Created by Jakub Gruszecki on 10.09.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "HPLogic.h"

@interface InfoPanel : CCLayer {
	HPLogic* logic;
	
	CCLabelTTF* timeElapsedLabel;
	CCLabelTTF* movesMadeLabel;
	CCLabelTTF* visitedLabel;
	CCLabelTTF* unvisitedLabel;
}

- (id) initWithLogic: (HPLogic*) newLogic;

+ (NSString*) getDateLabelText: (NSDate*) date;
+ (NSString*) getTimeLabelText: (NSTimeInterval) interval;
+ (NSString*) getIntegerLabelText: (int) movesMade;
+ (NSString*) getVisitedLabelText: (int) visited total: (int) total;
+ (NSString*) getUnvisitedLabelTex: (int) visited total: (int) total;

@end
