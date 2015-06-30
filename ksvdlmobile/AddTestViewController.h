//
//  AddTestViewController.h
//  ksvdlmobile
//
//  Created by Arthi Subramanian on 6/30/15.
//  Copyright (c) 2015 Praveen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddTestViewController : UIViewController
@property (nonatomic) NSString * accessionNumber;
@property (nonatomic) NSString * ownerName;

@property (weak, nonatomic) IBOutlet UITextField *accessionTextField;
@property (weak, nonatomic) IBOutlet UITextField *ownernameTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;

@end
