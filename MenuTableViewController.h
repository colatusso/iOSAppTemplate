//
//  MenuTableViewController.h
//  Template 1
//
//  Created by Rafael on 05/12/13.
//  Copyright (c) 2013 Rafael Colatusso. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomMenuCell.h"
#import "ListViewController.h"
#import "LocationViewController.h"
#import "VideoViewController.h"
#import "AboutViewController.h"
#import "AddToDoViewController.h"

@interface MenuTableViewController : UITableViewController
@property (strong, nonatomic) NSArray *menuOptions;
@property (assign, nonatomic) CGFloat screenWidth;
@property (assign, nonatomic) CGFloat screenHeight;
@property (strong, nonatomic) ListViewController *listViewController;
@property (strong, nonatomic) LocationViewController *locationViewController;
@property (strong, nonatomic) VideoViewController *videoViewController;
@property (strong, nonatomic) AboutViewController *aboutViewController;
@property (strong, nonatomic) AddToDoViewController *addToDoViewController;

- (IBAction)showMenu:(id)sender;
@end
