//
//  HPMaze.h
//  Hypermaze
//
//  Created by Jakub Gruszecki on 22.07.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HPMaze : NSObject {
	Byte ***topology;
	int size;
}

-(id)initWithTopology:(Byte ***) arrayWithTopology;

@end
