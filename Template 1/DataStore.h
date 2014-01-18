//
//  Created by Rafael on 01/18/14.
//  based on Brice's CoreData training at pluralsight


#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DataStore : NSObject {
    NSManagedObjectModel *model;
}

@property (nonatomic, strong) NSManagedObjectContext *storeContext;
+ (id)sharedInstance;
- (void)save;

@end
