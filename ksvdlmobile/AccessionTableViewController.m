//
//  AccessionTableViewController.m
//  ksvdlmobile
//
//  Created by Praveen on 5/26/15.
//  Copyright (c) 2015 Praveen. All rights reserved.
//

#import "AccessionTableViewController.h"
#import "AccessionReportViewController.h"

const int kLoadingCellTag = 2015;
NSString * const kCredentialIdentifier=@"VetViewID";
NSString * const simpleTableIdentifier = @"AccessionCell";

@implementation AccessionTableViewController
    
@synthesize accessionList;

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    _currentPage=1;
    self.accessionList = [NSMutableArray array];
    
    [SVProgressHUD showWithStatus:@"Loading"];
    [self fetchAccessions];
    [SVProgressHUD dismiss];
    
}
//-(void) viewWillDisappear:(BOOL)animated {
//    [self.navigationController popToRootViewControllerAnimated:NO];
//}

#pragma mark instant methods

- (AFOAuthCredential *) getCredential
{
    AFOAuthCredential  *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:kCredentialIdentifier];
    return credential;
}



-(void) fetchAccessions
{
        AFOAuthCredential  *credential = [self getCredential];
        
        
        if ((!credential) || (credential.isExpired))
        {
            NSLog(@"ATVC:User is not logged in , send to login screen");
            
            
        }
        else
        {
            NSLog(@"ATVC:User is logged in and authentication token is current");
            
           
            
            AFHTTPRequestOperationManager * reqManager = [AFHTTPRequestOperationManager manager];
            AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
            
            //NSLog(@"ATVC:Authorization Header Token:%@",credential.accessToken);
            
            [serializer setValue:[NSString stringWithFormat:@"Bearer %@", credential.accessToken] forHTTPHeaderField:@"Authorization"];
            reqManager.requestSerializer = serializer;
            reqManager.responseSerializer=[AFJSONResponseSerializer serializer];
                
            NSString *urlString = [NSString stringWithFormat:@"http://129.130.128.31/TestProjects/TestAuthAPI/api/orders/acc?pageNo=%ld",(long)_currentPage];
            
            [reqManager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                //NSLog(@"JSON: %@", responseObject);
                
                _totalPages = [[[responseObject objectForKey:@"Paging"] objectForKey:@"PageCount"] intValue];
                NSLog(@"Total Pages: %ld",(long)_totalPages);
                
                //NSMutableArray * results = [NSMutableArray array];
                
                //[results addObject :[responseObject objectForKey:@"Accessions"]];
                NSLog(@"Values are: %@",[responseObject objectForKey:@"Accessions"]);
                
                [self.accessionList addObjectsFromArray:[responseObject objectForKey:@"Accessions"]];
                
                [self.tableView reloadData];
                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: Problem while fetching accessions: %@", error);
            }];

        }
}

// this cell is for showing the activity indicator when more rows are required to be retrieved.
- (UITableViewCell * ) loadingCell{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]
                                                  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center=cell.center;
    
    [cell addSubview:activityIndicator];
    [activityIndicator startAnimating];
    cell.tag=kLoadingCellTag;
    return cell;
}

- (UITableViewCell *) accessionCellForIndexPath:(NSIndexPath *) indexPath{
    
    AccessionTableCell *cell = [self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[AccessionTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.accReportDelegate=self;
    cell.buttonIndexPath=indexPath;
    
    NSDictionary * currentAccessionDict = [self.accessionList objectAtIndex:indexPath.row];
    
    NSString *accStatus =[currentAccessionDict objectForKey:@"AccessionStatus"];
    
    if ([accStatus isEqualToString:@"Finalized"])
    {
        cell.backgroundColor= [[UIColor alloc] initWithRed:209.0/255.0 green:211/255.0 blue:212/255.0 alpha:0.5];
        cell.viewreportButton.hidden=false;
        cell.statusLabel.hidden=TRUE;
        
    }
    if ([accStatus isEqualToString:@"New"])
    {
        cell.backgroundColor= [[UIColor alloc] initWithRed:60.0/255.0 green:184/255.0 blue:121/255.0 alpha:0.5];
        cell.finalizedDateLabel.hidden=TRUE;
        cell.statusLabel.textColor=[[UIColor alloc] initWithRed:0/255.0 green:114.0/255.0 blue:54.0/255.0 alpha:1.0];
        cell.statusLabel.hidden=false;
        cell.viewreportButton.hidden=TRUE;
    }
    if ([accStatus isEqualToString:@"Working"])
    {
        cell.backgroundColor= [[UIColor alloc] initWithRed:246.0/255.0 green:152.0/255.0 blue:157.0/255.0 alpha:1.0];
        cell.finalizedDateLabel.hidden=TRUE;
        cell.statusLabel.textColor=[[UIColor alloc] initWithRed:158.0/255.0 green:11.0/255.0 blue:15.0/255.0 alpha:1.0];
        cell.viewreportButton.hidden=TRUE;
        cell.statusLabel.hidden=false;
        
        
    }
    
    if ([accStatus isEqualToString:@"Review"])
    {
        cell.backgroundColor= [[UIColor alloc] initWithRed:249.0/255.0 green:173.0/255.0 blue:29.0/255.0 alpha:1.0];
        cell.finalizedDateLabel.hidden=TRUE;
        cell.statusLabel.textColor=[[UIColor alloc] initWithRed:247.0/255.0 green:148.0/255.0 blue:29.0/255.0 alpha:1.0];
        
    }
    
    cell.ownerLabel.text = [currentAccessionDict objectForKey:@"OwnerName"];
    cell.accessionLabel.text=[NSString stringWithFormat:@"Accession#:%@",[currentAccessionDict objectForKey:@"AccessionNo"]];
    cell.statusLabel.text=[currentAccessionDict objectForKey:@"AccessionStatus"];
    cell.receivedDateLabel.text=[NSString stringWithFormat:@"Received:%@",[currentAccessionDict objectForKey:@"ReceivedDate"]];
    cell.finalizedDateLabel.text=[NSString stringWithFormat:@"Finalized:%@",[currentAccessionDict objectForKey:@"FinalizedDate"]];
    cell.caseCoordinatorLabel.text=[NSString stringWithFormat:@"CaseCoordinator:%@",[currentAccessionDict objectForKey:@"CaseCoordinator"]];
    
    return cell;
}



# pragma Mark tableview delegate methods

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.accessionList.count) {
        return [self accessionCellForIndexPath:indexPath];
    }
    else
    {
        return [self loadingCell];
    }
 
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_currentPage< _totalPages)
        return self.accessionList.count+ 1;
    
    return [self.accessionList count];
    
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (cell.tag==kLoadingCellTag){
        _currentPage++;
        [self fetchAccessions];
    }
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"viewreport"])
    {
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        NSDictionary * cellDetails = [self.accessionList objectAtIndex:indexPath.row];
        NSLog(@"AccessionValue is %@",[cellDetails objectForKey:@"AccessionNo"]);
        AccessionReportViewController *destViewController = segue.destinationViewController;
        destViewController.accessionNumber = [cellDetails objectForKey:@"AccessionNo"];
    }
    
}



#pragma Mark -- AccCellDelegate
-(void) accessionReportFor:(NSIndexPath *)indexPath{
    NSLog(@"Button Clicked at Index %ld",(long)indexPath.row);
   
    [self performSegueWithIdentifier:@"viewreport" sender:indexPath];
    
}

@end
