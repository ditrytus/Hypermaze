//
//  HPTool.h
//  Hypermaze
//
//  Created by Jakub Gruszecki on 21.08.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HPTool : NSObject {
	bool isEnabled;
}

@property(nonatomic, readonly) bool isEnabled;

- (void) toggle;
- (void) turnOn;
- (void) turnOff;

@end
