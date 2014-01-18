//
//  ListViewController.m
//  Template 1
//
//  Created by Rafael on 05/12/13.
//  Copyright (c) 2013 Rafael Colatusso. All rights reserved.
//

#import "ListViewController.h"
#import "MenuTableViewController.h"
#import "DataStore.h"
#import "ToDoList.h"

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
    
    ToDoList *object = [self.toDoArray objectAtIndex:indexPath.row];
    cell.textLabel.text =  object.text;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // delete the row from parse and fade out the cell
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    PFObject *object = [PFObject objectWithoutDataWithClassName:@"ToDoList" objectId:[[self.toDoArray objectAtIndex:indexPath.row] objectId]];
    // we need to save the objectId before deleting it from parse
    __block NSString *toDeleteId = [object objectId];
    [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [UIView animateWithDuration:1.0f animations:^{
                cell.alpha = 0;
            } completion:^(BOOL finished) {
                DataStore *dataStore = [DataStore sharedInstance];
                NSManagedObjectContext *context = [dataStore storeContext];
                NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ToDoList"];
                request.predicate = [NSPredicate predicateWithFormat:@"objectId == %@", toDeleteId];
                NSArray *toDelete = [context executeFetchRequest:request error:nil];
                [context deleteObject:toDelete[0]];
                [context save:nil];
                [self reloadDataFromParse];                
            }];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to connect to parse" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
    cell.selected = NO;
    
}

#pragma mark -
#pragma mark Helper methods

- (void)reloadDataFromParse {
    // The sync work in both ways, add or remove an object at parse's backend and
    // the change will reflect locally, if you add or remove in the app
    // the change will reflect at parse's backend.
    // It works with insert and delete, I'm already working on the "update".
    
    // let´s start by syncing the local data with parse
    self.toDoArray = [NSArray array];
    DataStore *dataStore = [DataStore sharedInstance];
    NSManagedObjectContext *context = [dataStore storeContext];

    // load the locally data first and displaying it
    NSFetchRequest *newRequest = [NSFetchRequest fetchRequestWithEntityName:@"ToDoList"];
    self.toDoArray = [context executeFetchRequest:newRequest error:nil];
    
    [self.tableView reloadData];
    
    // then sync with parse and reload the tableview
    NSFetchRequest *idRequest = [NSFetchRequest fetchRequestWithEntityName:@"ToDoList"];
    [idRequest setPropertiesToFetch:[NSArray arrayWithObjects:@"objectId", nil]];
    NSMutableArray *idArray = [[context executeFetchRequest:idRequest error:nil] valueForKey:@"objectId"];
    NSMutableArray *toCompareArray = [NSMutableArray array];
    
    self.query = [PFQuery queryWithClassName:@"ToDoList"];
    [self.query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error) {
            for (PFObject *tmp in objects) {
                [toCompareArray addObject:[tmp objectId]];

                if (![idArray containsObject:[tmp objectId]]) {
                    ToDoList *newToDo = [NSEntityDescription insertNewObjectForEntityForName:@"ToDoList"
                                                                      inManagedObjectContext:context];
                    newToDo.objectId = [tmp objectId];
                    newToDo.text = [tmp objectForKey:@"text"];
                    
                    NSError *storeError;
                    [context save:&storeError];
                }
            }
            // if you have removed an object directly on parse, we have to remove it locally
            for (NSString *toDeleteId in idArray) {
                if (![toCompareArray containsObject:toDeleteId]) {
                    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ToDoList"];
                    request.predicate = [NSPredicate predicateWithFormat:@"objectId == %@", toDeleteId];
                    NSArray *toDelete = [context executeFetchRequest:request error:nil];
                    [context deleteObject:toDelete[0]];
                    [context save:nil];
                }
            }
            
            // reload the tableview with the new data
            NSFetchRequest *newRequest = [NSFetchRequest fetchRequestWithEntityName:@"ToDoList"];
            self.toDoArray = [context executeFetchRequest:newRequest error:nil];
            [self.tableView reloadData];
            
        }
    }];
}

-(void)handleUpdatedData:(NSNotification *)notification {
    // when notificated reload the data
    [self reloadDataFromParse];
}

@end
