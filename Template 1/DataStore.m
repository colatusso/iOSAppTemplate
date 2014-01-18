//
//  DataStore.m
//  RareBuys
//
//  Created by Brice Wilson on 10/15/13.
//  Copyright (c) 2013 Brice Wilson. All rights reserved.
//

#import "DataStore.h"

@implementation DataStore

+(id)sharedInstance {
    
    static DataStore *sharedDataStore = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedDataStore = [[self alloc] init];
    });
    
    return sharedDataStore;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        model = [NSManagedObjectModel mergedModelFromBundles:nil];
        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];

        NSFileManager *fm = [NSFileManager defaultManager];
        NSArray *directories = [fm URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
        NSURL *documentPath = [directories objectAtIndex:0];
        NSURL *dataStoreURL = [documentPath URLByAppendingPathComponent:@"todo.sqlite"];
        
        NSError *error = nil;
        [coordinator addPersistentStoreWithType:NSSQLiteStoreType
                          configuration:nil
                                    URL:dataStoreURL
                                options:nil
                                  error:&error];

        _storeContext = [[NSManagedObjectContext alloc] init];
        [_storeContext setPersistentStoreCoordinator:coordinator];
    }
    return self;
}

- (void)save {
    
    NSError *error = nil;
    [_storeContext save:&error];
}

@end
