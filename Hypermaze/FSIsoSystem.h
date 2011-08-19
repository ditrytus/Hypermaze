//
//  FSIsoSystem.h
//  Hypermaze
//
//  Created by Jakub Gruszecki on 29.07.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSIsoSystem : NSObject {
	CGPoint xVertex;
	CGPoint yVertex;
	CGPoint firstPosition;
	CGSize tileSize;
	CGSize mapLogicalSize;
	CGPoint** tileCoords;
}

- (id) initWithTileSize: (CGSize)tileSize mapSize: (CGSize)mapSize;

- (CGPoint) getTileRealPosition: (CGPoint)logicPosition;

@end
