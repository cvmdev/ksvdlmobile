//
//  AddTestViewController.m
//  ksvdlmobile
//
//  Created by Arthi Subramanian on 6/30/15.
//  Copyright (c) 2015 Praveen. All rights reserved.
//

#import "AddTestViewController.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "AFOAuth2Client.h"
#import "SWRevealViewController.h"

@interface AddTestViewController ()


@end

@implementation AddTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"Accession Number from previous controller is :%@",self.accessionNumber);
    NSLog(@"Owner Name from previous controller is :%@",self.ownerName);
    

   _atlabel.text = [NSString stringWithFormat:@"%@%@",@" Accession Number : ",self.accessionNumber];
    _ownerlabel.text = [NSString stringWithFormat:@"%@%@",@" Owner Name : ",self.ownerName];
    
    _barButton.target = self.revealViewController;
    _barButton.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.barButton setTarget: self.revealViewController];
    [self.barButton setAction: @selector( rightRevealToggle: )];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)openMail:(id)sender {
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        
        mailer.mailComposeDelegate = self;
        
        [mailer setSubject:@"Request to add tests"];
        
        NSArray *toRecipients = [NSArray arrayWithObject:@"arthis@vet.k-state.edu"];
        [mailer setToRecipients:toRecipients];
        
    
        NSString *accnos = [NSString stringWithFormat:@"%@%@",@" Accession Number : ",self.accessionNumber];
        NSString *ownername = [NSString stringWithFormat:@"%@%@",@" Owner Name : ",self.ownerName];
        
      NSString *emailBody = @"Email Body....";
 
        [mailer setMessageBody:emailBody isHTML:YES];
        
        [self presentModalViewController:mailer animated:YES];
    //    [mailer release];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    
    // Remove the mail view
    [self dismissModalViewControllerAnimated:YES];
}

@end
