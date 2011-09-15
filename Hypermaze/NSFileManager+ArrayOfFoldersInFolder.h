//
//  NSFileManager+ArrayOfFoldersInFolder.h
//  Hypermaze
//
//  Created by Jakub Gruszecki on 09.09.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (ArrayOfFoldersInFolder)

+(NSArray*)arrayOfFoldersInFolder:(NSString*) folder;
	
@end
