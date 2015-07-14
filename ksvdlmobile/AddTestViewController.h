//
//  AddTestViewController.h
//  ksvdlmobile
//
//  Created by Arthi Subramanian on 6/30/15.
//  Copyright (c) 2015 Praveen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface AddTestViewController : UIViewController
@property (nonatomic) NSString * accessionNumber;
@property (nonatomic) NSString * ownerName;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;
@property (weak, nonatomic) IBOutlet UILabel *atlabel;
@property (weak, nonatomic) IBOutlet UILabel *ownerlabel;

- (IBAction)openMail:(id)sender;

@end
