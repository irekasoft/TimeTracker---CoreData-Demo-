//
//  TableViewController.h
//  TimeTracker
//
//  Created by Hijazi on 26/4/15.
//  Copyright (c) 2015 iReka Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WatchKit/WatchKit.h>
@interface TableViewController : NSObject
@property (weak, nonatomic) IBOutlet WKInterfaceImage *interfaceImage;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *interfaceLabel;

@end
