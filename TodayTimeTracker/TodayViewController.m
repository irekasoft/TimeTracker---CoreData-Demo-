//
//  TodayViewController.m
//  TodayTimeTracker
//
//  Created by Hijazi on 26/4/15.
//  Copyright (c) 2015 iReka Soft. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import <TimeTrackerKit/TimeTrackerKit.h>

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupCoreData];
    
    [self.tableView reloadData];
    
    self.preferredContentSize = self.tableView.contentSize;
}

- (void)setupCoreData{
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
    for (Event *event in result) {
        NSLog(@"%@", event.timeStamp);
        [tempArray addObject:[event.timeStamp description]];
    }
    self.dataArray = tempArray;
    
    
    if (![[CoreDataAccess sharedInstance].managedObjectContext save:&error]) {
        
        NSLog(@" error fetching on the moc");
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

#pragma mark -- 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
    
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {

    cell.textLabel.text = self.dataArray[indexPath.row];
}


@end
