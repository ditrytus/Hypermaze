//
//  MultiDimensional.h
//  Hypermaze
//
//  Created by Jakub Gruszecki on 23.07.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FS3DPoint.h"
#import "FS3DSize.h"

@interface NSMutableArray (MultiDimensional)

- (id) get3Dsize: (FS3DSize)size position: (FS3DPoint)position;
- (id) get3Dposition: (FS3DPoint)position;

- (void) set3Dsize: (FS3DSize)size position: (FS3DPoint)position value:(id)val;
- (void) set3Dposition: (FS3DPoint)position value: (id)val ;

@end
