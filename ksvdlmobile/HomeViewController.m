//
//  HomeViewController.m
//  ksvdlmobile
//
//  Created by Praveen on 5/20/15.
//  Copyright (c) 2015 Praveen. All rights reserved.
//

#import "HomeViewController.h"
#import "SWRevealViewController.h"
#import "GlobalConstants.h"
#import "AuthAPIClient.h"
#import "HttpClient.h"
#import "SVWebViewController.h"

#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad

@implementation HomeViewController

//Open the promotion URL
-(void)openPromotionURL :(id) sender
{
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *) sender;
    NSLog(@"Tag = %d", gesture.view.tag);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.vet.k-state.edu/asp/app/app_promotion.html"]];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.scrollView.contentSize = self.TextcontentView.frame.size;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"Google Mobile Ads SDK version: %@", [DFPRequest sdkVersion]);
    
    /*The following couple of lines of code are remove the BACK botton text from the help video and test and fees page*/
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStyleDone target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem:backButton];
    
    
    
    
    UIImage *btnimages = [UIImage imageNamed:@"hpaccession"];
    CGSize buttonSize = CGSizeMake(btnimages.size.width, btnimages.size.height);
    [_accessionnumber setImage:btnimages forState:UIControlStateNormal];
    [_accessionnumber setFrame:CGRectMake(0, 0, buttonSize.width, buttonSize.height)];
    
    
    UIImage *testfeesimages = [UIImage imageNamed:@"hptestfees"];
     CGSize buttonSize2 = CGSizeMake(btnimages.size.width, btnimages.size.height);
    [_testfeesbutton setImage:testfeesimages forState:UIControlStateNormal];
   // [_testfeesbutton setContentMode:UIViewContentModeScaleAspectFit];
    [_testfeesbutton setFrame:CGRectMake(0, 0, buttonSize2.width, buttonSize2.height)];
    
    UIImage *helpvideosimages = [UIImage imageNamed:@"hphelpvideos"];
     CGSize buttonSize3 = CGSizeMake(btnimages.size.width, btnimages.size.height);
    [_helpvideosbutton setImage:helpvideosimages forState:UIControlStateNormal];
   // [_helpvideosbutton setContentMode:UIViewContentModeScaleAspectFit];
    [_helpvideosbutton setFrame:CGRectMake(0, 0, buttonSize3.width, buttonSize3.height)];
    
    

    
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.TextcontentView
                                                                      attribute:NSLayoutAttributeLeading
                                                                      relatedBy:0
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0
                                                                       constant:10];
    [self.view addConstraint:leftConstraint];
    
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.TextcontentView
                                                                       attribute:NSLayoutAttributeTrailing
                                                                       relatedBy:0
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:1.0
                                                                        constant:-10];
    [self.view addConstraint:rightConstraint];
    
    self.navigationItem.hidesBackButton = YES;
    
    //self.bannerView = [[GADBannerView alloc] initWithFrame: CGRectMake(0.0, 0.0, GAD_SIZE_320x50.width, GAD_SIZE_320x50.height)];
    
   
   /** self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
   
    
    self.bannerView.adUnitID = MyAdUnit;
    self.bannerView.delegate = self;
    [self.bannerView setRootViewController:self];
    [self.view addSubview:self.bannerView];
    [self.bannerView loadRequest:[self createRequest]]; **/
    
    
    _imageview.contentMode = UIViewContentModeScaleAspectFill;
    
    if ( IDIOM == IPAD ) {
        /* do something specifically for iPad. */
         _imageview.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.vet.k-state.edu/asp/app/Free_BQA_700px.png"]]];
    } else {
        /* do something specifically for iPhone or iPod touch. */
            _imageview.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.vet.k-state.edu/asp/app/Free_BQA_250px.png"]]];
    }
    
    _imageview.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openPromotionURL:)];
    tapped.numberOfTapsRequired = 1;
    [_imageview addGestureRecognizer:tapped];
  //  [tapped release];
    
    _barButton.target = self.revealViewController;
    _barButton.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.revealViewController.panGestureRecognizer.enabled=YES;
    [self.barButton setTarget: self.revealViewController];
    [self.barButton setAction: @selector( rightRevealToggle: )];
    
    
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInt
                               duration:(NSTimeInterval)duration {
    if (UIInterfaceOrientationIsLandscape(toInt)) {
        self.bannerView.adSize = kGADAdSizeSmartBannerLandscape;
    } else {
        self.bannerView.adSize = kGADAdSizeSmartBannerPortrait;
    }
}


-(GADRequest *) createRequest{
    GADRequest *request = [GADRequest request];
    request.testDevices = [NSArray arrayWithObjects:kGADSimulatorID, nil];
    return request;
}

-(void)adViewDidReceiveAd:(GADBannerView *)adView{
    NSLog(@"Ad Recieved");
  //  [UIView animateWithDuration:1.0 animations:^{adView.frame = CGRectMake(0.0, 350.0, adView.frame.size.width, adView.frame.size.height);
  //   }];
}



-(void)adView:(GADBannerView *)view
didFailToReceiveAdWithError:(GADRequestError *)error{
    NSLog(@"Failed Ad: %@",[error localizedFailureReason]);
}

- (IBAction) testFeesCatalog:(id)sender {
    
    NSLog(@"Test Fees is called........................");
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://vetview2.vet.k-state.edu/LabPortal/catalog.zul"]];
    if ([[AFNetworkReachabilityManager sharedManager] isReachable])
    {
//        SVWebViewController *webViewController = [[SVWebViewController alloc] initWithAddress:kVDLTestFeesURL];
//        [self.navigationController pushViewController:webViewController animated:YES];
        
        [self performSegueWithIdentifier:@"TestFeesScreen" sender:sender];
    }
    
    else
    {
        NSLog(@"Network Unreachable..display an alert to the user");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Not connected to the internet" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    
}
- (IBAction)ksvdlvideos:(id)sender {
    
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.youtube.com/channel/UCtx-lIIXqj5PAMQYryXaRhA"]];
    if ([[AFNetworkReachabilityManager sharedManager] isReachable])
    {
        SVWebViewController *webViewController = [[SVWebViewController alloc] initWithAddress:kVDLYoutubeURL];
        [self.navigationController pushViewController:webViewController animated:YES];
    }
    
    else
    {
        NSLog(@"Network Unreachable..display an alert to the user");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Not connected to the internet" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}


- (IBAction)submitTap:(id)sender {
            NSLog(@"Button tapped");
    
            
    //AFOAuthCredential  *credential = [[AuthAPIClient sharedClient] retrieveCredential];
    //if ((!credential) || (credential.isExpired))
    
    if ([[AuthAPIClient sharedClient] isSignInRequired])
    {
        NSLog(@"User is not logged in , send to login screen");
        [self performSegueWithIdentifier:@"LoginScreen" sender:sender];
        
    }
    else
    {
        NSLog(@"User is logged in and authentication token may or may not be current");
        [self performSegueWithIdentifier:@"AccessionScreen" sender:sender];
       
    }
    
}


@end
