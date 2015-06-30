//
//  NavigationViewController.m
//  ksvdlmobile
//
//  Created by Arthi Subramanian on 6/3/15.
//  Copyright (c) 2015 Praveen. All rights reserved.
//

#import "NavigationViewController.h"
#import "SWRevealViewController.h"
#import "LoginViewController.h"

NSString * const nCredentialIdentifier=@"VetViewID";

@interface NavigationViewController ()

@end

@implementation NavigationViewController{
    NSArray *menu;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateOnLogin:) name:@"USER_DID_LOGIN" object:nil];

   AFOAuthCredential  *credential = [self getCredential];
    if ((!credential) || (credential.isExpired))
    {
        menu=@[@"first",@"second",@"fifth"];
    }
    else
    {
        menu=@[@"first",@"second",@"third",@"fourth"];
    }
}

- (void)updateOnLogin:(NSNotification*)notification
{
    AFOAuthCredential  *credential = [self getCredential];
    if ((!credential) || (credential.isExpired))
    {
        menu=@[@"first",@"second",@"fifth"];
    }
    else
    {
        menu=@[@"first",@"second",@"third",@"fourth"];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (AFOAuthCredential *) getCredential
{
    AFOAuthCredential  *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:nCredentialIdentifier];
    return credential;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [menu count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = [menu objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
   // NSLog(@"rows:%@",indexPath);
   // NSLog(@"row:%@",[menu objectAtIndex:indexPath.row]);
    
    AFOAuthCredential  *credential = [self getCredential];
    if ((!credential) || (credential.isExpired))
    {
        NSLog(@"ATVC: Menu - This User is not logged in , send to login screen");
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    AFOAuthCredential  *credential = [self getCredential];
    if ((!credential) || (credential.isExpired))
    {
         NSLog(@"STILL LOGGED IN");
        switch(indexPath.row)
         {
            case 0: {
                //Help page
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.ksvdl.org/resources/news/newsletter/april2015/Shipping_Diagnostic_Samples_KSVDL.html"]];
                    break;
            }
            case 1:
            {
                //Feedback page
                NSLog(@"this is the link to feedback");
                break;
            }
            case 2:
            {
                //Login page
                NSLog(@"this is the login");
                [self.revealViewController.navigationController popToRootViewControllerAnimated:YES];
            }
        } //end of switch statement
    }
    else
    {
        switch(indexPath.row)
        {
            case 0: {
                //Help page
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.ksvdl.org/resources/news/newsletter/april2015/Shipping_Diagnostic_Samples_KSVDL.html"]];
                break;
            }
            case 1:
            {
                //Feedback page
                NSLog(@"this is the link to feedback");
                break;
            }
            case 2:
            {
                NSLog(@"this is the notification settings");
                break;
            }
            case 3:
            {
                //Logout Logic
               [AFOAuthCredential deleteCredentialWithIdentifier:nCredentialIdentifier];
                [self.revealViewController.navigationController popToRootViewControllerAnimated:YES];
                NSLog(@"Credential deleted successfully");
                // break;
            }
        } //end of switch statement
    }
    }



- (IBAction)ksvdlvideos1:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.youtube.com/channel/UCtx-lIIXqj5PAMQYryXaRhA"]];
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue isKindOfClass:[SWRevealViewControllerSegue class]])
        {
            SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
            swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc,UIViewController *dvc){
                UINavigationController* navController =(UINavigationController*)self.revealViewController.frontViewController;
                [navController setViewControllers:@[dvc] animated:NO];
                [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
            };
            
        }
}


@end
