//
//  AccessionTableViewController.h
//  ksvdlmobile
//
//  Created by Praveen on 5/26/15.
//  Copyright (c) 2015 Praveen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "AuthAPIClient.h"
#import "AccessionTableCell.h"
#import "SVProgressHUD.h"

@interface AccessionTableViewController : UITableViewController<AccCellDelegate,UITableViewDelegate,UITableViewDataSource>
    @property (strong,nonatomic) NSMutableArray *accessionList;
    @property (strong,nonatomic) NSMutableArray *filteredAccList;
    @property NSInteger currentPage;
    @property NSInteger totalPages;
@property (weak,nonatomic) IBOutlet UIBarButtonItem *barButton1;
    -(void) fetchAccessions;
@end
