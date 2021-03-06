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
    //NSString * clientBusinessName;
    UIActivityIndicatorView * activityView;
    UIView *loadingView;
    NSString *currentSearchString;
}

@synthesize accessionList,selectedIndex;

# pragma mark view life cycle methods
- (void) viewDidLoad
{
    [super viewDidLoad];
    
    /*The following couple of lines of code are remove the BACK botton text from the ADD TESTS page*/
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStyleDone target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem:backButton];
    
    /*Receiveing the accessions table restriction from the root.plist in settings.bundle*/
  //  NSUserDefaults *myDefaults = [NSUserDefaults standardUserDefaults];
    
   /* NSString *accessionrestrict = [myDefaults objectForKey:@"accession_restrict"];
    NSLog(@"The restriction for accession table is %@",accessionrestrict);*/
    /*Receiveing the accessions table restriction from the root.plist in settings.bundle*/
    
    _barButton1.target = self.revealViewController;
    _barButton1.action = @selector(revealToggle:);
    
    //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.barButton1 setTarget: self.revealViewController];
    [self.barButton1 setAction: @selector( rightRevealToggle: )];
   
    self.navigationItem.hidesBackButton = YES;
    
    //  UIBarButtonItem *backBtn =[[UIBarButtonItem alloc]initWithTitle:@"HOME" style:UIBarButtonItemStyleDone target:self action:@selector(popToRoot:)];
    UIImage *temp = [[UIImage imageNamed:@"home"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *backBtn =[[UIBarButtonItem alloc]initWithImage:temp style:UIBarButtonItemStyleDone target:self action:@selector(popToRoot:)];
    self.navigationItem.leftBarButtonItem=backBtn;
    
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    
    //set current page as 1 and initialize array
    _currentPage=1;
    
    //set selectedIndex=-1; (which means currently no row is selected)
    self.selectedIndex=-1;
    
    //initialize main accession array and another array for accession search array.
    self.accessionList = [NSMutableArray array];
    self.filteredAccList=[NSMutableArray array];
    
    [SVProgressHUD showWithStatus:@"Loading"];
    
    [self fetchAccessions];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // Navigation button was pressed. Do some stuff
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    [super viewWillDisappear:animated];
    //[self.navigationController popToRootViewControllerAnimated:NO];
}



#pragma mark instant methods
//Create a UIView with activity indicator for brief display while search is being done
- (UIView *) SearchIndicatorView
{
    loadingView = [[UIView alloc] initWithFrame:CGRectMake(0,0, 100, 30)];
    loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    //loadingView.clipsToBounds = YES;
    
    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(30,3,200,30)];
    loadingLabel.backgroundColor = [UIColor clearColor];
    loadingLabel.textColor = [UIColor whiteColor];
    loadingLabel.adjustsFontSizeToFitWidth = YES;
    //loadingLabel.textAlignment = UITextAlignmentCenter;
    loadingLabel.text = @"Searching  ";
    [loadingView addSubview:loadingLabel];
    
    //loadingView.layer.cornerRadius = 10.0;
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityView.frame = CGRectMake(200,3, activityView.bounds.size.width, activityView.bounds.size.height);
    [loadingView addSubview:activityView];
   
    return loadingView;
}

//hide view once the search is finished
-(void) hideSearchIndicator
{
    [activityView stopAnimating];
    [loadingView removeFromSuperview];
}

- (IBAction)popToRoot:(UIBarButtonItem*)sender {
     NSLog(@"%@",self.navigationController.viewControllers);
    //[self.navigationController popToRootViewControllerAnimated:YES];
    [self performSegueWithIdentifier:@"AccessiontoHome" sender:sender];
}

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
    [sender endRefreshing];
}

