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
@property (nonatomic) NSString * clientName;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;
@property (weak, nonatomic) IBOutlet UILabel *atlabel;
@property (weak, nonatomic) IBOutlet UILabel *ownerlabel;
@property (weak, nonatomic) IBOutlet UITextField *cltext;
@property (weak, nonatomic) IBOutlet UITextField *phtext;
@property (weak, nonatomic) IBOutlet UITextField *emailtext;
@property (weak, nonatomic) IBOutlet UITextField *testnametext;
@property (weak, nonatomic) IBOutlet UITextView *notestext;

- (IBAction)openMail:(id)sender;

@end
