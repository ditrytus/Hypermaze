//
//  HPMazeGenerator.m
//  Hypermaze
//
//  Created by Jakub Gruszecki on 22.07.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#include <stdlib.h>
#import "HPMazeGenerator.h"
#import "FS3DPoint.h"
#import "HPDirection.h"
#import "HPDirectionUtil.h"
#import "HPChamberUtil.h"

#define INVALID_POINT point3D(-1,-1,-1)
#define MOLE_MAX_LENGTH 8000

FS3DPoint getNextFreeChamber(Byte ***topology, int size) {
	for (int i=0; i<size; i++) {
		for (int j=0; j<size; j++) {
			for (int h=0; h<size; h++) {
				if (topology[i][j][h] == 0) {
					return point3D(i,j,h);
				}
			}
		}
	}
	return INVALID_POINT;
}

FS3DPoint moveInDirection(FS3DPoint currentPosition, HPDirection direction)
{
	switch(direction) {
		case dirNorth: return point3D(currentPosition.x, currentPosition.y + 1, currentPosition.z);
		case dirNorthEast: return point3D(currentPosition.x + 1, currentPosition.y, currentPosition.z);
		case dirNorthWest: return point3D(currentPosition.x, currentPosition.y, currentPosition.z + 1);
		case dirSouthEast: return point3D(currentPosition.x, currentPosition.y, currentPosition.z - 1);
		case dirSouthWest: return point3D(currentPosition.x - 1, currentPosition.y, currentPosition.z);
		case dirSouth: return point3D(currentPosition.x, currentPosition.y - 1, currentPosition.z);
	}
	return INVALID_POINT;
}

BOOL isPositionValid(FS3DPoint position, int size) {
	return position.x >= 0 && position.y >=0 && position.z >= 0 && position.x < size && position.y < size && position.z < size;
}

BOOL isChamberFree(Byte*** topology, FS3DPoint position) {
	return topology[position.x][position.y][position.z] == 0;
}

void crushWallInDirection(Byte*** top, FS3DPoint pos, HPDirection dir)
{
	top[pos.x][pos.y][pos.z] = [HPChamberUtil createPassageInDirection:dir chamber:top[pos.x][pos.y][pos.z]];
}

FS3DPoint digIntoChamber(Byte*** topology, FS3DPoint position, HPDirection direction) {
	FS3DPoint nextPosition = moveInDirection(position, direction);
	HPDirection opositeDirection = [HPDirectionUtil getOpositeDirectionTo: direction];
	crushWallInDirection(topology, position, direction);
	crushWallInDirection(topology, nextPosition, opositeDirection);
	return nextPosition;
}

Byte *** initTopology(int size) {
	Byte ***topology = (Byte***) malloc(size*sizeof(Byte**));
	for (int i=0; i<size; i++) {
		topology[i] = (Byte**) malloc(size*sizeof(Byte*));
		for (int j=0; j<size; j++) {
			topology[i][j] = (Byte*) malloc(size*sizeof(Byte));
			for (int h=0; h<size; h++) {
				topology[i][j][h] = 0;
			}
		}
	}
	return topology;
}

@implementation HPMazeGenerator

- (id) init {
    if (self = [super init]) {
		status = genBegin;
		progress = 0;
		maze = nil;
    }
    return self;
}

- (void) generateMazeInSize: (int) size {
	status = genWorking;
	Byte ***topology = initTopology(size);
	BOOL firstMole = YES;
	int totalChambers = (int)pow(size, 3);
	int diggedChambers = 1;
	int moleLength = 0;
	FS3DPoint molePosition = point3D(0, 0, 0);
	HPDirection* allDirections = [HPDirectionUtil getAllDirections];
	do {
		[NSThread sleepForTimeInterval:0.001];
		moleLength++;		
		if (!firstMole) {
			HPDirection dirToExisting;
			for (int i=0; i<DIR_TOTAL_DIRECTIONS; i++) {
				dirToExisting = allDirections[i];
				FS3DPoint visitedPosition = moveInDirection(molePosition, dirToExisting);
				if (isPositionValid(visitedPosition, size)) {
					if (!isChamberFree(topology, visitedPosition)) {
						break;
					}
				}
			}
			digIntoChamber(topology, molePosition, dirToExisting);
			diggedChambers++;
			progress = (double)diggedChambers/(double)totalChambers;
		} else {
			firstMole = NO;
		}
		
		HPDirection randomDirection = allDirections[arc4random() % DIR_TOTAL_DIRECTIONS];
		HPDirection moleDirection = randomDirection;
		BOOL canDigIntoChamber = NO;
		BOOL checkedAllDirections = NO;
		
		do {
			moleDirection = [HPDirectionUtil getNextDirection: moleDirection];
			checkedAllDirections = moleDirection == randomDirection;
			FS3DPoint nextMolePosition = moveInDirection(molePosition, moleDirection);
			canDigIntoChamber = isPositionValid(nextMolePosition, size) && isChamberFree(topology, nextMolePosition);
		} while (!canDigIntoChamber && !checkedAllDirections);
		if (canDigIntoChamber && moleLength < MOLE_MAX_LENGTH) {
			molePosition = digIntoChamber(topology, molePosition, moleDirection);
			diggedChambers++;
			progress = (double)diggedChambers/(double)totalChambers;
		} else {
			molePosition = getNextFreeChamber(topology, size);
		}
	} while (totalChambers > diggedChambers);
	maze = [[HPMaze alloc] initWithTopology: topology];
	status = genComplete;
}

- (HPMazeGeneratorState) getStatus {
	return status;
}

- (double) getProgress {
	return progress;
}

- (HPMaze*) getMaze {
	return [maze autorelease];
}

-(void)dealloc {
	[maze release];
	[super dealloc];
}

@end
