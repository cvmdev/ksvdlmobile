//
//  TestFeesMasterViewController.h
//  ksvdlmobile
//
//  Created by Praveen on 10/5/15.
//  Copyright (c) 2015 Praveen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestFeesTableCell.h"
@interface TestFeesMasterViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak,nonatomic) IBOutlet UIBarButtonItem *menubarButton;

@property (strong,nonatomic) NSMutableArray *testfeesList;
@property (strong,nonatomic) NSMutableArray *filteredTestFeesList;

@end
