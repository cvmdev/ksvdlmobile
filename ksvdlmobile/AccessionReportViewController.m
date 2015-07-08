//
//  AccessionReportViewController.m
//  ksvdlmobile
//
//  Created by Praveen on 5/28/15.
//  Copyright (c) 2015 Praveen. All rights reserved.
//

#import "AccessionReportViewController.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
//#import "AFOAuth2Client.h"
#import "GlobalConstants.h"
#import "AuthAPIClient.h"
#import "HttpClient.h"
const int retryCount=2;
@implementation AccessionReportViewController

-(void) viewDidLoad {
    
    [SVProgressHUD showWithStatus:@"Loading"];
    
    [super viewDidLoad];
    
    NSLog(@"Accession Number from previous controller is :%@",self.accessionNumber);
    
    [self downloadReportForAccession:self.accessionNumber];
 
//    else
//    {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"There was a problem downloading the report" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alertView show];
//    }
    }

-(void) downloadReportForAccession:(NSString *) accNum
{
    
//    NSString *pdfUrlString = [NSString stringWithFormat:@"http://129.130.128.31/TestProjects/TestAuthAPI/api/Orders/Report?accessionNumber=%@",accNum];
//   
//    AFOAuthCredential  *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:@"VetViewID"];
//    
//    if ([[AuthAPIClient sharedClient] isSignInRequired])
//    {
//        NSLog(@"ATVC:User is not logged in , send to login screen");
//    }
//    else
//    {
//        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//        
//        NSURL *pdfURL = [NSURL URLWithString:pdfUrlString];
//        
//        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:pdfURL];
//        
//        NSString *authToken = [NSString stringWithFormat:@"Bearer %@",credential.accessToken];
//        
//        [request setValue:authToken forHTTPHeaderField:@"Authorization"];
//        
//        NSString *fileName= [NSString stringWithFormat:@"%@.pdf",accNum];
//        
//        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
//            NSURL *directoryURL = [NSURL fileURLWithPath:NSTemporaryDirectory()];
//            return [directoryURL URLByAppendingPathComponent:fileName];
//            } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
//                
//                NSLog(@"PDF File downloaded to: %@", filePath);
//                self.enableBookmarks = YES;
//                self.enableOpening = YES;
//                self.enablePrinting = YES;
//                self.enableSharing = YES;
//                self.enableThumbnailSlider = YES;
//                self.standalone=YES;
//                
//                NSString *savedFilePath = [self getTempFilePathForAccession];
//                NSLog(@"PDF to be display from temp directory: %@",filePath);
//                
//                PDFKDocument *document =[PDFKDocument documentWithContentsOfFile:savedFilePath password:nil];
//                [self loadDocument:document];
//                
//                [SVProgressHUD dismiss];
//            
//        }];
//        [downloadTask resume];
//   }

    HttpClient * client = [HttpClient sharedHTTPClient];
    
    [client downloadReportForAccession:accNum WithRetryCounter:retryCount WithCompletionBlock:^(BOOL finished) {
        if (finished)
        {
          
            self.enableBookmarks = YES;
            self.enableOpening = YES;
            self.enablePrinting = YES;
            self.enableSharing = YES;
            self.enableThumbnailSlider = YES;
            self.standalone=YES;

            NSString *savedFilePath = [self getTempFilePathForAccession];

            PDFKDocument *document =[PDFKDocument documentWithContentsOfFile:savedFilePath password:nil];
            [self loadDocument:document];
            
            [SVProgressHUD dismiss];

        }
    }];
}

- (void) viewWillDisappear:(BOOL)animated {
    
    //delete the temp file that was created
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:[self getTempFilePathForAccession] error:&error];
    NSLog(@"Temp File deleted successfully");

}

-(NSString *) getTempFilePathForAccession
{
    NSString *tmpDirectory=NSTemporaryDirectory();
    NSString *fileName = [NSString stringWithFormat:@"%@.pdf",self.accessionNumber];
    NSString *filePath = [tmpDirectory
                          stringByAppendingPathComponent:fileName];
        return filePath;
}

@end
