//
//  AccessionTableCell.h
//  ksvdlmobile
//
//  Created by Praveen on 5/26/15.
//  Copyright (c) 2015 Praveen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AccCellDelegate <NSObject>

- (void)accessionReportFor:(NSIndexPath *) indexPath;

- (void)accessionaddtestFor:(NSIndexPath *) indexPath;

@end

@interface AccessionTableCell : UITableViewCell
    @property (nonatomic,weak) IBOutlet UILabel *ownerLabel;
    @property (nonatomic,weak) IBOutlet UILabel *statusLabel;
    @property (nonatomic,weak) IBOutlet UILabel *accessionLabel;
    @property (nonatomic,weak) IBOutlet UILabel *receivedDateLabel;
    @property (nonatomic,weak) IBOutlet UILabel *finalizedDateLabel;
    @property (weak, nonatomic) IBOutlet UIButton *viewreportButton;
    @property (nonatomic,weak) IBOutlet UILabel *caseCoordinatorLabel;
    @property (nonatomic,weak) IBOutlet UILabel *referenceNumberLabel;
    @property (nonatomic,weak) IBOutlet UILabel *testInfoLabel;
    @property (nonatomic,weak) IBOutlet UILabel *dvmLabel;
- (IBAction)viewReport:(id)sender;
- (IBAction)addTest:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *addtestButton;

//Manual Properties
@property (strong,nonatomic) NSIndexPath *buttonIndexPath;

@property (nonatomic,weak) id <AccCellDelegate> accReportDelegate;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *caseCoordinatorHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dvmHeightConstraint;


@end
