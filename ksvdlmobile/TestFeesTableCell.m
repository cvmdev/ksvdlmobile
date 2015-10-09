//
//  TestFeesTableCell.m
//  ksvdlmobile
//
//  Created by Praveen on 10/5/15.
//  Copyright (c) 2015 Praveen. All rights reserved.
//

#import "TestFeesTableCell.h"

@implementation TestFeesTableCell
@synthesize testNameLabel;
@synthesize specimenLabel;
@synthesize speciesLabel;
@synthesize priceLabel;

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.contentView layoutIfNeeded];
    self.specimenLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.specimenLabel.frame);
}

@end
