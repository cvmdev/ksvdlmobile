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

/*Added for phone and email validation*/
@interface NSString (emailValidation)
-(BOOL)isValidEmail;
@end

@interface NSString (phonenumberValidation)
-(BOOL)isValidPhone;
@end

@implementation AddTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.TextContentView
                                                                      attribute:NSLayoutAttributeLeading
                                                                      relatedBy:0
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0
                                                                       constant:10];
    [self.view addConstraint:leftConstraint];
    
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.TextContentView
                                                                       attribute:NSLayoutAttributeTrailing
                                                                       relatedBy:0
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:1.0
                                                                        constant:-10];
    [self.view addConstraint:rightConstraint];

    
    NSLog(@"Accession Number from previous controller is :%@",self.accessionNumber);
    NSLog(@"Owner Name from previous controller is :%@",self.ownerName);
    

   _atlabel.text = [NSString stringWithFormat:@"%@%@",@" Accession Number : ",self.accessionNumber];
   _ownerlabel.text = [NSString stringWithFormat:@"%@%@",@" Owner Name : ",self.ownerName];
    _clientlabel.text = [NSString stringWithFormat:@"%@%@",@" Client : ",self.clientName];
   //_cltext.text=self.clientName;
    
    _barButton.target = self.revealViewController;
    _barButton.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.revealViewController.panGestureRecognizer.enabled=YES;
    [self.barButton setTarget: self.revealViewController];
    [self.barButton setAction: @selector( rightRevealToggle: )];
    
    
    //The following adds UITextView with rounded corners
    //[_notestext.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
    [_notestext.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [_notestext.layer setBorderWidth: 1.0];
    [_notestext.layer setCornerRadius:8.0f];
    [_notestext.layer setMasksToBounds:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)popToRoot:(UIBarButtonItem*)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)popToBack
{
    //[self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
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
    [[UINavigationBar appearance] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBarTintColor:[[UIColor alloc] initWithRed:81.0/255.0 green:40.0/255.0 blue:136.0/255.0 alpha:1.0]];
    
    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        
        
        NSString *phonenos = _inttext.text;
        phonenos = [phonenos stringByAppendingString:_phtext.text];
        
        mailer.mailComposeDelegate = self;
        
        NSString *prefixtxt = @"<h4>The following information has been submitted from the KSVDL Mobile App requesting additional tests - </h4>";
        
        NSString *accnos = [NSString stringWithFormat:@"%@%@",@" <b>Accession Number :</b> ",self.accessionNumber];
        NSString *ownername = [NSString stringWithFormat:@"%@%@",@" <b>Owner Name :</b> ",self.ownerName];
        NSString *clientnametxt = [NSString stringWithFormat:@"%@%@",@" <b>Client :</b> ",self.clientName];
        NSString *phonetxt = [NSString stringWithFormat:@"%@%@",@" <b>Contact Number :</b> ",phonenos];
        NSString *emailtxt = [NSString stringWithFormat:@"%@%@",@" <b>Email :</b> ",_emailtext.text];
        NSString *textnametxt = [NSString stringWithFormat:@"%@%@",@" <b>Test Name Requested :</b> ",_testnametext.text];
        NSString *notestxt = [NSString stringWithFormat:@"%@%@",@" <b>Additional Notes :</b> ",_notestext.text];
        
        NSString *suffixtxt = @"<h4>Sent from KSVDL Mobile App</h4>";
        
        if ((_phtext.text && _phtext.text.length > 0) && (_testnametext.text && _testnametext.text.length > 0))
        {
            if([_phtext.text isValidPhone])
            {
                if((_emailtext.text.length>0 && [_emailtext.text isValidEmail]) || (_emailtext.text.length==0)) //When email exisits, ensure its valid
                {
                    NSLog(@"Valid Email ID");
                    [mailer setSubject:@"Request to Add new tests"];
                    
                    NSArray *toRecipients;
                    
                    if([self.accessionNumber hasPrefix:@"R"])
                    {
                        toRecipients = [NSArray arrayWithObject:@"rabies@vet.k-state.edu"];
                    }
                    else
                    {
                        toRecipients = [NSArray arrayWithObject:@"clientcare@vet.k-state.edu"];
                    }
                    
                    [mailer setToRecipients:toRecipients];
                    NSArray *myStrings = [[NSArray alloc] initWithObjects:prefixtxt, accnos, ownername, clientnametxt, phonetxt, emailtxt, textnametxt, notestxt, suffixtxt, nil];
                    // NSString *joinedString = [myStrings componentsJoinedByString:@"|"];
                    NSString *emailBody = [myStrings componentsJoinedByString:@"<br/>"];
                    [mailer setMessageBody:emailBody isHTML:YES];
                    [self presentModalViewController:mailer animated:YES];
                    [mailer.navigationBar setTintColor:[UIColor whiteColor]];
                    NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Arial" size:13.0],NSFontAttributeName, nil];
                    
                    [mailer.navigationBar setTitleTextAttributes:size];
                }
                else
                {
                    UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                     message:@"Not a valid Email"
                                                                    delegate:self
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil];
                    [alert1 show];
                    
                }
            }
            else
            {
                UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                 message:@"Not a valid Phone Number"
                                                                delegate:self
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
                [alert2 show];
            }
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Please fill the required information"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        //    [mailer release];
    }
    else
    {
        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                         message:@"Your device doesn't support the composer sheet"
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
        [alert1 show];
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


@implementation NSString (emailValidation)
-(BOOL)isValidEmail
{
    BOOL stricterFilter = NO;
    
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}
@end


@implementation NSString (phonenumberValidation)
-(BOOL)isValidPhone
{
    NSString *phoneRegex = @"^[0-9-]*$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:self];
}

@end