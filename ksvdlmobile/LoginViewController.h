//
//  ViewController.h
//  ksvdlmobile
//
//  Created by Praveen on 4/27/15.
//  Copyright (c) 2015 Praveen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthAPIClient.h"

#if USES_IASK_STATIC_LIBRARY
#import "InAppSettingsKit/IASKAppSettingsViewController.h"
#else
#import "IASKAppSettingsViewController.h"
#endif


@interface LoginViewController : UIViewController<IASKSettingsDelegate,UITextFieldDelegate>

+ (void) showAlert:(NSString *)alertMessage;
@property (weak, nonatomic) IBOutlet UITextField *userText;
@property (weak, nonatomic) IBOutlet UITextField *userPwd;
@property (weak,nonatomic) IBOutlet UIBarButtonItem *barButton2;
- (IBAction)loginBtn:(id)sender;

@end

