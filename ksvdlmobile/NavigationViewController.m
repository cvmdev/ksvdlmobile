//
//  NavigationViewController.m
//  ksvdlmobile
//
//  Created by Arthi Subramanian on 6/3/15.
//  Copyright (c) 2015 Praveen. All rights reserved.
//

#import "NavigationViewController.h"
#import "SWRevealViewController.h"
//#import "LoginViewController.h"
#import "GlobalConstants.h"
#import "HttpClient.h"
#import "SVWebViewController.h"



@interface NavigationViewController ()

@end

@implementation NavigationViewController{
    NSArray *menu;
    
}

- (void)loadDynamicMenu {
    if ([[AuthAPIClient sharedClient] isSignInRequired])
    {
        menu=@[@"sixth",@"first",@"second",@"fifth"];
    }
    else
    {
        menu=@[@"sixth",@"first",@"second",@"third",@"fourth"];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateOnLogin:) name:@"USER_DID_LOGIN" object:nil];
    [self loadDynamicMenu];
}


- (void)updateOnLogin:(NSNotification*)notification
{
    /*AFOAuthCredential  *credential = [self getCredential];
    if ((!credential) || (credential.isExpired))
    {
        menu=@[@"sixth",@"first",@"second",@"fifth"];
    }
    else
    {
        menu=@[@"sixth",@"first",@"second",@"third",@"fourth"];
    }*/
    [self loadDynamicMenu];
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
    AFOAuthCredential  *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:kCredentialIdentifier];
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
        NSLog(@"NVC: Menu - This User is not logged in or refresh token not valid");
    }
    cell.backgroundColor = [UIColor colorWithRed:79.0f/255.0f green:33.0f/255.0f blue:134.0f/255.0f alpha:1.0f];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds] ;
    cell.selectedBackgroundView.backgroundColor = [UIColor darkGrayColor] ;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    //AFOAuthCredential  *credential = [self getCredential];
    //if ((!credential) || (credential.isExpired))
    if ([[AuthAPIClient sharedClient] isSignInRequired])
    {
        switch(indexPath.row)
         {
             case 0:
             {
                 //Login page
                 NSLog(@"this is the home page");
                 [self.revealViewController.navigationController popToRootViewControllerAnimated:YES];
                 break;
             }
            case 1: {
                //Help page
                NSLog(@"this is the help page");
                [self.revealViewController.navigationController popToRootViewControllerAnimated:YES];
                break;
            }
            case 2:
            {
                //Feedback page
                    NSLog(@"this is the feedback page");
                 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://goo.gl/forms/OK3kc7PF2W"]];
                break;
            }
            case 3:
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
            case 0:
            {
                //Login page
                NSLog(@"this is the home page");
                [self.revealViewController.navigationController popToRootViewControllerAnimated:YES];
                break;
            }
            case 1: {
                //Help page
                NSLog(@"this is the help page");
                [self.revealViewController.navigationController popToRootViewControllerAnimated:YES];
                break;
            }
            case 2:
            {
                //Feedback page
                NSLog(@"this is the feedback page");
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://goo.gl/forms/OK3kc7PF2W"]];
                break;
            }
            case 3:
            {
                NSLog(@"this is the notification settings");
                break;
            }
            case 4:
            {
                //Logout Logic
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Logout" message:@"Log out will prevent notifications from being sent.Do you want to continue?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
                [alertView show];
             
            }
        } //end of switch statement
    }
    }
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch(buttonIndex) {
        case 0:
            //stay in current view
            break;
        case 1:
            NSLog(@"Deleting token...NVC");

            [[AuthAPIClient sharedClient] logOutWithRetryCount:kRetryCount
                                            AndCompletionBlock:^(BOOL finished){
                        if (finished)
                        {
                            [self loadDynamicMenu];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self.tableView reloadData];
                            });
                        }
                        else
                        {
                            NSLog(@"There was an issue logging out...lets handle it...");
                        }
            }];
          break;
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
