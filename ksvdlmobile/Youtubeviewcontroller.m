//
//  Youtubeviewcontroller.m
//  ksvdlmobile
//
//  Created by Arthi Subramanian on 9/21/15.
//  Copyright (c) 2015 Praveen. All rights reserved.
//

#import "Youtubeviewcontroller.h"
#import "SWRevealViewController.h"
#import "GlobalConstants.h"
#import "AFNetworking.h"

@interface Youtubeviewcontroller ()

@end

@implementation Youtubeviewcontroller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    // UIBarButtonItem *backBtn =[[UIBarButtonItem alloc]initWithTitle:@"HOME" style:UIBarButtonItemStyleDone target:self action:@selector(popToRoot:)];
    UIImage *temp = [[UIImage imageNamed:@"home"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *backBtn =[[UIBarButtonItem alloc]initWithImage:temp style:UIBarButtonItemStyleDone target:self action:@selector(popToRoot:)];
    self.navigationItem.leftBarButtonItem=backBtn;
    
    _barButton.target = self.revealViewController;
    _barButton.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.revealViewController.panGestureRecognizer.enabled=YES;
    [self.barButton setTarget: self.revealViewController];
    [self.barButton setAction: @selector( rightRevealToggle: )];
    
    NSLog(@"Youtube page called");

    // Do any additional setup after loading the view.
    if ([[AFNetworkReachabilityManager sharedManager] isReachable])
    {

    NSURL *youtubeURL = [NSURL URLWithString:kVDLYoutubeURL];
    NSURLRequest *youtuberequest = [NSURLRequest requestWithURL:youtubeURL];
    [WebView loadRequest:youtuberequest];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Please verify your internet connection and try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        //[self.navigationController popToRootViewControllerAnimated:NO];
        
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [WebView loadHTMLString:nil baseURL:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)popToRoot:(UIBarButtonItem*)sender {
    [self performSegueWithIdentifier:@"youtubewebviewtohome" sender:sender];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
