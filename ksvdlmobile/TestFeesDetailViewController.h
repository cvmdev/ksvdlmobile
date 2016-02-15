//
//  TestFeesDetailViewController.h
//  ksvdlmobile
//
//  Created by Praveen on 10/6/15.
//  Copyright (c) 2015 Praveen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"

@interface TestFeesDetailViewController : UIViewController<TTTAttributedLabelDelegate>

@property (weak,nonatomic) IBOutlet UIBarButtonItem *menubarButton;
@property NSDictionary *testFeesDetailDict;
@property (weak,nonatomic) IBOutlet UILabel *TestNameLabel;
@property (weak,nonatomic) IBOutlet UILabel *SectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *SpecimenLabel;
@property (weak, nonatomic) IBOutlet UILabel *SpeciesLabel;
@property (weak, nonatomic) IBOutlet UILabel *PriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *SampleContrainerLabel;
@property (weak, nonatomic) IBOutlet UILabel *ShippingPreserveLabel;
@property (weak, nonatomic) IBOutlet UILabel *DaysTestedLabel;
@property (weak, nonatomic) IBOutlet UILabel *EstimatedTurnaroundLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *TestCommentsLabel;
@property (weak, nonatomic) IBOutlet UILabel *DeliveryMethodLabel;
@property (weak, nonatomic) IBOutlet UILabel *ProcedureLabel;
@property (weak, nonatomic) IBOutlet UILabel *SectionGroupLabel;

@end
