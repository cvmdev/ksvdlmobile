//
//  AccessionTableViewController.m
//  ksvdlmobile
//
//  Created by Praveen on 5/26/15.
//  Copyright (c) 2015 Praveen. All rights reserved.
//

#import "AccessionTableViewController.h"
#import "AccessionReportViewController.h"
#import "SWRevealViewController.h"
#import "AddTestViewController.h"
#import "GlobalConstants.h"
#import "HttpClient.h"

const int kLoadingCellTag = 2015;
NSString * const simpleTableIdentifier = @"AccessionCell";

@implementation AccessionTableViewController{
    NSString * clientBusinessName;
}

@synthesize accessionList,selectedIndex;

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    /*Receiveing the accessions table restriction from the root.plist in settings.bundle*/
    NSUserDefaults *myDefaults = [NSUserDefaults standardUserDefaults];
    NSString *accessionrestrict         = [myDefaults objectForKey:@"accession_restrict"];
    NSLog(@"The restriction for accession table is %@",accessionrestrict);
    /*Receiveing the accessions table restriction from the root.plist in settings.bundle*/
    
    _barButton1.target = self.revealViewController;
    _barButton1.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.barButton1 setTarget: self.revealViewController];
    [self.barButton1 setAction: @selector( rightRevealToggle: )];
  
    
    
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *backBtn =[[UIBarButtonItem alloc]initWithTitle:@"HOME" style:UIBarButtonItemStyleDone target:self action:@selector(popToRoot:)];
    self.navigationItem.leftBarButtonItem=backBtn;
    
    
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    
    //set current page as 1 and initialize array
    _currentPage=1;
    //set selectedIndex=-1; (which means currently no row is selected)
    self.selectedIndex=-1;
    
    self.accessionList = [NSMutableArray array];
    self.filteredAccList=[NSMutableArray array];
    
    [SVProgressHUD showWithStatus:@"Loading"];
    [self fetchAccessions];
    
}

- (IBAction)popToRoot:(UIBarButtonItem*)sender {
    //[self.navigationController popToRootViewControllerAnimated:YES];
    [self performSegueWithIdentifier:@"AccessiontoHome" sender:sender];
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // Navigation button was pressed. Do some stuff
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    [super viewWillDisappear:animated];
    //[self.navigationController popToRootViewControllerAnimated:NO];
}

#pragma mark instant methods

- (AFOAuthCredential *) getCredential
{
    AFOAuthCredential  *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:kCredentialIdentifier];
    return credential;
}

- (IBAction)refreshAccessionScreen:(id)sender {
    
    _currentPage=1;
    [self.accessionList removeAllObjects];
    [self.filteredAccList removeAllObjects];
    [self fetchAccessions];
    //[self.tableView reloadData];
    [sender endRefreshing];
}

