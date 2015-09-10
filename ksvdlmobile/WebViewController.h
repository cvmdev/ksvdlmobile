//
//  WebViewController.h
//  ksvdlmobile
//
//  Created by Arthi Subramanian on 9/10/15.
//  Copyright (c) 2015 Praveen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController
{
    IBOutlet UIWebView *myWebView;
}

@property (weak,nonatomic) IBOutlet UIBarButtonItem *barButton;

@end
