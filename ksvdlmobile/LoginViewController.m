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

@interface LoginViewController ()


@end
@implementation LoginViewController
//@synthesize userText=_userText;
//@synthesize userPwd=_userPwd;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userText.delegate=self;
    self.userPwd.delegate=self;
    
    // Do any additional setup after loading the view, typically from a nib.
    _barButton2.target = self.revealViewController;
    _barButton2.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.barButton2 setTarget: self.revealViewController];
    [self.barButton2 setAction: @selector( rightRevealToggle: )];
    
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *backBtn =[[UIBarButtonItem alloc]initWithTitle:@"HOME" style:UIBarButtonItemStyleDone target:self action:@selector(popToRoot:)];
    self.navigationItem.leftBarButtonItem=backBtn;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)popToRoot:(UIBarButtonItem*)sender {
    NSLog(@"Popped to root");
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)loginBtn:(id)sender {
    
       NSLog(@"The username is %@",_userText.text);
        
       if ([_userText.text length]!=0 && [_userPwd.text length]!=0)
       {
           
                   [SVProgressHUD show];
           
                    
           
                    
                    //AFOAuth2Client *oauthClient = [AFOAuth2Client clientWithBaseURL:baseURL clientID:@"vdliosapp" secret:@"somedummy"];
                    
                    [[AuthAPIClient sharedClient] authenticateUsingOAuthWithURLString:kTokenURLString username:_userText.text password:_userPwd.text scope:@"dummy"
                                                             success:^(AFOAuthCredential *credential) {
                                                                 
                                                          
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
        
                                        //    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                                        //    NSDictionary *params = @{@"grant_type":@"password",
                                        //                             @"userName":@"pravs",
                                        //                             @"password":@"pravs",
                                        //                             @"client_id":@"vdliosapp"};
                                        //    [manager POST:@"http://129.130.128.31/TestProjects/TestAuthAPI/oauth2/token" parameters:params
                                        //          success:^(AFHTTPRequestOperation *operation,id responseObject){
                                        //              NSLog(@"JSON:%@",responseObject);
                                        //          }
                                        //          failure:^(AFHTTPRequestOperation *operation,NSError * error){
                                        //             NSLog(@"Error:%@",error);
                                        //          }];
    else
    {
        [LoginViewController showAlert:@"Please Enter Both Username and Password"];
    }
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
