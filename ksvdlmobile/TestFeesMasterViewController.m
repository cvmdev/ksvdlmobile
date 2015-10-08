//
//  TestFeesMasterViewController.m
//  ksvdlmobile
//
//  Created by Praveen on 10/5/15.
//  Copyright (c) 2015 Praveen. All rights reserved.
//

#import "TestFeesMasterViewController.h"
#import "SWRevealViewController.h"
#import "HttpClient.h"
#import "SVProgressHUD.h"
#import "TestFeesDetailViewController.h"

NSString * const testFeesTableIdentifier = @"TestFeesCell";

@interface TestFeesMasterViewController()

@property (nonatomic, strong) TestFeesTableCell *prototypeCell;

@end

@implementation TestFeesMasterViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    
    //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.menubarButton setTarget: self.revealViewController];
    [self.menubarButton setAction: @selector( rightRevealToggle: )];
    

    
    //  UIBarButtonItem *backBtn =[[UIBarButtonItem alloc]initWithTitle:@"HOME" style:UIBarButtonItemStyleDone target:self action:@selector(popToRoot:)];
   
    
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
//
//    self.tableView.estimatedRowHeight = 200;
    
    self.testfeesList = [NSMutableArray array];
    self.filteredTestFeesList=[NSMutableArray array];
    [SVProgressHUD showWithStatus:@"Loading"];
    [self fetchTestAndFees];
    self.searchDisplayController.searchResultsTableView.rowHeight = UITableViewAutomaticDimension;
    self.searchDisplayController.searchResultsTableView.estimatedRowHeight=UITableViewAutomaticDimension;

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

- (void) fetchTestAndFees
{
    HttpClient *client = [HttpClient sharedHTTPClient];

   [client fetchTestAndFeesWithSuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
       
       NSLog(@"Test Fees Fetch is success");
       //NSLog(@"The data is %@",responseObject);
    [self.testfeesList addObjectsFromArray:[responseObject objectForKey:@"TestFees"]];
       NSLog(@"The count of the array is :%ld",self.testfeesList.count);
    [self.tableView reloadData];
    [SVProgressHUD dismiss];
       
   } andFailureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
       [SVProgressHUD dismiss];
       if (![[AFNetworkReachabilityManager sharedManager] isReachable])
       {
           NSLog(@"Network Unreachable..display an alert to the user");
          
           [SVProgressHUD showErrorWithStatus:@"Not connected to the internet,please verify"];
           
           [self.navigationController popToRootViewControllerAnimated:NO];
           
       }
       else
       {
           NSLog(@"Some Error while fetching accession data--");
           NSLog(@"Error is %@",error);
          
           [SVProgressHUD showErrorWithStatus:@"Problem while fetching TestFees, please try again"];
           
           [self.navigationController popToRootViewControllerAnimated:NO];
       }
       
   }];
}

//- (TestFeesTableCell *)prototypeCell
//{
//    if (!_prototypeCell)
//    {
//        _prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:testFeesTableIdentifier];
//    }
//    return _prototypeCell;
//}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 300.0;
    }
    else
    return UITableViewAutomaticDimension;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.filteredTestFeesList count];
    } else {
    return [self.testfeesList count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [self configureCell:self.prototypeCell forRowAtIndexPath:indexPath];
//    
//    self.prototypeCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(self.prototypeCell.bounds));
//    
//    
//    [self.prototypeCell layoutIfNeeded];
//
//    CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//    return size.height+1;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 120.0;
    }
    else
    return UITableViewAutomaticDimension;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    NSDictionary *currentDict= nil;

    
    TestFeesTableCell *cell = [self.tableView dequeueReusableCellWithIdentifier:testFeesTableIdentifier forIndexPath:indexPath];

    if (cell == nil) {
        cell = [[TestFeesTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:testFeesTableIdentifier];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        currentDict = [self.filteredTestFeesList objectAtIndex:indexPath.row];
        //NSLog(@"Filtered dictionary test name is :%@",[currentDict objectForKey:@"TestName"]);
        
    } else {
        currentDict = [self.testfeesList objectAtIndex:indexPath.row];
    }
    
    [self configureCell:cell forRowAtIndexPath:indexPath fromDictionary:currentDict];

    return cell;
    
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath fromDictionary:(NSDictionary *) testFeesDict
{
    
   
    //[self.testfeesList objectAtIndex:indexPath.row];

    //if ([cell isKindOfClass:[TestFeesTableCell class]])
    //{
        TestFeesTableCell * testfeesCell = (TestFeesTableCell *) cell;
        
        testfeesCell.testNameLabel.text=[testFeesDict objectForKey:@"TestName"];
        
        if (!([testFeesDict objectForKey:@"Specimen"]==(id)[NSNull null]))
            testfeesCell.specimenLabel.text=[NSString stringWithFormat:@"Specimen: %@",[testFeesDict objectForKey:@"Specimens"]];
        else
            testfeesCell.specimenLabel.text=@"Specimen:";

        if (!([testFeesDict objectForKey:@"Species"]==(id)[NSNull null]))
            testfeesCell.speciesLabel.text=[NSString stringWithFormat:@"Species: %@",[testFeesDict objectForKey:@"Species"]];
        else
            testfeesCell.speciesLabel.text=@"Species:";
        
        if (!([testFeesDict objectForKey:@"Pricing"]==(id)[NSNull null]))
            testfeesCell.priceLabel.text=[NSString stringWithFormat:@"Price: %@",[testFeesDict objectForKey:@"Pricing"]];
        else
            testfeesCell.priceLabel.text=@"Price:";

    //}
}

- (void)filterTestFees:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"TestName contains[c] %@", searchText];
    NSPredicate *specimenPredicate = [NSPredicate predicateWithFormat:@"Specimens contains[c] %@", searchText];
    NSPredicate *speciesPredicate = [NSPredicate predicateWithFormat:@"Species contains[c] %@", searchText];

    NSPredicate *finalPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[namePredicate,speciesPredicate,specimenPredicate]];
    [self.filteredTestFeesList removeAllObjects];
    
    self.filteredTestFeesList = [NSMutableArray arrayWithArray:[self.testfeesList filteredArrayUsingPredicate:finalPredicate]];
    NSLog(@"Filter Search count is ######################################:%ld",self.filteredTestFeesList.count);
    [self.searchDisplayController.searchResultsTableView reloadData];

}

//- (void)searchDisplayController: (UISearchDisplayController *)controller
// willShowSearchResultsTableView: (UITableView *)searchTableView {
//    
//    searchTableView.rowHeight = UITableViewAutomaticDimension;
//}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    //NSLog(@"Reload Called");
    [self filterTestFees:searchString
                scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"TestFeesDetailScreen"])
    {
        //NSIndexPath *indexPath = (NSIndexPath *)sender;
        NSDictionary * cellDetails = nil;
        if (self.searchDisplayController.active)
            cellDetails=[self.filteredTestFeesList objectAtIndex:[self.searchDisplayController.searchResultsTableView indexPathForSelectedRow].row];
        else
        cellDetails=[self.testfeesList objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        NSLog(@"Test Fees Detail is %@",cellDetails);
        TestFeesDetailViewController *destViewController = segue.destinationViewController;
        destViewController.testFeesDetailDict=cellDetails;
        
    }
}



@end