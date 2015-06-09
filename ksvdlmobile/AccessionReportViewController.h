//
//  AccessionReportViewController.h
//  ksvdlmobile
//
//  Created by Praveen on 5/28/15.
//  Copyright (c) 2015 Praveen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDFKBasicPDFViewer.h"
#import "PDFKDocument.h"

@interface AccessionReportViewController : PDFKBasicPDFViewer
 @property (nonatomic) NSString * accessionNumber;
@end
