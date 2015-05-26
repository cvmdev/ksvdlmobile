//
//  ViewController.h
//  ksvdlmobile
//
//  Created by Praveen on 4/27/15.
//  Copyright (c) 2015 Praveen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthAPIClient.h"


@interface LoginViewController : UIViewController<UITextFieldDelegate>

+ (void) showAlert:(NSString *)alertMessage;
@property (weak, nonatomic) IBOutlet UITextField *userText;
@property (weak, nonatomic) IBOutlet UITextField *userPwd;

- (IBAction)loginBtn:(id)sender;

@end