-(void) fetchAccessions
{
    if ([[AuthAPIClient sharedClient] isSignInRequired])
    {
        NSLog(@"ATVC:User is not logged in , send to login screen");
        [self performSegueWithIdentifier:@"AccessionToLogin" sender:self];
    }
    else
    {
        NSLog(@"ATVC:User is logged in and authentication token is current");
        
        HttpClient *client = [HttpClient sharedHTTPClient];
        
        [client fetchAccessionsForPageNo:_currentPage WithSuccessBlock:^(AFHTTPRequestOperation *operation,id responseObject) {
            _totalPages = [[[responseObject objectForKey:@"Paging"] objectForKey:@"PageCount"] intValue];
            
            //_totalPages = [[[[responseObject objectForKey:@"AccList"]objectForKey:@"Paging"] objectForKey:@"PageCount"] intValue];
            NSLog(@"Total Pages: %ld",(long)_totalPages);
            //NSLog(@"The data is %@",responseObject);
            
            [self.accessionList addObjectsFromArray:[responseObject objectForKey:@"Accessions"]];
            if (self.accessionList.count==0)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD showInfoWithStatus:@"Unable to find any accessions for your account"];
                });
            }
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
            
        } andFailureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [SVProgressHUD dismiss];
            if (![[AFNetworkReachabilityManager sharedManager] isReachable])
            {
                NSLog(@"Network Unreachable..display an alert to the user");
                //                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Not connected to the internet" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                //                [alertView show];
                [SVProgressHUD showErrorWithStatus:@"Not connected to the internet,please verify"];
                
                [self.navigationController popToRootViewControllerAnimated:NO];
                
            }
            else
            {
                NSLog(@"Some Error while fetching accession data--");
                NSLog(@"Error is %@",error);
                //[self performSegueWithIdentifier:@"AccessionToLogin" sender:self];
                //UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Problem while fetching Accessions.Please try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                //[alertView show];
                [SVProgressHUD showErrorWithStatus:@"Problem while fetching accessions, please try again"];
                
                [self.navigationController popToRootViewControllerAnimated:NO];
            }
            
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

- (int) nonNullTestCountForArray:(NSArray*) testArray{
    
    NSIndexSet *nonNullIndexes = [testArray indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return obj!= [NSNull null];
    }];
    
    return (int)(nonNullIndexes.count);
}

