//
//  AboutWebViewController.m
//  ksvdlmobile
//
//  Created by Arthi Subramanian on 9/27/15.
//  Copyright (c) 2015 Praveen. All rights reserved.
//

#import "AboutWebViewController.h"
#import "SWRevealViewController.h"
#import "GlobalConstants.h"

@interface AboutWebViewController ()

@end

@implementation AboutWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    // UIBarButtonItem *backBtn =[[UIBarButtonItem alloc]initWithTitle:@"HOME" style:UIBarButtonItemStyleDone target:self action:@selector(popToRoot:)];
    UIImage *temp = [[UIImage imageNamed:@"home"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *backBtn =[[UIBarButtonItem alloc]initWithImage:temp style:UIBarButtonItemStyleDone target:self action:@selector(popToRoot:)];
    self.navigationItem.leftBarButtonItem=backBtn;
    
    _BarButton.target = self.revealViewController;
    _BarButton.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.revealViewController.panGestureRecognizer.enabled=YES;
    [self.BarButton setTarget: self.revealViewController];
    [self.BarButton setAction: @selector( rightRevealToggle: )];
    
 
    // Do any additional setup after loading the view.
 /*   NSURL *aboutpageURL = [NSURL URLWithString:@"https://www.vet.k-state.edu/asp/app/about.html"];
    NSURLRequest *aboutpagerequest = [NSURLRequest requestWithURL:aboutpageURL];
    [WebView loadRequest:aboutpagerequest];  */
    
    
   /* NSString *make = @"Porsche";
    NSString *model = @"911";
    int year = 1968;
    NSString *message = [NSString stringWithFormat:@"That's a %@ %@ from %d!",
                         make, model, year];
    NSLog(@"%@", message);
    */
    
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *version =[NSString stringWithFormat:@"%@%@",@" Version : ",appVersion];
    
    //NSString *myHTML = [NSString stringWithFormat:@"<html><body><h3>About Page</h3><p>Track your samples from accessioning through final test results at the Kansas State Veterinary Diagnostics Lab. Designate how you receive push notifications as samples are accessioned into the lab, when individual test results become available, and when accession results are finalized. View and share results in PDF format.</p><p>Browse or search all available tests offered through the KSVDL. Review estimated turnaround times, sample collection instructions, shipping guidelines, prices, and much more.</p><p>Access KSVDL's growing library of instructional videos on collecting samples, shipping, and other topics.</p><p>Users must log in with their KSVDL VetView Portal account to view accession status and enable push notifications to receive updates on their submitted samples.</p><img style='width: 150px;' src='icon.png'><p><strong>KSVDL Mobile<br/>Version is %@</strong><br/>&copy;2015 Kansas State University College of Veterinary Medicine</p><img style='width: 250px;' src='KSU_CVM_logo.png' /><ul><li>Dr. Tammy Beckham, Dean of the College of Veterinary Medicine</li><li>Dr. Gary Anderson, Director/Professor, Kansas State Veterinary Diagnostic Laboratory</li><li>Dr. Kelli M. Almes, Director of Client Services</li><li>Manickam Dhandapani, Web/Database Developer</li><li>Dr. William Fortney, Assistant Professor, Director for Small Animal Outreach, KSVDL</li><li>Dr. Gregg A. Hanzlicek, Director of Outreach and Production Animal Field Disease Investigations</li><li>Eric Herrman, System Administrator</li><li>Mal Hoover, Medical Illustrator</li><li>Dr. Michael Moore, KSVDL Outreach</li><li>Praveen Ramanan, Database Engineer</li><li>Dr. Priscilla Roddy, Assistant Dean, Administration and Finance</li><li>Arthi Subramanian, Web/Database Developer</li><li>Justin Wiebers, Director, Client Connections</li></ul></body></html>",appVersion];
    
    NSString *myHTML=[NSString stringWithFormat:@"<html><body><h3>About Page on KSVDL Mobile App</h3><img style='width: 150px;' src='icon.png'/><p><strong>KSVDL Mobile<br/>Version is %@</strong><br/>&copy;2015 Kansas State University College of Veterinary Medicine</p><p>Welcome to the KSVDL mobile app! You asked for a faster way to get results and we listened!</p><p>The KSVDL mobile app provides a faster, more accessible way to get test results on the road or during a consultation with a client. With the app, you can:</p><b>Track samples</b><br/>With the KSVDL app, you’ll be in the know from the time you submit a sample until results are in!  Get the notifications that are important to you:<ul><li>Samples received</li><li>Individual tests become available</li><li>Finalized results</li><li>Plus, view and share results in PDF format</li></ul><br/><b>Browse and search available tests</b><br/>Review estimated turnaround times, sample collection instructions, shipping guidelines and much more!<br/><br/><b>Keep Learning</b><br/>Access our library of instructional videos on collecting samples, shipping and other topics that help you continue to grow and provide an expert level of service.<br/><br/><b>Get Started!</b><br/>Log-in with your KSVDL VetView Portal account to begin utilizing resources where you need them most!<br/><br/>Diagnostic Solutions. Collaboration. Innovation. Research.<br/>The KSVDL is a full-service, AAVLD-accredited laboratory, offering a complete range of diagnostic services for all species.</body></html>",appVersion];
    
 //<br/><b><Get started!</b><br/>Log-in with your KSVDL VetView Portal account to begin utilizing resources where you need them most!<br/>Diagnostic Solutions. Collaboration. Innovation. Research.<br/>The KSVDL is a full-service, AAVLD-accredited laboratory, offering a complete range of diagnostic services for all species.
    
    [WebView loadHTMLString:myHTML baseURL:baseURL];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)popToRoot:(UIBarButtonItem*)sender {
    [self performSegueWithIdentifier:@"abouttohome" sender:sender];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
