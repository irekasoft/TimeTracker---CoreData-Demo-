//
//  DetailInterfaceController.m
//  TimeTracker
//
//  Created by Hijazi on 26/4/15.
//  Copyright (c) 2015 iReka Soft. All rights reserved.
//

#import "DetailInterfaceController.h"

@interface DetailInterfaceController ()

@end

@implementation DetailInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
    
    // Configure interface objects here.
    NSString *str = (NSString *)context;
    self.interfaceLabel.text=str;
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    

}


- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