-(void) fetchAccessions
{
    //AFOAuthCredential  *credential = [self getCredential];
    if ([[AuthAPIClient sharedClient] isSignInRequired])
    {
        NSLog(@"ATVC:User is not logged in , send to login screen");
    }
    else
    {
        NSLog(@"ATVC:User is logged in and authentication token is current");
        
        //        AFHTTPRequestOperationManager * reqManager = [AFHTTPRequestOperationManager manager];
        //        AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
        //
        //        //NSLog(@"ATVC:Authorization Header Token:%@",credential.accessToken);
        //
        //        [serializer setValue:[NSString stringWithFormat:@"Bearer %@", credential.accessToken] forHTTPHeaderField:@"Authorization"];
        //        reqManager.requestSerializer = serializer;
        //        reqManager.responseSerializer=[AFJSONResponseSerializer serializer];
        //
        //        NSString *urlString = [NSString stringWithFormat:@"http://129.130.128.31/TestProjects/TestAuthAPI/api/orders/acc?pageNo=%ld",(long)_currentPage];
        //
        
        HttpClient *client = [HttpClient sharedHTTPClient];
        
        //[reqManager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [client fetchAccessionsForPageNo:_currentPage WithSuccessBlock:^(AFHTTPRequestOperation *operation,id responseObject) {
            //_totalPages = [[[responseObject objectForKey:@"Paging"] objectForKey:@"PageCount"] intValue];
            
            _totalPages = [[[[responseObject objectForKey:@"AccList"]objectForKey:@"Paging"] objectForKey:@"PageCount"] intValue];
            NSLog(@"Total Pages: %ld",(long)_totalPages);
            NSLog(@"The data is %@",responseObject);
            
            clientBusinessName = [responseObject objectForKey:@"ClientName"];
            
            [self.accessionList addObjectsFromArray:[[responseObject objectForKey:@"AccList"]objectForKey:@"Accessions"]];
            
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
            
        } andFailureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [SVProgressHUD dismiss];
            
            NSLog(@"Some Error while fetching data");
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

- (UITableViewCell *) accessionCellForIndexPath:(NSIndexPath *) indexPath FromDictionary:(NSDictionary *) dict{
    
    AccessionTableCell *cell = [self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[AccessionTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.accReportDelegate=self;
    cell.buttonIndexPath=indexPath;
    [cell setBackgroundColor:[UIColor clearColor]];
    
    NSDictionary *currentAccessionDict= dict;
    //NSDictionary * currentAccessionDict = [self.accessionList objectAtIndex:indexPath.row];
    
    NSString *accStatus =[currentAccessionDict objectForKey:@"AccessionStatus"];
    
    
    if ([accStatus isEqualToString:@"Finalized"])
    {
        //cell.backgroundColor= [[UIColor alloc] initWithRed:209.0/255.0 green:211/255.0 blue:212/255.0 alpha:0.5];
        //cell.backgroundColor= [[UIColor alloc] initWithRed:145.0/255.0 green:145.0/255.0 blue:149.0/255.0 alpha:0.5];
        
        [cell setBackgroundColor:[UIColor clearColor]];
        
        CAGradientLayer *grad = [CAGradientLayer layer];
        grad.frame = cell.bounds;
        grad.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:149.0/255.0 alpha:1.0] CGColor], (id)[[UIColor colorWithRed:231.0/255.0 green:222.0/255.0 blue:208.0/255.0 alpha:1.0] CGColor], nil];
        
        [cell setBackgroundView:[[UIView alloc] init]];
        [cell.backgroundView.layer insertSublayer:grad atIndex:0];
        
        cell.viewreportButton.hidden=false;
        cell.addtestButton.hidden = true;
        
        cell.statusLabel.hidden=TRUE;
        
    }
    if ([accStatus isEqualToString:@"New"])
    {
        //cell.backgroundColor= [[UIColor alloc] initWithRed:60.0/255.0 green:184/255.0 blue:121/255.0 alpha:0.5];
        //cell.backgroundColor= [[UIColor alloc] initWithRed:159.0/255.0 green:145/255.0 blue:112/255.0 alpha:0.5];
        
        NSLog(@"New called........................................................");
        [cell setBackgroundColor:[UIColor clearColor]];
        
        CAGradientLayer *grad = [CAGradientLayer layer];
        grad.frame = cell.bounds;
        grad.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:153.0/255.0 green:255.0/255.0 blue:153.0/255.0 alpha:1.0] CGColor], (id)[[UIColor colorWithRed:204.0/255.0 green:255.0/255.0 blue:204.0/255.0 alpha:1.0] CGColor], nil];
        
        [cell setBackgroundView:[[UIView alloc] init]];
        [cell.backgroundView.layer insertSublayer:grad atIndex:0];
        
        cell.finalizedDateLabel.hidden=TRUE;
        cell.statusLabel.textColor=[[UIColor alloc] initWithRed:0/255.0 green:114.0/255.0 blue:54.0/255.0 alpha:1.0];
        cell.statusLabel.hidden=false;
        cell.viewreportButton.hidden=TRUE;
        cell.addtestButton.hidden=false;
    }
    if ([accStatus isEqualToString:@"Working"])
    {
        //cell.backgroundColor= [[UIColor alloc] initWithRed:246.0/255.0 green:152.0/255.0 blue:157.0/255.0 alpha:1.0];
        //cell.backgroundColor= [[UIColor alloc] initWithRed:255.0/255.0 green:238/255.0 blue:187.0/255.0 alpha:0.5];
        [cell setBackgroundColor:[UIColor clearColor]];
        
        CAGradientLayer *grad = [CAGradientLayer layer];
        grad.frame = cell.bounds;
        grad.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:153.0/255.0 alpha:1.0] CGColor], (id)[[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:204.0/255.0 alpha:1.0] CGColor], nil];
        
        [cell setBackgroundView:[[UIView alloc] init]];
        [cell.backgroundView.layer insertSublayer:grad atIndex:0];
        
        cell.finalizedDateLabel.hidden=TRUE;
        cell.statusLabel.textColor=[[UIColor alloc] initWithRed:158.0/255.0 green:11.0/255.0 blue:15.0/255.0 alpha:1.0];
        cell.viewreportButton.hidden=TRUE;
        cell.addtestButton.hidden=false;
        //  cell.statusLabel.hidden=false;
    }
    
    if ([accStatus isEqualToString:@"Review"])
    {
        //cell.backgroundColor= [[UIColor alloc] initWithRed:249.0/255.0 green:173.0/255.0 blue:29.0/255.0 alpha:1.0];
        //cell.backgroundColor= [[UIColor alloc] initWithRed:255.0/255.0 green:238/255.0 blue:187.0/255.0 alpha:0.5];
        [cell setBackgroundColor:[UIColor clearColor]];
        
        CAGradientLayer *grad = [CAGradientLayer layer];
        grad.frame = cell.bounds;
        grad.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:153.0/255.0 alpha:1.0] CGColor], (id)[[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:204.0/255.0 alpha:1.0] CGColor], nil];
        
        [cell setBackgroundView:[[UIView alloc] init]];
        [cell.backgroundView.layer insertSublayer:grad atIndex:0];
        
        cell.finalizedDateLabel.hidden=TRUE;
        cell.statusLabel.textColor=[[UIColor alloc] initWithRed:247.0/255.0 green:148.0/255.0 blue:29.0/255.0 alpha:1.0];
        cell.addtestButton.hidden=false;
    }
    
    cell.ownerLabel.text = [currentAccessionDict objectForKey:@"OwnerName"];
    cell.accessionLabel.text=[NSString stringWithFormat:@"Accession#:%@",[currentAccessionDict objectForKey:@"AccessionNo"]];
    cell.statusLabel.text=[currentAccessionDict objectForKey:@"AccessionStatus"];
    cell.receivedDateLabel.text=[NSString stringWithFormat:@"Received:%@",[currentAccessionDict objectForKey:@"ReceivedDate"]];
    cell.finalizedDateLabel.text=[NSString stringWithFormat:@"Finalized:%@",[currentAccessionDict objectForKey:@"FinalizedDate"]];
    cell.caseCoordinatorLabel.text=[NSString stringWithFormat:@"CaseCoordinator:%@",[currentAccessionDict objectForKey:@"CaseCoordinator"]];
    
    NSString *fulltestString=@"";
    int numNonNullTestCount =0;
    NSArray *testArray=[currentAccessionDict objectForKey:@"Tests"];
    
    //if (!([currentAccessionDict objectForKey:@"Tests"]==(id)[NSNull null]))
    numNonNullTestCount=[self nonNullTestCountForArray:testArray];
    if (numNonNullTestCount>0)
        {
            fulltestString=@"Tests Ordered:\n";
            NSUInteger ulLength=fulltestString.length;

            for (NSString *testInfo in testArray)
            {
                if (!(testInfo==(id)[NSNull null]))
                {
                //numNonNullTestCount = numNonNullTestCount+1;
                fulltestString = [fulltestString stringByAppendingString:testInfo];
                fulltestString = [fulltestString stringByAppendingString:@"\n"];
                }
            }
            
            cell.testInfoLabel.hidden=false;
            //cell.testInfoLabel.numberOfLines=[testArray count]+1;
            cell.testInfoLabel.numberOfLines=numNonNullTestCount + 1;
            cell.testInfoLabel.lineBreakMode=NSLineBreakByWordWrapping;
            NSMutableAttributedString* ulstring = [[NSMutableAttributedString alloc]initWithString:fulltestString];
            NSNumber* underlineNumber = [NSNumber numberWithInteger:NSUnderlineStyleSingle];
            [ulstring addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, ulLength)];//TextColor
            [ulstring addAttribute:NSUnderlineStyleAttributeName value:underlineNumber range:NSMakeRange(0, ulLength)];//Underline color
            [ulstring addAttribute:NSUnderlineColorAttributeName value:[UIColor purpleColor] range:NSMakeRange(0, ulLength)];//TextColor
            //cell.testInfoLabel.text=fulltestString;
            cell.testInfoLabel.attributedText=ulstring;
        }
    
    else
        cell.testInfoLabel.hidden=true;
    
    if (!([currentAccessionDict objectForKey:@"RefNumber"]==(id)[NSNull null]))
    {
        cell.referenceNumberLabel.text= [NSString stringWithFormat:@"Ref #:%@",[currentAccessionDict objectForKey:@"RefNumber"]];
        cell.referenceNumberLabel.hidden=false;
    }
    else
        cell.referenceNumberLabel.hidden=TRUE;
    return cell;
}



