//
//  InterfaceController.h
//  TimeTracker WatchKit Extension
//
//  Created by Hijazi on 26/4/15.
//  Copyright (c) 2015 iReka Soft. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import "TableViewController.h"
#import <CoreData/CoreData.h>

@interface InterfaceController : WKInterfaceController 

@property (weak, nonatomic) IBOutlet WKInterfaceTable *interfaceTable;
@property (strong) NSArray *dataArray;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
