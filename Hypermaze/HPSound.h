
//
//  HPSound.h
//  Hypermaze
//
//  Created by Jakub Gruszecki on 30.10.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SOUND_FOOTSTEP_TEMPLATE @"footsteps-%d.wav"
#define SOUND_MENU_SILDE	@"button-46.wav"
#define SOUND_TOGGLE		@"button-30.wav"
#define SOUND_TICK			@"button-50.wav"
#define SOUND_DOUBLE_TICK	@"button-49.wav"
#define SOUND_APPLAUSE		@"applause.wav"
#define SOUND_GONG			@"gong.wav"
#define SOUND_FIREWORKS		@"fireworks.wav"
#define SOUND_WINE_GLASS	@"wine-glass.wav"

#define TOTAL_STEPS 14

@interface HPSound : NSObject {
	int stepNum;
}

+ (HPSound*) sharedSound;

- (void) preloadSounds;
- (void) playFootstep;
- (void) playSound: (NSString*) soundName;

@end
