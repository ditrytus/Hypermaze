//
//  CCNode+Scaling.h
//

#import "cocos2d.h"

typedef enum
{
	CCScaleFitFull,
	CCScaleFitAspectFit,
	CCScaleFitAspectFill,
} CCScaleFit;

@interface CCNode (Scaling)

-(void)scaleToSize:(CGSize)size fitType:(CCScaleFit)fitType;

@end