-(void) styleTableViewCell:(UITableViewCell *) cell forAccessionStatus :(NSString *)accStatus
{
    if ([accStatus isEqualToString:@"New"])
    {
        
        UIImage *backGround =[UIImage imageNamed:@"Accession_Cell_New"];
        
        UIImageView *cellBackgroundImage = [[UIImageView alloc] initWithImage:backGround];
        
        cellBackgroundImage.image=backGround;
        cell.backgroundView=cellBackgroundImage;
        cell.backgroundView.contentMode=UIViewContentModeTopLeft;
        
    }
    if ([accStatus isEqualToString:@"Working"] || [accStatus isEqualToString:@"Review"])
    {
        
        UIImage *backGround =[UIImage imageNamed:@"Accession_Cell_Working"];
        
        UIImageView *cellBackgroundImage = [[UIImageView alloc] initWithImage:backGround];
        
        cellBackgroundImage.image=backGround;
        cell.backgroundView=cellBackgroundImage;
        cell.backgroundView.contentMode=UIViewContentModeTopLeft;
    }
    if ([accStatus isEqualToString:@"Finalized"] || [accStatus isEqualToString:@"Addended"])
    {
        
        UIImage *backGround =[UIImage imageNamed:@"Accession_Cell_Finalized"];
        
        UIImageView *cellBackgroundImage = [[UIImageView alloc] initWithImage:[backGround stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0]];
        
        cellBackgroundImage.image=backGround;
        cell.backgroundView=cellBackgroundImage;
        cell.backgroundView.contentMode=UIViewContentModeTopLeft;
    }
    
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
    NSInteger labId = [[currentAccessionDict objectForKey:@"LabId"] integerValue];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    
    
    
    if ([accStatus isEqualToString:@"Finalized"] || [accStatus isEqualToString:@"Addended"])
    {
        //cell.backgroundColor= [[UIColor alloc] initWithRed:209.0/255.0 green:211/255.0 blue:212/255.0 alpha:0.5];
        //cell.backgroundColor= [[UIColor alloc] initWithRed:145.0/255.0 green:145.0/255.0 blue:149.0/255.0 alpha:0.5];
        
        NSDate *finalizedDate = [dateFormat dateFromString:[currentAccessionDict objectForKey:@"FinalizedDate"]];

        [cell setBackgroundColor:[UIColor clearColor]];
        
        CAGradientLayer *grad = [CAGradientLayer layer];
        grad.frame = cell.bounds;
        grad.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:149.0/255.0 alpha:1.0] CGColor], (id)[[UIColor colorWithRed:231.0/255.0 green:222.0/255.0 blue:208.0/255.0 alpha:1.0] CGColor], nil];
        
        [cell setBackgroundView:[[UIView alloc] init]];
        [cell.backgroundView.layer insertSublayer:grad atIndex:0];
        
        cell.finalizedDateLabel.hidden=false;
        cell.viewreportButton.hidden=false;
        if (([self daysBetween:finalizedDate and:[NSDate date]])>60)
            cell.addtestButton.hidden = true;
        else
            cell.addtestButton.hidden=false;
        
        cell.statusLabel.hidden=TRUE;
        
    }
    if ([accStatus isEqualToString:@"New"])
    {
        
        [cell setBackgroundColor:[UIColor clearColor]];
        cell.finalizedDateLabel.hidden=TRUE;
        cell.statusLabel.textColor=[[UIColor alloc] initWithRed:0/255.0 green:114.0/255.0 blue:54.0/255.0 alpha:1.0];
        cell.statusLabel.hidden=TRUE;
        cell.viewreportButton.hidden=TRUE;
        cell.addtestButton.hidden=false;
    }
    if ([accStatus isEqualToString:@"Working"] || [accStatus isEqualToString:@"Review"])
    {
        [cell setBackgroundColor:[UIColor clearColor]];
        cell.finalizedDateLabel.hidden=TRUE;
        cell.statusLabel.textColor=[[UIColor alloc] initWithRed:158.0/255.0 green:11.0/255.0 blue:15.0/255.0 alpha:1.0];
        
        if (labId==1)
            cell.viewreportButton.hidden=false;
        else
            cell.viewreportButton.hidden=true;
        cell.addtestButton.hidden=false;
        cell.statusLabel.hidden=TRUE;
    }
    
    //if ([accStatus isEqualToString:@"Review"])
    //{
    //cell.backgroundColor= [[UIColor alloc] initWithRed:249.0/255.0 green:173.0/255.0 blue:29.0/255.0 alpha:1.0];
    //cell.backgroundColor= [[UIColor alloc] initWithRed:255.0/255.0 green:238/255.0 blue:187.0/255.0 alpha:0.5];
    //        [cell setBackgroundColor:[UIColor clearColor]];
    //
    //        CAGradientLayer *grad = [CAGradientLayer layer];
    //        grad.frame = cell.bounds;
    //        grad.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:153.0/255.0 alpha:1.0] CGColor], (id)[[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:204.0/255.0 alpha:1.0] CGColor], nil];
    //
    //        [cell setBackgroundView:[[UIView alloc] init]];
    //        [cell.backgroundView.layer insertSublayer:grad atIndex:0];
    
    //        cell.finalizedDateLabel.hidden=TRUE;
    //        cell.statusLabel.textColor=[[UIColor alloc] initWithRed:247.0/255.0 green:148.0/255.0 blue:29.0/255.0 alpha:1.0];
    //        cell.addtestButton.hidden=TRUE;
    //        if (labId==1)
    //            cell.viewreportButton.hidden=false;
    //        else
    //            cell.viewreportButton.hidden=true;
    //}
    
    cell.ownerLabel.text = [currentAccessionDict objectForKey:@"OwnerName"];
    cell.accessionLabel.text=[NSString stringWithFormat:@"Accession# %@",[currentAccessionDict objectForKey:@"AccessionNo"]];
    cell.statusLabel.text=[currentAccessionDict objectForKey:@"AccessionStatus"];
    cell.receivedDateLabel.text=[NSString stringWithFormat:@"Received: %@",[currentAccessionDict objectForKey:@"ReceivedDate"]];
    cell.finalizedDateLabel.text=[NSString stringWithFormat:@"Finalized: %@",[currentAccessionDict objectForKey:@"FinalizedDate"]];
    
    if (!([currentAccessionDict objectForKey:@"CaseCoordinator"]==(id)[NSNull null]))
    {
        cell.caseCoordinatorLabel.text= [NSString stringWithFormat:@"Case Coordinator: %@",[currentAccessionDict objectForKey:@"CaseCoordinator"]];
        cell.caseCoordinatorLabel.hidden=false;
        cell.caseCoordinatorHeightConstraint.constant=15;
    }
    else
    {
        cell.caseCoordinatorLabel.hidden=TRUE;
        cell.caseCoordinatorHeightConstraint.constant=0;
    }
    
    NSString *fulltestString=@"";
    int numNonNullTestCount =0;
    NSArray *testArray=[currentAccessionDict objectForKey:@"Tests"];
    
    //cell.testInfoLabel.hidden=TRUE;
    
    numNonNullTestCount=[self nonNullTestCountForArray:testArray];
    if (numNonNullTestCount>0)
    {
        
     // if cell is getting expanded
      if (self.selectedIndex ==indexPath.row)
        {
            fulltestString=@" Tests Ordered:\n";
            NSUInteger ulLength=fulltestString.length;
            for (NSString *testInfo in testArray)
            {
                if (!(testInfo==(id)[NSNull null]))
                {
                    //numNonNullTestCount = numNonNullTestCount+1;
                    NSString *tabString = @"\t";
                    NSString *testInfoWithTab = [tabString stringByAppendingString:testInfo];
                    fulltestString = [fulltestString stringByAppendingString:testInfoWithTab];
                    fulltestString = [fulltestString stringByAppendingString:@"\n"];
                }
            }
                
        
            //cell.testInfoLabel.hidden=false;
            //cell.testInfoLabel.numberOfLines=[testArray count]+1;
            cell.testInfoLabel.numberOfLines=numNonNullTestCount + 1;
            cell.testInfoLabel.lineBreakMode=NSLineBreakByWordWrapping;
            
            NSMutableAttributedString* ulstring = [[NSMutableAttributedString alloc]initWithString:fulltestString];
            NSNumber* underlineNumber = [NSNumber numberWithInteger:NSUnderlineStyleSingle];
            [ulstring addAttribute:NSForegroundColorAttributeName value:[UIColor purpleColor] range:NSMakeRange(0, ulLength)];//TextColor
            [ulstring addAttribute:NSUnderlineStyleAttributeName value:underlineNumber range:NSMakeRange(1, ulLength-1)];//Underline color
            [ulstring addAttribute:NSUnderlineColorAttributeName value:[UIColor purpleColor] range:NSMakeRange(1, ulLength-1)];//TextColor
            //cell.testInfoLabel.text=fulltestString;
            
            NSTextAttachment *expand = [[NSTextAttachment alloc] init];
            expand.image = [UIImage imageNamed:@"Test-Expand"];
            NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:expand];

            NSMutableAttributedString *testString = [[NSMutableAttributedString alloc] initWithAttributedString:attachmentString];
            [testString appendAttributedString:ulstring];
            
            cell.testInfoLabel.attributedText=testString;
            
        }
        
        //cell is not expanded or going to be collapsed
        else
        {
            fulltestString=@" Tests Ordered";
            NSUInteger ulLength=fulltestString.length;
            cell.testInfoLabel.lineBreakMode=NSLineBreakByWordWrapping;
            NSMutableAttributedString* ulstring = [[NSMutableAttributedString alloc]initWithString:fulltestString];
            NSNumber* underlineNumber = [NSNumber numberWithInteger:NSUnderlineStyleSingle];
            [ulstring addAttribute:NSForegroundColorAttributeName value:[UIColor purpleColor] range:NSMakeRange(0, ulLength)];//TextColor
            [ulstring addAttribute:NSUnderlineStyleAttributeName value:underlineNumber range:NSMakeRange(1, ulLength-1)];//Underline color
            [ulstring addAttribute:NSUnderlineColorAttributeName value:[UIColor purpleColor] range:NSMakeRange(1, ulLength-1)];//TextColor
            
            NSTextAttachment *expand = [[NSTextAttachment alloc] init];
            expand.image = [UIImage imageNamed:@"Test-Collapse"];
            NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:expand];
            
            NSMutableAttributedString *testString = [[NSMutableAttributedString alloc] initWithAttributedString:attachmentString];
            [testString appendAttributedString:ulstring];
            
            cell.testInfoLabel.attributedText=testString;

        }
    }
    
    else
        //cell.testInfoLabel.hidden=true;
        //fulltestString=@"Empty";
        cell.testInfoLabel.text=@"";
    
    if (!([currentAccessionDict objectForKey:@"RdvmName"]==(id)[NSNull null]))
    {
        cell.dvmLabel.text= [NSString stringWithFormat:@"DVM: Dr %@",[currentAccessionDict objectForKey:@"RdvmName"]];
        cell.dvmLabel.hidden=false;
        cell.dvmHeightConstraint.constant=15;
    }
    else
    {
        cell.dvmLabel.hidden=TRUE;
        cell.dvmHeightConstraint.constant=0;
    }
    
    if (!([currentAccessionDict objectForKey:@"RefNumber"]==(id)[NSNull null]))
    {
        cell.referenceNumberLabel.text= [NSString stringWithFormat:@"Ref# %@",[currentAccessionDict objectForKey:@"RefNumber"]];
        cell.referenceNumberLabel.hidden=false;
    }
    else
        cell.referenceNumberLabel.hidden=TRUE;
    return cell;
}

