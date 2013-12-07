//
//  ListViewController.m
//  Template 1
//
//  Created by Rafael on 05/12/13.
//  Copyright (c) 2013 Rafael Colatusso. All rights reserved.
//

#import "ListViewController.h"
#import "MenuTableViewController.h"

@interface ListViewController ()

@end

@implementation ListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // listen for new rows added via AddToDoViewController
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleUpdatedData:)
                                                 name:@"ToDoDataUpdated"
                                               object:nil];
    
    [self reloadDataFromParse];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self reloadDataFromParse];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.toDoArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [[self.toDoArray objectAtIndex:indexPath.row] objectForKey:@"text"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // delete the row from parse and fade out the cell
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    PFObject *object = [self.toDoArray objectAtIndex:indexPath.row];
    [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [UIView animateWithDuration:1.0f animations:^{
            cell.alpha = 0;
        } completion:^(BOOL finished) {
            [self reloadDataFromParse];
            }];

    }];
    cell.selected = NO;
    
}

#pragma mark -
#pragma mark Helper methods

- (void)reloadDataFromParse {
    // retrieve all objects from ToDoList class at Parse
    self.toDoArray = [NSArray array];
    self.query = [PFQuery queryWithClassName:@"ToDoList"];
    [self.query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error) {
            self.toDoArray = objects;
            [self.tableView reloadData];
        }
    }];
}

-(void)handleUpdatedData:(NSNotification *)notification {
    // when notificated reload the data
    [self reloadDataFromParse];
}

@end
