//
//  KSVDLWebViewController.h
//  ksvdlmobile
//
//  Created by Arthi Subramanian on 9/18/15.
//  Copyright (c) 2015 Praveen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSVDLWebViewController : UIViewController
{
    IBOutlet UIWebView *WebView;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;
@property NSString *vdlPortalLink;
@end
