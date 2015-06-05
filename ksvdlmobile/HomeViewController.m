//
//  HomeViewController.m
//  ksvdlmobile
//
//  Created by Praveen on 5/20/15.
//  Copyright (c) 2015 Praveen. All rights reserved.
//

#import "HomeViewController.h"
#import "AFOAuth2Client.h"
#import "SWRevealViewController.h"


@implementation HomeViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    /*  _imageview.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.vet.k-state.edu/images/development/lifelines/1501/Lifelines-banner-2015.jpg"]]];*/
    _barButton.target = self.revealViewController;
    _barButton.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
}

- (IBAction)testfeessite:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL
                                                URLWithString:@"https://vetview2.vet.k-state.edu/LabPortal/catalog.zul"]];
    
}
- (IBAction)ksvdlvideos:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL
                                                URLWithString:@"https://www.youtube.com/channel/UCtx-lIIXqj5PAMQYryXaRhA"]];
}


- (IBAction)submitTap:(id)sender {
            NSLog(@"Button tapped");
            NSString *credentialIdentifier=@"VetViewID";
            
            AFOAuthCredential  *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:credentialIdentifier];
            if ((!credential) || (credential.isExpired))
            {
                NSLog(@"User is not logged in , send to login screen");
                [self performSegueWithIdentifier:@"LoginScreen" sender:sender];
                
            }
            else
            {
                NSLog(@"User is logged in and authentication token is current");
                [self performSegueWithIdentifier:@"AccessionScreen" sender:sender];
               
            }
    
    }


@end
