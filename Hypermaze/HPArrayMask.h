//
//  HPArrayMask.h
//  Hypermaze
//
//  Created by Jakub Gruszecki on 21.08.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HPVisibilityMask.h"

@interface HPArrayMask : HPVisibilityMask {
	int arraySize;
	bool*** array;
}

- (id)initWithSize: (int) size;
- (void) clearArray;

@end
