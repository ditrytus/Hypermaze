//
//  HPSound.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 30.10.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HPSound.h"
#import "SimpleAudioEngine.h"
#import "HPConfiguration.h"

@implementation HPSound

static HPSound *sharedSound;

+ (HPSound*) sharedSound {
	return sharedSound;
}

+ (void)initialize
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        sharedSound = [[HPSound alloc] init];
    }
}

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void) preloadSounds {
	for (int i=1; i<=TOTAL_STEPS; i++) {
		[[SimpleAudioEngine sharedEngine] preloadEffect:[NSString stringWithFormat:SOUND_FOOTSTEP_TEMPLATE, i]];
	}
	[[SimpleAudioEngine sharedEngine] preloadEffect: SOUND_MENU_SILDE];
	[[SimpleAudioEngine sharedEngine] preloadEffect: SOUND_TOGGLE];
	[[SimpleAudioEngine sharedEngine] preloadEffect: SOUND_TICK];
	[[SimpleAudioEngine sharedEngine] preloadEffect: SOUND_DOUBLE_TICK];
	[[SimpleAudioEngine sharedEngine] preloadEffect: SOUND_APPLAUSE];
	[[SimpleAudioEngine sharedEngine] preloadEffect: SOUND_GONG];
	[[SimpleAudioEngine sharedEngine] preloadEffect: SOUND_FIREWORKS];
	[[SimpleAudioEngine sharedEngine] preloadEffect: SOUND_WINE_GLASS];
}

- (void) playFootstep {
	[self playSound: [NSString stringWithFormat:SOUND_FOOTSTEP_TEMPLATE, (stepNum++)+1]];
	stepNum %= TOTAL_STEPS;
}

- (void) playSound: (NSString*) soundName {
	if (![[[HPConfiguration sharedConfiguration] sound] boolValue]) {
		[[SimpleAudioEngine sharedEngine] playEffect: soundName];
	}
}

@end
