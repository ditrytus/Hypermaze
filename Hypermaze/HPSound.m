//
//  HPSound.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 30.10.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HPSound.h"

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
		stepNum = 0;
		currentTrack = 0;
		engine = [SimpleAudioEngine sharedEngine];
		engine.backgroundMusicVolume = 0.25f;
    }
    return self;
}

- (void) preloadSounds {
	for (int i=1; i<=TOTAL_STEPS; i++) {
		[engine preloadEffect:[NSString stringWithFormat:SOUND_FOOTSTEP_TEMPLATE, i]];
	}
	[engine preloadEffect: SOUND_MENU_SILDE];
	[engine preloadEffect: SOUND_TOGGLE];
	[engine preloadEffect: SOUND_TICK];
	[engine preloadEffect: SOUND_DOUBLE_TICK];
	[engine preloadEffect: SOUND_APPLAUSE];
	[engine preloadEffect: SOUND_GONG];
	[engine preloadEffect: SOUND_FIREWORKS];
	[engine preloadEffect: SOUND_WINE_GLASS];
}

- (void) playFootstep {
	[self playSound: [NSString stringWithFormat:SOUND_FOOTSTEP_TEMPLATE, (stepNum++)+1]];
	stepNum %= TOTAL_STEPS;
}

- (void) playSound: (NSString*) soundName {
	if (![[[HPConfiguration sharedConfiguration] sound] boolValue]) {
		[engine playEffect: soundName];
	}
}

- (void) playMusic {
	if (![[[HPConfiguration sharedConfiguration] music] boolValue]) {
		[currentMusic release];
		currentMusic = [[[CDAudioManager sharedManager] audioSourceLoad:[playlist objectAtIndex: currentTrack] channel:kASC_Right] retain];
		currentMusic.delegate = self;
		[currentMusic play];
		currentTrack++;
		currentTrack %= [playlist count];
	}
}

- (void) cdAudioSourceDidFinishPlaying:(CDLongAudioSource *) audioSource {
	[self playMusic];
}

- (void) stopMusic {
	[currentMusic pause];
}

- (void) playMainMenuPlaylist {
	[engine stopBackgroundMusic];
	currentTrack = 0;
	[playlist release];
	playlist = [[NSArray arrayWithObjects:MUSIC_SKIN, nil] retain];
	[self playMusic];
}

- (void) playGamePlaylist {
	[engine stopBackgroundMusic];
	currentTrack = 0;
	[playlist release];
	NSMutableArray* tempPlaylist = [NSMutableArray arrayWithObjects: MUSIC_AIRSPACE, MUSIC_DRIFTING_AWAY, MUSIC_REMOTE_FEELINGS, MUSIC_ROMANTIC_SUNSET, nil];
	for (int i=0; i<[tempPlaylist count]; i++) {
		int index1 = arc4random() % [tempPlaylist count];
		int index2 = arc4random() % [tempPlaylist count];
		NSString* helpString = [tempPlaylist objectAtIndex: index1];
		[tempPlaylist replaceObjectAtIndex: index1
								withObject: [tempPlaylist objectAtIndex:index2]];
		[tempPlaylist replaceObjectAtIndex: index2
							   withObject : helpString];
	}
	playlist = [tempPlaylist retain];
	[self playMusic];
}

- (void) dealloc {
	[playlist release];
	[engine release];
	[currentMusic release];
	[super dealloc];
}

@end
