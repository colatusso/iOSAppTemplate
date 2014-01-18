//
//  Created by Rafael on 01/18/14.
//  based on Brice's CoreData training at pluralsight

#import "DataStore.h"
@implementation DataStore

+ (id)sharedInstance {
    // this prevents duplicated instances and create a shared one
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
        // grabbing all the models in the project
        model = [NSManagedObjectModel mergedModelFromBundles:nil];
        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];

        NSFileManager *fm = [NSFileManager defaultManager];
        NSArray *directories = [fm URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
        NSURL *documentPath = [directories objectAtIndex:0];
        NSURL *dataStoreURL = [documentPath URLByAppendingPathComponent:@"todo.sqlite"];
        
        // creating our sqlite database
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
    // save the new data
    [_storeContext save:nil];
}

@end
