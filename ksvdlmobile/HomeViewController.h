//
//  HomeViewController.h
//  ksvdlmobile
//
//  Created by Praveen on 5/20/15.
//  Copyright (c) 2015 Praveen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"

@interface HomeViewController : UIViewController
- (IBAction)submitTap:(id)sender;

@property (nonatomic, weak) IBOutlet UIImageView *imageview;
@property (weak,nonatomic) IBOutlet UIBarButtonItem *barButton;

@end
