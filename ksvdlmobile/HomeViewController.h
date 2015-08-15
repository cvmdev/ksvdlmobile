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
#import <GoogleMobileAds/GoogleMobileAds.h>

@class GADBannerView,GADRequest;

@interface HomeViewController : UIViewController <GADBannerViewDelegate> {
    GADBannerView *bannerView_;
}

@property (nonatomic,strong)GADBannerView *bannerView;
-(GADRequest *)createRequest;

- (IBAction)submitTap:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, weak) IBOutlet UIImageView *imageview;
@property (weak,nonatomic) IBOutlet UIBarButtonItem *barButton;
@property (weak, nonatomic) IBOutlet UIView *TextcontentView;

@end
