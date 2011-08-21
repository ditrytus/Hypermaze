//
//  HPVisibilityMaskManipulationTool.h
//  Hypermaze
//
//  Created by Jakub Gruszecki on 21.08.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HPTool.h"
#import "HPMaskComposite.h"


@interface HPVisibilityMaskManipulationTool : HPTool {
	HPMaskComposite* composite;
	HPVisibilityMask* mask;
}

- (id)initWithMask:(HPVisibilityMask*) managedMask composite: (HPMaskComposite*) managedComposite;

@end
