//
//  AccessionReportViewController.m
//  ksvdlmobile
//
//  Created by Praveen on 5/28/15.
//  Copyright (c) 2015 Praveen. All rights reserved.
//

#import "AccessionReportViewController.h"
#import "SVProgressHUD.h"

@implementation AccessionReportViewController

-(void) viewDidLoad {
    
    [super viewDidLoad];
    
    [SVProgressHUD showWithStatus:@"Loading"];
    
    NSLog(@"Accession Number from previous controller is :%@",self.accessionNumber);
    
    
    
    if ([self downloadReportForAccession:self.accessionNumber])
    {
        self.enableBookmarks = YES;
        self.enableOpening = YES;
        self.enablePrinting = YES;
        self.enableSharing = YES;
        self.enableThumbnailSlider = YES;
        self.standalone=YES;
        
        NSString *tmpDirectory=NSTemporaryDirectory();
        NSString *fileName = [NSString stringWithFormat:@"%@.pdf",self.accessionNumber];
        NSString *filePath = [tmpDirectory
                              stringByAppendingPathComponent:fileName];
        
        
        NSLog(@"PDF to be retrieved: %@",filePath);
        
        PDFKDocument *document =[PDFKDocument documentWithContentsOfFile:filePath password:nil];
        [self loadDocument:document];

    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"There was a problem downloading the report" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    [SVProgressHUD dismiss];
}

-(BOOL) downloadReportForAccession:(NSString *) accNum
{
    
    NSString *pdlUrlString = [NSString stringWithFormat:@"http://129.130.128.31/TestProjects/TestAuthAPI/api/Orders/Report?accessionNumber=%@",accNum];
    
    NSData *pdfData = [[NSData alloc] initWithContentsOfURL:[
                                                             NSURL URLWithString:pdlUrlString]];
    
    NSLog(@"desc/length is :%lu",(unsigned long)pdfData.length);
    
    if (pdfData.length>0)
    {
        NSString *tmpDirectory=NSTemporaryDirectory();
        NSString *fileName = [NSString stringWithFormat:@"%@.pdf",accNum];
        NSString *filePath = [tmpDirectory
                              stringByAppendingPathComponent:fileName];
       
        NSLog(@"FilePath is :%@",filePath);
        
        [pdfData writeToFile:filePath atomically:YES];
        
        NSLog(@"PDF written locally");
        
        return true;
    }
    return false;
}



@end
