//
//  KSVDLWebViewController.m
//  ksvdlmobile
//
//  Created by Arthi Subramanian on 9/18/15.
//  Copyright (c) 2015 Praveen. All rights reserved.
//

#import "KSVDLWebViewController.h"
#import "SWRevealViewController.h"

@interface KSVDLWebViewController ()

@end

@implementation KSVDLWebViewController

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
    
    // Do any additional setup after loading the view.
//    NSURL *helppageURL = [NSURL URLWithString:@"https://vetview2.vet.k-state.edu/LabPortal/"];
//    NSURLRequest *helppagerequest = [NSURLRequest requestWithURL:helppageURL];
//    [WebView loadRequest:helppagerequest];
    NSURL *currentURL = [NSURL URLWithString:self.vdlPortalLink];
    NSURLRequest *linkRequest = [NSURLRequest requestWithURL:currentURL];
    [WebView loadRequest:linkRequest];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)popToRoot:(UIBarButtonItem*)sender {
    [self performSegueWithIdentifier:@"ksvdlwebviewtohome" sender:sender];
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
