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
    
    _accessionTextField.text = self.accessionNumber;
    _ownernameTextField.text = self.ownerName;
    _accessionTextField.userInteractionEnabled = false;
    _ownernameTextField.userInteractionEnabled = false;
    
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
@end
