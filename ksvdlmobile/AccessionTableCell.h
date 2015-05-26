//
//  AccessionTableCell.h
//  ksvdlmobile
//
//  Created by Praveen on 5/26/15.
//  Copyright (c) 2015 Praveen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccessionTableCell : UITableViewCell
    @property (nonatomic,weak) IBOutlet UILabel *ownerLabel;
    @property (nonatomic,weak) IBOutlet UILabel *statusLabel;
    @property (nonatomic,weak) IBOutlet UILabel *accessionLabel;
    @property (nonatomic,weak) IBOutlet UILabel *receivedDateLabel;
    @property (nonatomic,weak) IBOutlet UILabel *finalizedDateLabel;
    @property (nonatomic,weak) IBOutlet UILabel *caseCoordinatorLabel;
@end
