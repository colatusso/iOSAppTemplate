//
//  MenuTableViewController.m
//  Template 1
//
//  Created by Rafael on 05/12/13.
//  Copyright (c) 2013 Rafael Colatusso. All rights reserved.
//

#import "MenuTableViewController.h"

@interface MenuTableViewController ()

@end

@implementation MenuTableViewController

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
    
    self.menuOptions = [NSArray arrayWithObjects:@"ToDo list", @"Location", @"Video", @"About", nil];
    self.tableView.backgroundColor = [UIColor darkGrayColor];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleUpdatedData:)
                                                 name:@"ToDoDataUpdated"
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // define screen size
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.screenWidth = screenRect.size.width;
    self.screenHeight = screenRect.size.height;
    
    self.view.frame = CGRectMake(-(self.view.frame.size.width * 0.8), 0, self.view.frame.size.width * 0.8, self.view.frame.size.height);

    // instantiate the controllers 
    [self instantiateControllers];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [self.menuOptions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MenuCell";
    
    CustomMenuCell *customCell = (CustomMenuCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!customCell) {
        customCell = [[CustomMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    customCell.info.text = [self.menuOptions objectAtIndex:indexPath.row];

    switch (indexPath.row) {
        case 0:
            customCell.imageView.image = [UIImage imageNamed:@"book"];
            break;
        case 1:
            customCell.imageView.image = [UIImage imageNamed:@"globe"];
            break;
        case 2:
            customCell.imageView.image = [UIImage imageNamed:@"youtube"];
            break;
        default:
            customCell.imageView.image = [UIImage imageNamed:@"user"];
            break;
    }
    
    return customCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self removeSubviews];
    
    self.navigationItem.rightBarButtonItem = nil;
    
    switch (indexPath.row) {
        case 0:
            [self initListViewController];
            break;
        case 1:
            [self initLocationViewController];
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark Helper methods

- (void)instantiateControllers {
    // ToDo methods
    self.listViewController.view.tag = 999;
    self.listViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                               instantiateViewControllerWithIdentifier:@"ListViewController"];
    self.listViewController.view.frame = CGRectMake((self.screenWidth * 0.8), 0, self.screenWidth, self.screenHeight);
    [self.view addSubview:self.listViewController.view];
    [UIView animateWithDuration:0.5f animations:^{
        self.view.frame = CGRectMake(-(self.screenWidth * 0.8), 0, (self.screenWidth * 0.8) + self.screenWidth, self.screenHeight);
    }];
    
    // Location methods
    self.locationViewController.view.tag = 999;
    self.locationViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                                   instantiateViewControllerWithIdentifier:@"LocationViewController"];
}

- (void)initListViewController {
    // load todo view controller
    self.listViewController.view.tag = 999;
    self.listViewController.view.frame = CGRectMake((self.screenWidth * 0.8), 0, self.screenWidth, self.screenHeight);
    [self.view addSubview:self.listViewController.view];
    [UIView animateWithDuration:0.5f animations:^{
        self.view.frame = CGRectMake(-(self.screenWidth * 0.8), 0, (self.screenWidth * 0.8) + self.screenWidth, self.screenHeight);
    }];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                               target:self
                                                                               action:@selector(addToDo)];
    [addButton setTintColor:[UIColor blackColor]];
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)initLocationViewController {
    // load location view controller
    self.locationViewController.view.tag = 999;
    self.locationViewController.view.frame = CGRectMake((self.screenWidth * 0.8), 0, self.screenWidth, self.screenHeight);
    [self.view addSubview:self.locationViewController.view];
    [UIView animateWithDuration:0.5f animations:^{
        self.view.frame = CGRectMake(-(self.screenWidth * 0.8), 0, (self.screenWidth * 0.8) + self.screenWidth, self.screenHeight);
    }];
}

- (void)addToDo {
    self.navigationItem.rightBarButtonItem = nil;
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                               target:self
                                                                               action:@selector(cancelToDoEditing)];
    [cancelButton setTintColor:[UIColor blackColor]];
    self.navigationItem.rightBarButtonItem = cancelButton;
    
    self.addToDoViewController.view.tag = 999;
    self.addToDoViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                           instantiateViewControllerWithIdentifier:@"AddToDoViewController"];
    self.addToDoViewController.view.frame = CGRectMake(self.screenWidth * 0.8, self.screenHeight, self.screenWidth, self.screenHeight);
    [self.view addSubview:self.addToDoViewController.view];
    [UIView animateWithDuration:0.5f animations:^{
        self.addToDoViewController.view.frame = CGRectMake(self.screenWidth * 0.8, 0, self.screenWidth, self.screenHeight);
    }];
}

- (void)removeSubviews {
    // remove the current subview loaded and the right bar buttom
    for (UIView *view in [self.view subviews]) {
        if (view.tag == 999) {
            [view removeFromSuperview];
        }
    }
}

- (void)cancelToDoEditing {
    [UIView animateWithDuration:0.5f animations:^{
        self.addToDoViewController.view.frame = CGRectMake(self.screenWidth * 0.8, self.screenHeight, self.screenWidth, self.screenHeight);
    } completion:^(BOOL finished) {
        [self.addToDoViewController.view removeFromSuperview];
    }];
    
    self.navigationItem.rightBarButtonItem = nil;
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                               target:self
                                                                               action:@selector(addToDo)];
    [addButton setTintColor:[UIColor blackColor]];
    self.navigationItem.rightBarButtonItem = addButton;
}

-(void)handleUpdatedData:(NSNotification *)notification {
    [self cancelToDoEditing];
}

- (IBAction)showMenu:(id)sender {
    if (self.view.frame.origin.x < 0) {
        [UIView animateWithDuration:0.5f animations:^{
            self.view.frame = CGRectMake(0, 0, (self.screenWidth * 0.8) + self.screenWidth, self.screenHeight);
        }];
    }
    else {
        [UIView animateWithDuration:0.5f animations:^{
            self.view.frame = CGRectMake(-(self.screenWidth * 0.8), 0, (self.screenWidth * 0.8) + self.screenWidth, self.screenHeight);
        }];
    }
}

@end
