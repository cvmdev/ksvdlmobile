//
//  ViewController.m
//  ksvdlmobile
//
//  Created by Praveen on 4/27/15.
//  Copyright (c) 2015 Praveen. All rights reserved.
//

#import "LoginViewController.h"
#import "SVProgressHUD.h"
#import "SWRevealViewController.h"
#import "GlobalConstants.h"
#import "HttpClient.h"
#import "AppDelegate.h"

@interface LoginViewController ()


@end
@implementation LoginViewController
//@synthesize userText=_userText;
//@synthesize userPwd=_userPwd;
//AppDelegate *appdelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]]];
    //appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.userText.delegate=self;
    self.userPwd.delegate=self;
    
    // Do any additional setup after loading the view, typically from a nib.
    _barButton2.target = self.revealViewController;
    _barButton2.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.barButton2 setTarget: self.revealViewController];
    [self.barButton2 setAction: @selector( rightRevealToggle: )];
    
    self.navigationItem.hidesBackButton = YES;
   // UIBarButtonItem *backBtn =[[UIBarButtonItem alloc]initWithTitle:@"HOME" style:UIBarButtonItemStyleDone target:self action:@selector(popToRoot:)];
    UIImage *temp = [[UIImage imageNamed:@"home"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *backBtn =[[UIBarButtonItem alloc]initWithImage:temp style:UIBarButtonItemStyleDone target:self action:@selector(popToRoot:)];
    self.navigationItem.leftBarButtonItem=backBtn;
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Did Fail to Register for Remote Notifications");
    NSLog(@"%@, %@", error, error.localizedDescription);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)popToRoot:(UIBarButtonItem*)sender {
    //[self.navigationController popToRootViewControllerAnimated:YES];
    [self performSegueWithIdentifier:@"LogintoHome" sender:sender];
}

- (IBAction)loginBtn:(id)sender {
    
    if ([UIApplication respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    
       NSLog(@"The username is %@",_userText.text);
        
       if ([_userText.text length]!=0 && [_userPwd.text length]!=0)
       {
            [SVProgressHUD show];
                    
            [[AuthAPIClient sharedClient] authenticateUsingOAuthWithURLString:kTokenURLString username:_userText.text password:_userPwd.text scope:@"dummy"
                                        success:^(AFOAuthCredential *credential) {
                                           
                                            /*Push Notifications changes begin--*/
                                        if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)])
                                                {
                                                UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
                                                [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
                                                [[UIApplication sharedApplication] registerForRemoteNotifications];
                                                    }
                                                else
                                                 {
                                                [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
                                                  }
                                                                 
                                                  [[NSNotificationCenter defaultCenter] addObserver:self
                                                    selector:@selector(tokenAvailableNotification:)
                                                    name:@"NEW_TOKEN_AVAILABLE"
                                                    object:nil];
                                            /*Push Notifications changes end--*/
                                                    NSLog(@"Token:%@",credential.accessToken);
                                                                 
                                                    [AFOAuthCredential storeCredential:credential withIdentifier:kCredentialIdentifier];
                                                                 [[HttpClient sharedHTTPClient] updateCredential:credential];
                                                                 
                                                    [SVProgressHUD dismiss];
                                                                 [self performSegueWithIdentifier:@"LoginToAccessionScreen" sender:sender];
                                                                 
                                                    NSNotification *loginNotification = [NSNotification notificationWithName:@"USER_DID_LOGIN" object:nil];
                                                                 [[NSNotificationCenter defaultCenter] postNotification:loginNotification];
                                                                 
                                                                 //At this point show the next screen
                                                              }
                                                             failure:^(NSError *error){
                                                                [SVProgressHUD dismiss];
                                                                 NSLog(@"Error:%@",error.userInfo);
                                                                 NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                                                                 NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
                                                                 NSLog(@"The dictionary has :%@",serializedData);
                                                                 if ([serializedData objectForKey:@"error_description"])
                                                                     [LoginViewController showAlert:serializedData[@"error_description"]];
                        
                                                             }];
       }
    else
    {
        [LoginViewController showAlert:@"Please Enter Both Username and Password"];
    }
}

/*On Allowing push notifications - output the device token*/
- (void)tokenAvailableNotification:(NSNotification *)notification {
    NSString *token = (NSString *)notification.object;
    NSLog(@"new token available : %@", token);
    
    
    //Lets go ahead and call the api to add the token
    
    HttpClient *client = [HttpClient sharedHTTPClient];
    
    [client addDeviceToken:token WithSuccessBlock:^(AFHTTPRequestOperation *operation,id responseObject) {
    
        if (operation.response.statusCode==200)
        {
            NSLog(@"Registration was a success....");
            //Store User DevieToken in NSUSerDefaults
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:token forKey:kVDLDeviceTokenString];
            [userDefaults synchronize];
            NSLog(@"Added to NSUserDefaults");
        }
        
    } andFailureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error while adding device token");
    }];

    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

+ (void) showAlert:(NSString *)alertMessage{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:alertMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

@end
