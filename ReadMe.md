# TimeTracker
## a CoreData Sampler on Objective-C

This project showcase the basic (template) of CoreData on a custom framework. 

CoreData has cool template on Xcode but doesn't cover the extensive version with other 'extensions'. 

So on this project we also cover reading CoreData on:

* WatchKit
* Today's Extension


# Extension-ability

1. First of all, we need to know where the part of your code that will be the core of accessing data. Make it as a framework.

`New > Target.. > Framework & Library > Cocoa Touch Framework`

We have it as `CoreDataAccess` with a shared instance called `sharedInstace` so you can easily call from everywhere. 

The `xcdatamodeld` need to be on TimeTrackerKit, and make sure the target membership is checked on created targets. Such as TimeTracker (main app), WatchKit app, and Today Widget.

So wherever on class, just import `#import <TimeTrackerKit/TimeTrackerKit.h>` to access the data.

2. To make CoreData extension-ability we need to turn-on 'AppGroups'. Name it 'group.yourcompany.yourapp' on each of the main app, watch kit app, and today's extension.

---------

Developed by iReka Soft in Cyberjaya (www.irekasoft.com)