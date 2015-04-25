//
//  InterfaceController.m
//  TimeTracker WatchKit Extension
//
//  Created by Hijazi on 26/4/15.
//  Copyright (c) 2015 iReka Soft. All rights reserved.
//

#import "InterfaceController.h"
#import <TimeTrackerKit/TimeTrackerKit.h>

@interface InterfaceController()

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    [self refreshCoreData];
    
}

- (void)refreshCoreData{
    
    // Configure interface objects here.
    self.managedObjectContext = [CoreDataAccess sharedInstance].managedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest new];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
    request.entity = entity;
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"timeStamp" ascending:NO];
    
    NSArray *sortDescriptors = @[sortDescriptor];
    request.sortDescriptors = sortDescriptors;
    
    NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    
    self.dataArray = @[@"sample", @"array"];
    
    NSMutableArray *tempArray = [NSMutableArray array];
    [tempArray addObject:@"Add new..."];
    for (Event *event in result) {
        NSLog(@"%@", event.timeStamp);

        [tempArray addObject:[event.timeStamp description]];
    }
    self.dataArray = tempArray;
    
    
    if (![[CoreDataAccess sharedInstance].managedObjectContext save:&error]) {
        
        NSLog(@" error fetching on the moc");
        
    }else{
        [self loadTableData];
    }
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];

}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}
- (id)contextForSegueWithIdentifier:(NSString *)segueIdentifier inTable:(WKInterfaceTable *)table rowIndex:(NSInteger)rowIndex{
    
    NSString *str = self.dataArray[rowIndex];
    return str;
}

- (void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex{
    
    NSLog(@"here %d",(int)rowIndex);
    
    if (rowIndex==0) {
        [self insertNewObject:nil];
    }
    
    
}

- (void)loadTableData{
    
    [self.interfaceTable setNumberOfRows:[self.dataArray count] withRowType:@"TableViewController"];
    
    int idx = 0;
    for (NSString *string in self.dataArray) {
        
        TableViewController *row = [self.interfaceTable rowControllerAtIndex:idx];
        [row.interfaceLabel setText:string];

        idx++;
    }
    
}


#pragma mark - new object

- (void)insertNewObject:(id)sender {
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:self.managedObjectContext];
    
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    [newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
    
    
    // Save the context.
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }else{
        [self refreshCoreData];
    }
    
    
}
@end



