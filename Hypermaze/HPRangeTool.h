//
//  HPRangeTool.h
//  Hypermaze
//
//  Created by Jakub Gruszecki on 27.08.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HPVisibilityMaskManipulationTool.h"
#import "HPLeveled.h"

@interface HPRangeTool : HPVisibilityMaskManipulationTool {
	int minValue;
	int maxValue;
	HPVisibilityMask<HPLeveled>* refreshableMask;
}

@property(readonly, nonatomic) int minValue;
@property(readonly, nonatomic) int maxValue;

- (id)initWithMask:(HPVisibilityMask<HPLeveled>*) managedMask composite: (HPMaskComposite*) managedComposite minValue: (int) min maxValue: (int) max initialValue: (int) val;

- (void) setValue: (int) newValue;
- (int) getValue;

@end
