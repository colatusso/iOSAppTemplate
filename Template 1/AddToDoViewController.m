//
//  AddToDoViewController.m
//  iOSAppTemplate
//
//  Created by Rafael on 06/12/13.
//  Copyright (c) 2013 Rafael Colatusso. All rights reserved.
//

#import "AddToDoViewController.h"

@interface AddToDoViewController ()

@end

@implementation AddToDoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textField.delegate = self;
	// Do any additional setup after loading the view.
}

#pragma mark -
#pragma mark TextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string  isEqual: @""]) {
        return YES;
    } else if ([textField.text length] > 24){
        return NO;
    }
    else return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [self.textField resignFirstResponder];
    return YES;
}

#pragma mark -
#pragma Helper methods

- (IBAction)saveOnParse:(id)sender {
    if ([self.textField.text length] > 0) {
        self.todoObject = [PFObject objectWithClassName:@"ToDoList"];
        self.todoObject[@"text"] = self.textField.text;
        [self.todoObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ToDoDataUpdated"
                                                                    object:self];   
            }
        }];
    }
}

@end