# pragma Mark tableview delegate methods

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.searchDisplayController.searchResultsTableView){
        
        NSDictionary *filterDict= [self.filteredAccList objectAtIndex:indexPath.row];
        
        return [self accessionCellForIndexPath:indexPath FromDictionary:filterDict];
    }
    else
    {
        if (indexPath.row < self.accessionList.count) {
            NSDictionary *fullDict= [self.accessionList objectAtIndex:indexPath.row];
            return [self accessionCellForIndexPath:indexPath FromDictionary:fullDict];
        }
        else
        {
            return [self loadingCell];
        }
    }
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.filteredAccList count];
        
    } else {
        
        if (_currentPage< _totalPages)
            return self.accessionList.count+ 1;
        
        return [self.accessionList count];
    }
    
}

- (int) nonNullTestCountForArray:(NSArray*) testArray{
    
    NSIndexSet *nonNullIndexes = [testArray indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
       return obj!= [NSNull null];
    }];
    
    return (int)(nonNullIndexes.count);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat defaultCellHeight=80;
    
    CGFloat currHeightOfCell=defaultCellHeight;
    
    
    if (self.selectedIndex==indexPath.row)
    {
    //return 170;
        NSDictionary *currCellDict=nil;
        int numTestCount=0;
        if (tableView==self.searchDisplayController.searchResultsTableView)
        {
            currCellDict= [self.filteredAccList objectAtIndex:indexPath.row];
            //numTestCount =(int)[[currCellDict objectForKey:@"Tests"] count];
            numTestCount = [self nonNullTestCountForArray:[currCellDict objectForKey:@"Tests"]];
            if (numTestCount>0)
            {
            currHeightOfCell = currHeightOfCell + ((numTestCount+1) * 30);
            }
            if(!([currCellDict objectForKey:@"RefNumber"]==(id)[NSNull null]))
                currHeightOfCell=currHeightOfCell+20;
            
        }
        else
        {
            if (indexPath.row < self.accessionList.count)
            {
                currCellDict= [self.accessionList objectAtIndex:indexPath.row];
                numTestCount = [self nonNullTestCountForArray:[currCellDict objectForKey:@"Tests"]];
                
                if (numTestCount>0)
                    currHeightOfCell = currHeightOfCell + ((numTestCount+1) * 30);
               
                if(!([currCellDict objectForKey:@"RefNumber"]==(id)[NSNull null]))
                    currHeightOfCell=currHeightOfCell+20;
            }
        
        }
    }
    return currHeightOfCell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"ROW SELECTED..%ld",indexPath.row);
    if (self.selectedIndex ==indexPath.row)
    {
        self.selectedIndex=-1;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        return;
    }
    
    if (self.selectedIndex!=-1){
        NSIndexPath *prevPath = [NSIndexPath indexPathForRow:self.selectedIndex inSection:0];
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:prevPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    self.selectedIndex=(int)indexPath.row;
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}



- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    NSDictionary *currCellDict = nil;
    NSString *currCellStatus=nil;
    
    if([cell.backgroundView.layer.sublayers count] >0)
    {
        if([[cell.backgroundView.layer.sublayers objectAtIndex:0] isKindOfClass:[CAGradientLayer class]])
        {
            
            [[cell.backgroundView.layer.sublayers objectAtIndex:0] removeFromSuperlayer];
            
        }
    }
    
    
    if (tableView==self.searchDisplayController.searchResultsTableView)
    {
        currCellDict= [self.filteredAccList objectAtIndex:indexPath.row];
        currCellStatus =[currCellDict objectForKey:@"AccessionStatus"];
       
        [self styleTableViewCell:cell forAccessionStatus:currCellStatus];
        
    }
    else
        if (indexPath.row < self.accessionList.count)
        {
            currCellDict= [self.accessionList objectAtIndex:indexPath.row];
            currCellStatus =[currCellDict objectForKey:@"AccessionStatus"];
            [self styleTableViewCell:cell forAccessionStatus:currCellStatus];
            
        }
    
    
    //if its a loading cell indicator....no need to add any color
    if (cell.tag==kLoadingCellTag){
        _currentPage++;
        [self fetchAccessions];
    }
    
    
}

//- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    
//    return @"ACCESSION STATUS";
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel * sectionHeader = [[UILabel alloc] initWithFrame:CGRectZero];
    sectionHeader.backgroundColor = [UIColor purpleColor];
    sectionHeader.textAlignment = NSTextAlignmentCenter;
    sectionHeader.font = [UIFont boldSystemFontOfSize:14];
    sectionHeader.textColor = [UIColor whiteColor];
    
    sectionHeader.text=@"ACCESSION STATUS";
    
    return sectionHeader;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 24;
}

