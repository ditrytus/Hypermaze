//
//  HPMazeGenerator.h
//  Hypermaze
//
//  Created by Jakub Gruszecki on 22.07.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HPMaze.h"

@interface HPMazeGenerator : NSObject

+ (HPMaze*) generateMazeInSize: (int) size;

@end
