//
//  AddToDoViewController.h
//  iOSAppTemplate
//
//  Created by Rafael on 06/12/13.
//  Copyright (c) 2013 Rafael Colatusso. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface AddToDoViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) PFObject *todoObject;

- (IBAction)saveOnParse:(id)sender;

@end