- (void) filterAccessionsForSearchText:(NSString *) searchText scope:(NSString *)scope
{
    
    HttpClient *client = [HttpClient sharedHTTPClient];
    
    [activityView startAnimating];
    //[reqManager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    [client filterAccessionsWithSearchText:searchText WithSuccessBlock:^(AFHTTPRequestOperation *operation,id responseObject) {
        
        if ([searchText isEqualToString:currentSearchString])
        {
            [self.filteredAccList removeAllObjects];
            [self.filteredAccList addObjectsFromArray:[responseObject objectForKey:@"Accessions"]];
            NSLog(@"The count of the filter array is : %ld",(long)[self.filteredAccList count]);
            //[searchActivityIndicator stopAnimating];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideSearchIndicator];
                self.searchDisplayController.searchResultsTableView.tableHeaderView=nil;
            });
            
         [self.searchDisplayController.searchResultsTableView reloadData];
        }
        
    }andFailureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (![[AFNetworkReachabilityManager sharedManager] isReachable])
        {
            //[searchActivityIndicator stopAnimating];
            [self hideSearchIndicator];
            NSLog(@"Network Unreachable..display an alert to the user");
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Not connected to the internet" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            [self.navigationController popToRootViewControllerAnimated:NO];
            
        }
        NSLog(@"Error: Problem while fetching accessions on search: %@", error);
    }];
    
}


