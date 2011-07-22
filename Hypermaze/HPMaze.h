//
//  HPMaze.h
//  Hypermaze
//
//  Created by Jakub Gruszecki on 22.07.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HPMaze : NSObject {
	NSArray *topology;
}

-(id)initWithTopology:(NSArray*) arrayWithTopology;

@end
