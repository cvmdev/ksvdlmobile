//
//  AboutWebViewController.h
//  ksvdlmobile
//
//  Created by Arthi Subramanian on 9/27/15.
//  Copyright (c) 2015 Praveen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutWebViewController : UIViewController

{
    IBOutlet UIWebView *WebView;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *BarButton;
@property (weak, nonatomic) IBOutlet UILabel *text1;

@end
