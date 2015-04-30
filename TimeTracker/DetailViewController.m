//
//  DetailViewController.m
//  TimeTracker
//
//  Created by Hijazi on 26/4/15.
//  Copyright (c) 2015 iReka Soft. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.event) {
        self.detailDescriptionLabel.text = [self.event.timeStamp description];
        self.textField.text = self.event.title;
    }
    
    self.datePicker.date = self.event.timeStamp;
    
}
- (IBAction)updateDate:(id)sender {
    
    self.event.timeStamp = self.datePicker.date;
    self.event.title = self.textField.text;
    
    // Update the view.
    [self configureView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)touchHandler:(id)sender {

    [self.view endEditing:YES];
    
}

@end
