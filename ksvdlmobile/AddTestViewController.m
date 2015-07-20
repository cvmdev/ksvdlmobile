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
    
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *backBtn =[[UIBarButtonItem alloc]initWithTitle:@"HOME" style:UIBarButtonItemStyleDone target:self action:@selector(popToRoot:)];
    self.navigationItem.leftBarButtonItem=backBtn;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)popToRoot:(UIBarButtonItem*)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
        
        NSString *prefixtxt = @"<h4>The following information has been submitted from the KSVDL Mobile App requesting additional tests - </h4>";
        
        NSString *accnos = [NSString stringWithFormat:@"%@%@",@" <b>Accession Number :</b> ",self.accessionNumber];
        NSString *ownername = [NSString stringWithFormat:@"%@%@",@" <b>Owner Name :</b> ",self.ownerName];
        NSString *clientnametxt = [NSString stringWithFormat:@"%@%@",@" <b>Client Name :</b> ",_cltext.text];
        NSString *phonetxt = [NSString stringWithFormat:@"%@%@",@" <b>Contact Number :</b> ",_phtext.text];
        NSString *emailtxt = [NSString stringWithFormat:@"%@%@",@" <b>Email :</b> ",_emailtext.text];
        NSString *textnametxt = [NSString stringWithFormat:@"%@%@",@" <b>Test Name Requested :</b> ",_testnametext.text];
        NSString *notestxt = [NSString stringWithFormat:@"%@%@",@" <b>Additional Notes :</b> ",_notestext.text];
        
        NSString *suffixtxt = @"<h4>Sent from KSVDL Mobile App</h4>";
        
        [mailer setSubject:@"Request to Add tests"];
        
        NSArray *toRecipients = [NSArray arrayWithObject:@"arthis@vet.k-state.edu"];
        [mailer setToRecipients:toRecipients];
    
        NSArray *myStrings = [[NSArray alloc] initWithObjects:prefixtxt, accnos, ownername, clientnametxt, phonetxt, emailtxt, textnametxt, notestxt, suffixtxt, nil];
       // NSString *joinedString = [myStrings componentsJoinedByString:@"|"];
       
        NSString *emailBody = [myStrings componentsJoinedByString:@"<br/>"];
        
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
