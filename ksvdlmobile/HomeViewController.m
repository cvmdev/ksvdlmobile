//
//  HomeViewController.m
//  ksvdlmobile
//
//  Created by Praveen on 5/20/15.
//  Copyright (c) 2015 Praveen. All rights reserved.
//

#import "HomeViewController.h"
#import "AFOAuth2Client.h"

@implementation HomeViewController

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
