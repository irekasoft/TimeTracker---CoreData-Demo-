//
//  SettingsVC.m
//  TimeTracker
//
//  Created by Hijazi on 24/5/15.
//  Copyright (c) 2015 iReka Soft. All rights reserved.
//

#import "SettingsVC.h"


@interface SettingsVC ()

@end

@implementation SettingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)migrate:(id)sender {
    
    [[CoreDataAccess sharedInstance] migrateiCloudStoreToLocalStore];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
