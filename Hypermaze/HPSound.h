
//
//  HPSound.h
//  Hypermaze
//
//  Created by Jakub Gruszecki on 30.10.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimpleAudioEngine.h"

#define SOUND_FOOTSTEP_TEMPLATE @"footsteps-%d.wav"
#define SOUND_MENU_SILDE	@"button-46.wav"
#define SOUND_TOGGLE		@"button-30.wav"
#define SOUND_TICK			@"button-50.wav"
#define SOUND_DOUBLE_TICK	@"button-49.wav"
#define SOUND_APPLAUSE		@"applause.wav"
#define SOUND_GONG			@"gong.wav"
#define SOUND_FIREWORKS		@"fireworks.wav"
#define SOUND_WINE_GLASS	@"wine-glass.wav"

#define MUSIC_SKIN				@"skin.mp3"
#define MUSIC_AIRSPACE			@"airspace.mp3"
#define MUSIC_ROMANTIC_SUNSET	@"romantic-sunset.mp3"
#define MUSIC_DRIFTING_AWAY		@"drifting-away.mp3"
#define MUSIC_REMOTE_FEELINGS	@"remote-feelings.mp3"

#define MUSIC_SKIN_DURATION				10
#define MUSIC_AIRSPACE_DURATION			10
#define MUSIC_ROMANTIC_SUNSET_DURATION	10
#define MUSIC_DRIFTING_AWAY_DURATION	10
#define MUSIC_REMOTE_FEELINGS_DURATION	10

#define TOTAL_STEPS 14

@interface HPSound : NSObject<CDLongAudioSourceDelegate> {
	int stepNum;
	NSArray* playlist;
	int currentTrack;
	SimpleAudioEngine* engine;
	CDLongAudioSource* currentMusic;
}

+ (HPSound*) sharedSound;

- (void) preloadSounds;
- (void) playFootstep;
- (void) playSound: (NSString*) soundName;
- (void) playMainMenuPlaylist;
- (void) playMusic;
- (void) stopMusic;
- (void) playMainMenuPlaylist;
- (void) playGamePlaylist;

@end
