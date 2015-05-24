//
//  CoreDataAccess.h
//  TimeTracker
//
//  Created by Hijazi on 26/4/15.
//  Copyright (c) 2015 iReka Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#define ENABLE_ICLOUD NO

@interface CoreDataAccess : NSObject

+ (CoreDataAccess*)sharedInstance;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;



- (void)saveContext;


- (NSURL *)applicationDocumentsDirectory;

- (id)createEntity:(NSString *)entityForName;
- (BOOL)deleteEntity:(NSManagedObject *)entity;


#pragma mark iCloud support

- (void)migrateiCloudStoreToLocalStore;



@end
