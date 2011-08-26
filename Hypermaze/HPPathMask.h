//
//  HPPathMask.h
//  Hypermaze
//
//  Created by Jakub Gruszecki on 26.08.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HPVisibilityMask.h"

@interface HPPathMask : HPVisibilityMask {
	NSMutableArray* path;
}

-(NSString*) stringFromPoint: (FS3DPoint) point;
-(bool) contains: (FS3DPoint) point;
-(void)addToPath:(FS3DPoint) point;
-(void)removeFromPath:(FS3DPoint) point;

@end
