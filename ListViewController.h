//
//  ListViewController.h
//  Template 1
//
//  Created by Rafael on 05/12/13.
//  Copyright (c) 2013 Rafael Colatusso. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ListViewController : UITableViewController
@property (strong, nonatomic) NSArray *toDoArray;
@property (strong, nonatomic) PFQuery *query;

@end
