//
//  ToDoList.h
//  iOSAppTemplate
//
//  Created by Rafael on 18/01/14.
//  Copyright (c) 2014 Rafael Colatusso. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ToDoList : NSManagedObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * objectId;

@end
