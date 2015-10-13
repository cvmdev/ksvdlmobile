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


@interface HomeViewController : UIViewController {


}
@property (weak, nonatomic) IBOutlet UIButton *accessionnumber;
@property (weak, nonatomic) IBOutlet UIButton *testfeesbutton;
@property (weak, nonatomic) IBOutlet UIButton *helpvideosbutton;

- (IBAction)submitTap:(id)sender;
- (IBAction) testFeesCatalog:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, weak) IBOutlet UIImageView *imageview;
@property (weak,nonatomic) IBOutlet UIBarButtonItem *barButton;
@property (weak, nonatomic) IBOutlet UIView *TextcontentView;

@end
