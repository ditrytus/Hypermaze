# Hypermaze

Hypermaze is a 2D, isometric, iPad (only) game about finding a way through a 3D maze. There are many tools at your disposal that allow you to view, explore and analyze maze's structure.

Game was developed with Cocos2D for iPhone (very old version of it). http://www.cocos2d-iphone.org

Currently game is not available on App Store, but probably I will republish it again if I'll have some other App I would like to distribute.

## Screenshots

<img src="https://raw.githubusercontent.com/ditrytus/Hypermaze/master/Screenshots/Screenshot1.png" width="240" height="180"> <img src="https://raw.githubusercontent.com/ditrytus/Hypermaze/master/Screenshots/Screenshot2.png" width="240" height="180"> <img src="https://raw.githubusercontent.com/ditrytus/Hypermaze/master/Screenshots/Screenshot3.png" width="240" height="180"> <img src="https://raw.githubusercontent.com/ditrytus/Hypermaze/master/Screenshots/Screenshot4.png" width="240" height="180"> <img src="https://raw.githubusercontent.com/ditrytus/Hypermaze/master/Screenshots/Screenshot5.png" width="240" height="180">

## Little History

I made this project in 2011 as my first try in publishing my own game for iOS. As with many such projects I failed miserably at selling it because of many reasons, some of them being bad game design and having virtually no advertising. Years passed, I focused on my full time job, my Apple Developer subscription expired and the game was lost.

Very recently I managed to recover data from a broken external hard drive and found a long lost source code. I decided to refresh it and put it on GitHub perhaps for some other maze enthusiast enjoy.

Game was originally made for iOS 5. Luckly running it on iOS 10 required only few relatively small changes and fixes. xCode 8 screams with warnings about deprecated APIs and others, but I don't have an intention of rewriting it, my goal was only to make it run again without obvious bugs. 

## Known Issues

* Game supports only one oriantation. _There is a glitch in my super old version of Cocos2D on iOS 10 when you rotate an app, so instead of fixing a bug in an already outdated framework I made this simple workaround._
* Game Center support is removed. _I don't have paid Appe Developer account now and all achievements and other GC setup is not in place. Nobody is excited about GC anyway._
* There is no folder structure. Almost all files are in one flat directory. _I was using xCode Groups to organize project files until I realized that it's just a logical structure and not physical one. Fixing it manually is a fun for at least an hour... so please forgive me. It's been 6 years ago... just open it in xCode._