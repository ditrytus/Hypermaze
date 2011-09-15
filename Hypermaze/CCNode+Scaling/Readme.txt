After including CCNode+Scaling.h, the new scaling abilities can be accessed via the simple method. For example:


CGSize s = [[CCDirector sharedDirector] winSize];

CCSprite *background = [CCSprite spriteWithFile:@"Default.png"];
[self addChild:background];
[background setPosition:ccp(s.width/2,s.height/2)];

[background scaleToSize:s fitType:CCScaleFitAspectFit];


This will fit the Default background to the screen. In landscape mode, it will take up the entire height but the width will be scaled to maintain aspect ratio.

There are three fit types:

CCScaleFitFull - Will scale the image to fit the desired size; this will ignore aspect ratio.
CCScaleFitAspectFit - Will scale the image to take up the smallest dimension of the desired size, scaling the other dimension to maintain original aspect ratio.
CCScaleFitAspectFill - Will scale the image to take up the largest dimension of the desired size, scaling the other dimension to maintain original aspect ratio; this will clip the other dimension.