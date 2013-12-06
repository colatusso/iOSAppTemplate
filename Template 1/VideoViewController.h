//
//  VideoViewController.h
//  iOSAppTemplate
//
//  Created by Rafael on 06/12/13.
//  Copyright (c) 2013 Rafael Colatusso. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoViewController : UIViewController <UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *youTubeWebView;

@end
