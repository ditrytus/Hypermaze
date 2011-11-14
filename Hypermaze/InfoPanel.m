//
//  InfoPanel.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 10.09.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InfoPanel.h"

@implementation InfoPanel

- (void)updateLabels {
	movesMadeLabel.string = [InfoPanel getIntegerLabelText:logic.gameState.movesMade];
	visitedLabel.string = [InfoPanel getVisitedLabelText:[logic getNumOfVisited] total: [logic getTotalChambers]];
	unvisitedLabel.string = [InfoPanel getUnvisitedLabelTex:[logic getNumOfVisited] total:[logic getTotalChambers]];
}

+ (NSString*) getDateLabelText: (NSDate*) date {
	NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:@"yyyy-MM-dd"];
	return [formatter stringFromDate:date];
}

+ (NSString*) getIntegerLabelText: (int) movesMade {
	return [NSString stringWithFormat:@"%d", movesMade, nil];
}

+ (NSString*) getVisitedLabelText: (int) visited total: (int) total {
	return [NSString stringWithFormat:@"%d (%d%%)", visited, (visited*100)/total, nil];
}

+ (NSString*) getUnvisitedLabelTex: (int) visited total: (int) total {
	return [NSString stringWithFormat:@"%d (%d%%)", total - visited, ((total - visited)*100)/total, nil];
}

- (void) updateTimeLabel {
	timeElapsedLabel.string = [InfoPanel getTimeLabelText:[logic.gameState getTimeElapsed]];
}

- (id)initWithLogic: (HPLogic*) newLogic
{
    self = [super init];
    if (self) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPositionChanged:) name:EVENT_POSITION_CHANGED object:nil];
		
		logic = [newLogic retain];
		
		CGSize size = [[CCDirector sharedDirector] winSize];
		
        CCSprite* infoPanel = [CCSprite spriteWithFile:@"info_panel.png"];
		infoPanel.anchorPoint = ccp(0,0);
		infoPanel.position = ccp((size.width - [infoPanel textureRect].size.width) / 2.0, size.height - [infoPanel textureRect].size.height);
		[self addChild: infoPanel];
		
		CCSprite* clockInfo = [CCSprite spriteWithFile:@"clock_info.png"];
		clockInfo.position = ccp(infoPanel.position.x + 37, infoPanel.position.y + [infoPanel textureRect].size.height / 2.0);
		[self addChild: clockInfo];
		
		timeElapsedLabel = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:16];
		timeElapsedLabel.position = ccp(infoPanel.position.x + 52, infoPanel.position.y + [infoPanel textureRect].size.height / 2.0);
		timeElapsedLabel.anchorPoint = ccp(0,0.5);
		timeElapsedLabel.color = ccBLACK;
		[self addChild: timeElapsedLabel];
		
		CCSprite* footInfo = [CCSprite spriteWithFile:@"foot_info.png"];
		footInfo.position = ccp(infoPanel.position.x + 145, infoPanel.position.y + [infoPanel textureRect].size.height / 2.0);
		[self addChild: footInfo];
		
		movesMadeLabel = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:16];
		movesMadeLabel.anchorPoint = ccp(0,0.5);
		movesMadeLabel.position = ccp(infoPanel.position.x + 158, infoPanel.position.y + [infoPanel textureRect].size.height / 2.0);
		movesMadeLabel.color = ccBLACK;
		[self addChild: movesMadeLabel];
		
		CCSprite* doorInfo = [CCSprite spriteWithFile:@"door_info.png"];
		doorInfo.position = ccp(infoPanel.position.x + 223, infoPanel.position.y + [infoPanel textureRect].size.height / 2.0);
		[self addChild: doorInfo];
		
		unvisitedLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"",(int)pow(logic.maze.size,3)-1, nil] fontName:@"Arial" fontSize:16];
		unvisitedLabel.anchorPoint = ccp(0,0.5);
		unvisitedLabel.position = ccp(infoPanel.position.x + 234, infoPanel.position.y + [infoPanel textureRect].size.height / 2.0);
		unvisitedLabel.color = ccBLACK;
		[self addChild: unvisitedLabel];
		
		CCSprite* doorOpenInfo = [CCSprite spriteWithFile:@"door_open_info.png"];
		doorOpenInfo.position = ccp(infoPanel.position.x + 345, infoPanel.position.y + [infoPanel textureRect].size.height / 2.0);
		[self addChild: doorOpenInfo];
		
		visitedLabel = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:16];
		visitedLabel.anchorPoint = ccp(0,0.5);
		visitedLabel.position = ccp(infoPanel.position.x + 357, infoPanel.position.y + [infoPanel textureRect].size.height / 2.0);
		visitedLabel.color = ccBLACK;
		[self addChild:visitedLabel];
		
		[self updateLabels];
		[self updateTimeLabel];
		[self schedule:@selector(updateTimeLabel) interval:1];
    }
    
    return self;
}

- (void) onPositionChanged: (NSNotification*) notification {
	[self updateLabels];
}

-(void) dealloc {
	[self unscheduleAllSelectors];
	[logic release];
	[[NSNotificationCenter defaultCenter] removeObserver: self];
	[super dealloc];
}

+ (NSString*) getTimeLabelText: (NSTimeInterval) interval {
	int hours = floor(interval / 3600);
	int minutes = floor(((int)interval % 3600) / 60);
	NSString* minutesLeadingZero = (minutes < 10 ? @"0" : @"");
	int seconds = floor((int)interval % 60);
	NSString* secondsLeadingZero = (seconds < 10 ? @"0" : @"");
	return [NSString stringWithFormat:@"%d:%@%d:%@%d", hours, minutesLeadingZero, minutes, secondsLeadingZero, seconds, nil];
}

@end
