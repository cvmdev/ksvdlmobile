//
//  ViewController.m
//  ksvdlmobile
//
//  Created by Praveen on 4/27/15.
//  Copyright (c) 2015 Praveen. All rights reserved.
//

#import "LoginViewController.h"


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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginBtn:(id)sender {
    
       NSLog(@"The username is %@",_userText.text);
        
       if ([_userText.text length]!=0 && [_userPwd.text length]!=0)
       {
           
       
           
                  // NSURL *baseURL = [NSURL URLWithString:@"http://129.130.128.31/TestProjects/TestAuthAPI/"];
                    
                    NSString *tokenURLString = @"http://129.130.128.31/TestProjects/TestAuthAPI/oauth2/token";
                    NSString *credentialIdentifier=@"VetViewID";
                    
                    //AFOAuth2Client *oauthClient = [AFOAuth2Client clientWithBaseURL:baseURL clientID:@"vdliosapp" secret:@"somedummy"];
                    
                    [[AuthAPIClient sharedClient] authenticateUsingOAuthWithURLString:tokenURLString username:_userText.text password:_userPwd.text scope:@"dummy"
                                                             success:^(AFOAuthCredential *credential) {
                                                                 
                                                          
                                                                 NSLog(@"Token:%@",credential.accessToken);
                                                                 [AFOAuthCredential storeCredential:credential withIdentifier:credentialIdentifier];
                                                                 
                                                                 [self performSegueWithIdentifier:@"LoginToAccessionScreen" sender:sender];
                                                                 
                                                                 //At this point show the next screen
                                                              }
                                                             failure:^(NSError *error){
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
