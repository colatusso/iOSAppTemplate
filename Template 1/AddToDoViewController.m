//
//  AddToDoViewController.m
//  iOSAppTemplate
//
//  Created by Rafael on 06/12/13.
//  Copyright (c) 2013 Rafael Colatusso. All rights reserved.
//

#import "AddToDoViewController.h"
#import "ToDoList.h"
#import "DataStore.h"

@interface AddToDoViewController ()

@end

@implementation AddToDoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textField.delegate = self;
}

#pragma mark -
#pragma mark TextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // max todo text length
    if ([string  isEqual: @""]) return YES; // to keep backspace working
    else if ([textField.text length] > 33) return NO;
    else return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [self.textField resignFirstResponder];
    return YES;
}

#pragma mark -
#pragma Helper methods

- (IBAction)saveOnParse:(id)sender {
    // save the new todo on parse and notificate
    if ([self.textField.text length] > 0) {
        self.todoObject = [PFObject objectWithClassName:@"ToDoList"];
        self.todoObject[@"text"] = self.textField.text;
        [self.todoObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ToDoDataUpdated"
                                                                    object:self];
            }
            
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to connect to parse" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }];
    }
}

@end
