//
//  DataStore.h
//  RareBuys
//
//  Created by Brice Wilson on 10/15/13.
//  Copyright (c) 2013 Brice Wilson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DataStore : NSObject {
    NSManagedObjectModel *model;
}

@property (nonatomic, strong) NSManagedObjectContext *storeContext;
+ (id)sharedInstance;
- (void)save;

@end
