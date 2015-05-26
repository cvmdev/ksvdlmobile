//
//  AccessionTableViewController.m
//  ksvdlmobile
//
//  Created by Praveen on 5/26/15.
//  Copyright (c) 2015 Praveen. All rights reserved.
//

#import "AccessionTableViewController.h"

@implementation AccessionTableViewController
    
@synthesize accessionList;

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    
    NSString *credentialIdentifier=@"VetViewID";
    
    AFOAuthCredential  *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:credentialIdentifier];
    if ((!credential) || (credential.isExpired))
    {
        NSLog(@"User is not logged in , send to login screen");
       
        
    }
    else
    {
        NSLog(@"ATVC:User is logged in and authentication token is current");
        [SVProgressHUD showWithStatus:@"Loading"];
        [self fetchAllAccessionsForCredential:credential];
    }
    
}

-(void) fetchAllAccessionsForCredential:(AFOAuthCredential *)credential
{
    
    AFHTTPRequestOperationManager * reqManager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    NSLog(@"ATVC:Authorization Header Token:%@",credential.accessToken);
    [serializer setValue:[NSString stringWithFormat:@"Bearer %@", credential.accessToken] forHTTPHeaderField:@"Authorization"];
    reqManager.requestSerializer = serializer;
    
    [reqManager GET:@"http://129.130.128.31/TestProjects/TestAuthAPI/api/orders/accessions" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        self.accessionList= [responseObject objectForKey:@"accessions"];
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];


}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"AccessionCell";
    
    AccessionTableCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[AccessionTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    
    
    NSDictionary * currentAccessionDict = [self.accessionList objectAtIndex:indexPath.row];
    
    NSString *accStatus =[currentAccessionDict objectForKey:@"AccessionStatus"];
    
  if ([accStatus isEqualToString:@"Finalized"])
  {
      cell.backgroundColor= [UIColor lightGrayColor];
  }
    if ([accStatus isEqualToString:@"New"])
    {
        cell.backgroundColor= [[UIColor alloc] initWithRed:153.0/255.0 green:1.0 blue:153/255.0 alpha:0.5];
        cell.finalizedDateLabel.hidden=TRUE;
        cell.statusLabel.textColor=[[UIColor alloc] initWithRed:0/255.0 green:102.0/255.0 blue:51.0/255.0 alpha:1.0];
    }
    if ([accStatus isEqualToString:@"Working"])
    {
        cell.backgroundColor= [[UIColor alloc] initWithRed:219.0/255.0 green:129.0/255.0 blue:129.0/255.0 alpha:1.0];
        cell.finalizedDateLabel.hidden=TRUE;
    }
  
    
    cell.ownerLabel.text = [currentAccessionDict objectForKey:@"OwnerName"];
    cell.accessionLabel.text=[NSString stringWithFormat:@"Accession#:%@",[currentAccessionDict objectForKey:@"AccessionNo"]];
    cell.statusLabel.text=[currentAccessionDict objectForKey:@"AccessionStatus"];
    cell.receivedDateLabel.text=[NSString stringWithFormat:@"Received:%@",[currentAccessionDict objectForKey:@"ReceivedDate"]];
    cell.finalizedDateLabel.text=[NSString stringWithFormat:@"Finalized:%@",[currentAccessionDict objectForKey:@"FinalizedDate"]];
    cell.caseCoordinatorLabel.text=[NSString stringWithFormat:@"CaseCoordinator:%@",[currentAccessionDict objectForKey:@"CaseCoordinator"]];
    
    

    return cell;
 
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.accessionList count];
    
}
@end
