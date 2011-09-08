//
//  HPMaze.h
//  Hypermaze
//
//  Created by Jakub Gruszecki on 22.07.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HPMaze : NSObject<NSCoding> {
	Byte*** topology;
	NSArray* solution;
	int size;
}

-(id)initWithTopology:(Byte ***) arrayWithTopology size: (int)arraySize solution: (NSArray*) arraySolution;

@property (readonly, nonatomic) Byte*** topology;
@property (readonly, nonatomic) int size;
@property (readonly, nonatomic) NSArray* solution;

@end
