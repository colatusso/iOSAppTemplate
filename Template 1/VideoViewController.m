//
//  VideoViewController.m
//  iOSAppTemplate
//
//  Created by Rafael on 06/12/13.
//  Copyright (c) 2013 Rafael Colatusso. All rights reserved.
//

#import "VideoViewController.h"

@interface VideoViewController ()

@end

@implementation VideoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // based on http://stackoverflow.com/questions/18873203/embed-youtube-video-in-ios-app
    self.youTubeWebView.allowsInlineMediaPlayback=YES;
    
    NSString *linkObj=@"http://www.youtube.com/v/6FkWrt0b50I"; // should be "http://www.youtube.com/v/YOU_TUBE_VIDEO_ID"
    NSLog(@"linkObj1_________________%@",linkObj);
    NSString *embedHTML = @"\
    <html><head>\
    <style type=\"text/css\">\
    body {\
    background-color: transparent;color: white;}\\</style>\\</head><body style=\"margin:0\">\\<embed webkit-playsinline id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \\width=\"320\" height=\"320\"></embed>\\</body></html>";
    
    NSString *html = [NSString stringWithFormat:embedHTML, linkObj];
    [self.youTubeWebView loadHTMLString:html baseURL:nil];
}

@end
