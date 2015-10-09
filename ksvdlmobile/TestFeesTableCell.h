//
//  TestFeesTableCell.h
//  ksvdlmobile
//
//  Created by Praveen on 10/5/15.
//  Copyright (c) 2015 Praveen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestFeesTableCell : UITableViewCell
@property(nonatomic,weak) IBOutlet UILabel *testNameLabel;
@property(nonatomic,weak) IBOutlet UILabel *speciesLabel;
@property(nonatomic,weak) IBOutlet UILabel *specimenLabel;
@property(nonatomic,weak) IBOutlet UILabel *priceLabel;
//@property(strong,nonatomic) IBOutlet UILabel *sectionLabel;

@end