- (int)daysBetween:(NSDate *)dt1 and:(NSDate *)dt2 {
    NSUInteger unitFlags = NSDayCalendarUnit;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:unitFlags fromDate:dt1 toDate:dt2 options:0];
    return [components day]+1;
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat defaultCellHeight=115;
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
                currHeightOfCell = currHeightOfCell + ((numTestCount+1) * 15);
            }
        }
        else
        {
            if (indexPath.row < self.accessionList.count)
            {
                currCellDict= [self.accessionList objectAtIndex:indexPath.row];
                numTestCount = [self nonNullTestCountForArray:[currCellDict objectForKey:@"Tests"]];
                
                if (numTestCount>0)
                    currHeightOfCell = currHeightOfCell + ((numTestCount+1) * 15);
                
                //                if(!([currCellDict objectForKey:@"RefNumber"]==(id)[NSNull null]))
                //                    currHeightOfCell=currHeightOfCell+20;
                //                if(!([currCellDict objectForKey:@"RdvmName"]==(id)[NSNull null]))
                //                    currHeightOfCell=currHeightOfCell+20;
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
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        });
        return;
    }
    
    if (self.selectedIndex!=-1){
        
        NSIndexPath *prevPath = [NSIndexPath indexPathForRow:self.selectedIndex inSection:0];
        //[tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:prevPath] withRowAnimation:UITableViewRowAnimationFade];
        dispatch_async(dispatch_get_main_queue(), ^{
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:prevPath] withRowAnimation:UITableViewRowAnimationFade];
        });
    }
    
    self.selectedIndex=(int)indexPath.row;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    });
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
    
    //    if([cell.backgroundView.layer.sublayers count] >0)
    //    {
    //        if([[cell.backgroundView.layer.sublayers objectAtIndex:0] isKindOfClass:[CAGradientLayer class]])
    //        {
    //
    //            [[cell.backgroundView.layer.sublayers objectAtIndex:0] removeFromSuperlayer];
    //
    //        }
    //    }
    
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


//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UILabel * sectionHeader = [[UILabel alloc] initWithFrame:CGRectZero];
//    sectionHeader.backgroundColor = [UIColor purpleColor];
//    sectionHeader.textAlignment = NSTextAlignmentCenter;
//    sectionHeader.font = [UIFont boldSystemFontOfSize:14];
//    sectionHeader.textColor = [UIColor whiteColor];
//    
//    sectionHeader.text=@"ACCESSION STATUS";
//    
//    return sectionHeader;
//    
//}


//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    
//    return 24;
//}



# pragma mark SearchBar delegate method

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    
    NSLog(@"Search String is :%@",searchString);
    currentSearchString=searchString;
    controller.searchResultsTableView.tableHeaderView= [self SearchIndicatorView];
    
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
        //destViewController.clientName=clientBusinessName;
        destViewController.clientName=[cellDetails objectForKey:@"ClinicName"];
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
    if ([[AFNetworkReachabilityManager sharedManager] isReachable])
    {
        [self performSegueWithIdentifier:@"viewreport" sender:indexPath];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"Please verify your internet connection and try again"];
    }
}

-(void) accessionaddtestFor:(NSIndexPath *)indexPath{
    NSLog(@"Button Clicked at Index %ld",(long)indexPath.row);
    [self performSegueWithIdentifier:@"addtest" sender:indexPath];
}

@end