-(void) styleTableViewCell:(UITableViewCell *) cell forAccessionStatus :(NSString *)accStatus
{
    if ([accStatus isEqualToString:@"New"])
    {
        //cell.backgroundColor= [[UIColor alloc] initWithRed:60.0/255.0 green:184/255.0 blue:121/255.0 alpha:0.5];
        //cell.backgroundColor= [[UIColor alloc] initWithRed:159.0/255.0 green:145/255.0 blue:112/255.0 alpha:0.5];
        
        
        [cell setBackgroundColor:[UIColor clearColor]];
        
        self.gradientView = [[GradientView alloc] initWithFrame:self.view.bounds];
        self.gradientView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        //CAGradientLayer *grad = [CAGradientLayer layer];
        //grad.frame = cell.bounds;
        self.gradientView.layer.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:153.0/255.0 green:255.0/255.0 blue:153.0/255.0 alpha:1.0] CGColor], (id)[[UIColor colorWithRed:204.0/255.0 green:255.0/255.0 blue:204.0/255.0 alpha:1.0] CGColor], nil];
        self.gradientView.frame=cell.bounds;
        [cell setBackgroundView:self.gradientView];
        //[cell.backgroundView.layer insertSublayer:self.gradientView.layer atIndex:0];
        
        
    }
    if ([accStatus isEqualToString:@"Working"] || [accStatus isEqualToString:@"Review"])
    {
        //cell.backgroundColor= [[UIColor alloc] initWithRed:246.0/255.0 green:152.0/255.0 blue:157.0/255.0 alpha:1.0];
        //cell.backgroundColor= [[UIColor alloc] initWithRed:255.0/255.0 green:238/255.0 blue:187.0/255.0 alpha:0.5];
        [cell setBackgroundColor:[UIColor clearColor]];
        
        self.gradientView = [[GradientView alloc] initWithFrame:self.view.bounds];
        self.gradientView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        //CAGradientLayer *grad = [CAGradientLayer layer];
        //grad.frame = cell.bounds;
        self.gradientView.layer.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:153.0/255.0 alpha:1.0] CGColor], (id)[[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:204.0/255.0 alpha:1.0] CGColor], nil];
        
        [cell setBackgroundView:self.gradientView];
        
    }
    if ([accStatus isEqualToString:@"Finalized"])
    {
        //cell.backgroundColor= [[UIColor alloc] initWithRed:209.0/255.0 green:211/255.0 blue:212/255.0 alpha:0.5];
        //cell.backgroundColor= [[UIColor alloc] initWithRed:145.0/255.0 green:145.0/255.0 blue:149.0/255.0 alpha:0.5];
        
        [cell setBackgroundColor:[UIColor clearColor]];
        self.gradientView = [[GradientView alloc] initWithFrame:self.view.bounds];
        self.gradientView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        //CAGradientLayer *grad = [CAGradientLayer layer];
        //grad.frame = cell.bounds;
        self.gradientView.layer.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:149.0/255.0 alpha:1.0] CGColor], (id)[[UIColor colorWithRed:231.0/255.0 green:222.0/255.0 blue:208.0/255.0 alpha:1.0] CGColor], nil];
        
        [cell setBackgroundView:self.gradientView];
        //[cell.backgroundView.layer insertSublayer:grad atIndex:0];
    }
    
}

