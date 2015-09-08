//
//  AccessionTableCell.m
//  ksvdlmobile
//
//  Created by Praveen on 5/26/15.
//  Copyright (c) 2015 Praveen. All rights reserved.
//

#import "AccessionTableCell.h"

@implementation AccessionTableCell
    @synthesize ownerLabel;
    @synthesize statusLabel;
    @synthesize accessionLabel;
    @synthesize receivedDateLabel;
    @synthesize finalizedDateLabel;
    @synthesize caseCoordinatorLabel;
    @synthesize referenceNumberLabel;
    @synthesize dvmLabel;
@synthesize caseCoordinatorHeightConstraint;
- (IBAction)viewReport:(id)sender {
    
    [self.accReportDelegate accessionReportFor:self.buttonIndexPath];
}

- (IBAction)addTest:(id)sender {
    
    [self.accReportDelegate accessionaddtestFor:self.buttonIndexPath];
}

@end
