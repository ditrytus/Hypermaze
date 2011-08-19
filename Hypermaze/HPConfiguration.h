//
//  HPConfiguration.h
//  Hypermaze
//
//  Created by Jakub Gruszecki on 29.07.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HPConfiguration : NSObject {
    NSNumber *music;
    NSNumber *sound;
	NSNumber *difficulty;
}

@property (copy, nonatomic) NSNumber *music;
@property (copy, nonatomic) NSNumber *sound;
@property (copy, nonatomic) NSNumber *difficulty;

- (void) save;

+ (HPConfiguration*) sharedConfiguration;

@end