- (void) filterAccessionsForSearchText:(NSString *) searchText scope:(NSString *)scope
{
    
    
    HttpClient *client = [HttpClient sharedHTTPClient];
    
    //[reqManager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    [client filterAccessionsWithSearchText:searchText WithSuccessBlock:^(AFHTTPRequestOperation *operation,id responseObject) {
        
        //NSLog(@"Values are: %@",[responseObject objectForKey:@"Accessions"]);
        
        [self.filteredAccList removeAllObjects];
        
        [self.filteredAccList addObjectsFromArray:[responseObject objectForKey:@"Accessions"]];
        
        NSLog(@"The count of the filter array is : %ld",(long)[self.filteredAccList count]);
        
        [self.searchDisplayController.searchResultsTableView reloadData];
        
    }andFailureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: Problem while fetching accessions on search: %@", error);
    }];
    
}


-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSLog(@"Search String is :%@",searchString);
    [self filterAccessionsForSearchText:searchString
                                  scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                         objectAtIndex:[self.searchDisplayController.searchBar
                                                        selectedScopeButtonIndex]]];
    return YES;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"viewreport"])
    {
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        NSDictionary * cellDetails = nil;
        if (self.searchDisplayController.active)
            cellDetails=[self.filteredAccList objectAtIndex:indexPath.row];
        else
            cellDetails=[self.accessionList objectAtIndex:indexPath.row];
        NSLog(@"AccessionValue is %@",[cellDetails objectForKey:@"AccessionNo"]);
        AccessionReportViewController *destViewController = segue.destinationViewController;
        destViewController.accessionNumber = [cellDetails objectForKey:@"AccessionNo"];
    }
    if ([segue.identifier isEqualToString:@"addtest"])
    {
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        NSDictionary * cellDetails = nil;
        if (self.searchDisplayController.active)
            cellDetails=[self.filteredAccList objectAtIndex:indexPath.row];
        else
            cellDetails=[self.accessionList objectAtIndex:indexPath.row];
        NSLog(@"AccessionValue is %@",[cellDetails objectForKey:@"AccessionNo"]);
        NSLog(@"Owner Name is %@",[cellDetails objectForKey:@"OwnerName"]);
        //NSLog(@"Owner Name is %@",[cellDetails objectForKey:@"OwnerName"]);
        
        AddTestViewController *destViewController = segue.destinationViewController;
        destViewController.accessionNumber = [cellDetails objectForKey:@"AccessionNo"];
        destViewController.ownerName = [cellDetails objectForKey:@"OwnerName"];
        destViewController.clientName=clientBusinessName;
    }
}

- (NSString * ) getCurrentAccessionForIndexPath: (NSIndexPath *) indexPath {
    NSDictionary * cellAccNum = nil;
    if (self.searchDisplayController.active)
        cellAccNum=[self.filteredAccList objectAtIndex:indexPath.row];
    else
        cellAccNum=[self.accessionList objectAtIndex:indexPath.row];
    
    return [cellAccNum objectForKey:@"AccessionNo"];
}

- (NSString *) accessionValidForReport:(NSString *)accNum
{
    __block NSString * accessionValidMessage=@"Failure to View Report";
    HttpClient *client = [HttpClient sharedHTTPClient];
    [client validateAccessionFor:accNum WithSuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Value got back from validate call is %@",responseObject);
        if (operation.response.statusCode==200)
        {
            NSLog(@"Accession is valid..so set success");
            accessionValidMessage =@"Success";
        }
        if (operation.response.statusCode==400)
        {
            accessionValidMessage=[responseObject objectForKey:@"Message"];
        }
    } andFailureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        accessionValidMessage= @"Unknown error while downloading file";
       
    }];
    
    return accessionValidMessage;
}

#pragma Mark -- AccCellDelegate
-(void) accessionReportFor:(NSIndexPath *)indexPath{
    NSLog(@"Button Clicked at Index %ld",(long)indexPath.row);
    //if ([([self accessionValidForReport:[self getCurrentAccessionForIndexPath:indexPath]]) isEqual:@"Success"])
        
        [self performSegueWithIdentifier:@"viewreport" sender:indexPath];
}

-(void) accessionaddtestFor:(NSIndexPath *)indexPath{
    NSLog(@"Button Clicked at Index %ld",(long)indexPath.row);
    [self performSegueWithIdentifier:@"addtest" sender:indexPath];
}

@end