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

@implementation HomeViewController

//Open the promotion URL
-(void)openPromotionURL :(id) sender
{
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *) sender;
    NSLog(@"Tag = %d", gesture.view.tag);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.ksvdl.org/mobileapp/index.html"]];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    _imageview.contentMode = UIViewContentModeScaleAspectFill;
     _imageview.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.ksvdl.org/mobileapp/fb-320x100.jpg"]]];
    _imageview.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openPromotionURL:)];
    tapped.numberOfTapsRequired = 1;
    [_imageview addGestureRecognizer:tapped];
  //  [tapped release];
    
    
    _barButton.target = self.revealViewController;
    _barButton.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.barButton setTarget: self.revealViewController];
    [self.barButton setAction: @selector( rightRevealToggle: )];
    
    //The following two lines should be removed after testing..This is for testing various logins...
    
    //force log out for testing
    
    //[[HttpClient sharedHTTPClient] removeTokenAndLogoutUser];
    //[AFOAuthCredential deleteCredentialWithIdentifier:kCredentialIdentifier];
//    NSLog(@"Credential  Deleted");
}

- (IBAction)testfeessite:(id)sender {
    
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://vetview2.vet.k-state.edu/LabPortal/catalog.zul"]];
    SVWebViewController *webViewController = [[SVWebViewController alloc] initWithAddress:kVDLTestFeesURL];
    [self.navigationController pushViewController:webViewController animated:YES];
    
}
- (IBAction)ksvdlvideos:(id)sender {
    
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.youtube.com/channel/UCtx-lIIXqj5PAMQYryXaRhA"]];
    
    SVWebViewController *webViewController = [[SVWebViewController alloc] initWithAddress:kVDLYoutubeURL];
    [self.navigationController pushViewController:webViewController animated:YES];
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
