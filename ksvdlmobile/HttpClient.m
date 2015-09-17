//
//  HttpClient.m
//  ksvdlmobile
//
//  Created by Praveen on 7/6/15.
//  Copyright (c) 2015 Praveen. All rights reserved.
//

#import "HttpClient.h"
#import "GlobalConstants.h"
#import "AuthAPIClient.h"
#import <sys/utsname.h>


@implementation HttpClient

+ (HttpClient *) sharedHTTPClient
{
    NSLog(@"Initializing HTTPClient");
    static HttpClient *sharedHTTPClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        sharedHTTPClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    });
    
    return sharedHTTPClient;
    
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self) {
        NSLog(@"Before initialization");
        AFOAuthCredential  *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:kCredentialIdentifier];
        NSLog(@"After initialization");

        self.responseSerializer = [AFJSONResponseSerializer serializer];
        AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
        
        [serializer setValue:[NSString stringWithFormat:@"Bearer %@", credential.accessToken] forHTTPHeaderField:@"Authorization"];
        self.requestSerializer = serializer;
 
    }
    
    return self;
}

- (void)settingDidChange:(NSNotification*)notification {
    NSLog(@"at settingsdidchange event...");
//    if ([notification.object isEqual:@"sample_arr"]) {
//        BOOL samplearrival1 = (BOOL)[[notification.userInfo objectForKey:@"sample_arr"] intValue];
//    }
//    if ([notification.object isEqual:@"prelim_results"]) {
//        BOOL prelimresults1 = (BOOL)[[notification.userInfo objectForKey:@"prelim_results"] intValue];
//    }
//    if ([notification.object isEqual:@"final_result"]) {
//        BOOL finalresults1 = (BOOL)[[notification.userInfo objectForKey:@"final_result"] intValue];
    //}
      //[[NSUserDefaults standardUserDefaults] synchronize];
    [self updateNotifications];
   }



-(void) updateCredential:(AFOAuthCredential *)credential{
    AFHTTPRequestSerializer *currentserializer= (AFHTTPRequestSerializer *)self.requestSerializer;
    [currentserializer setValue:[NSString stringWithFormat:@"Bearer %@", credential.accessToken] forHTTPHeaderField:@"Authorization"];
}



- (void) fetchAccessionsForPageNo:(NSInteger)pageNo WithSuccessBlock:(ApiClientSuccess)successBlock andFailureBlock:(ApiClientFailure)failureBlock {
    
    __block int retryCounter=kRetryCount;
    void (^processSuccessBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(operation,responseObject);
    };
    
    void (^processFailureBlock)(AFHTTPRequestOperation *operation, NSError *error) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        
        __weak typeof(self) weakSelf=self;
        if (operation.response.statusCode == 500) {
            NSLog(@"Got an internal server error while fetching accessions");
            NSLog(@"Full Error:%@",error);
            
            NSLog(@"Error:%@",error.userInfo);
            NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
            NSLog(@"The internal server error is :%@",serializedData);
            
            //failureBlock(operation,error);
        }
        
        if (retryCounter>0)
        {
            retryCounter--;
            if (operation.response.statusCode==500)
            {
                if (retryCounter<=1)
                {
                    NSLog(@"Sleeping for a few seconds...");
                    [NSThread sleepForTimeInterval:2.0f];
                }
                NSLog(@"Retrying the operation again after internal server error with Retry Counter value:%d",retryCounter);
                [weakSelf retryOperationForOperation:operation WithSuccessBlock:successBlock AndFailureBlock:processFailureBlock];
            }
            if (operation.response.statusCode == 401) {
                NSLog(@"Authorization is denied,so refreshing credentials");
                
                [[AuthAPIClient sharedClient] refreshTokenWithSuccess:^(AFOAuthCredential *newCredential){
                    
                    NSLog(@"Refresh Success:Update serializer token string value");
                    [weakSelf updateCredential:newCredential];
                    NSLog(@"Retrying the operation after refreshing token");
                    [weakSelf retryOperationForOperation:operation WithSuccessBlock:successBlock AndFailureBlock:failureBlock];
                    
                }failure:^(NSError *error){
                    NSLog(@"Refresh Token Failure");
                    NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                    NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
                    NSLog(@"The dictionary has :%@",serializedData);
                    if ([serializedData objectForKey:@"error"])
                    {
                        NSString * errorReason = [serializedData objectForKey:@"error"];
                        if ([errorReason isEqualToString:@"invalid_grant"])
                        {
                            NSLog(@"Failed to refresh token");
                            [AFOAuthCredential deleteCredentialWithIdentifier:kCredentialIdentifier];
                            NSLog(@"Credential  Deleted");
                            
                            failureBlock(operation,error);
                        }
                    }
                }];
            }
            else
            {
                NSLog(@"Unknown Error:%@",error);
                failureBlock(operation,error);
            }
            
        }
        else
        {
            NSLog(@"All the retries have been finished or internet connection not available...Maybe a message indicating that something went wrong");
            
            failureBlock(operation,error);
            
            
        }

        
        
    };
    
    //NSString *Accessions = [NSString stringWithFormat:@"Accessions?pageNo=%ld",(long)pageNo];
    NSString *Accessions = [NSString stringWithFormat:@"AccTests?pageNo=%ld",(long)pageNo];
    
    NSLog(@"Fetching Accessions for Page No:%ld",(long)pageNo);
    __weak typeof(self) weakSelf=self;
    
    [self GET:Accessions parameters:nil
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          processSuccessBlock(operation, responseObject);
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          processFailureBlock(operation, error);
          
                }];
}




//- (void) fetchAccessionsForPageNo:(NSInteger)pageNo WithSuccessBlock:(ApiClientSuccess)successBlock andFailureBlock:(ApiClientFailure)failureBlock {
//    
//    __block int retryCounter=kRetryCount;
//    void (^processSuccessBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        successBlock(operation,responseObject);
//    };
//    
//    void (^processFailureBlock)(AFHTTPRequestOperation *operation, NSError *error) = ^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        
//        if (operation.response.statusCode == 500) {
//            NSLog(@"Got an internal server error while fetching accessions");
//            NSLog(@"Full Error:%@",error);
//
//            NSLog(@"Error:%@",error.userInfo);
//            NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
//            NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
//            NSLog(@"The internal server error is :%@",serializedData);
//            
//            //failureBlock(operation,error);
//        }
//    };
//    
//    //NSString *Accessions = [NSString stringWithFormat:@"Accessions?pageNo=%ld",(long)pageNo];
//    NSString *Accessions = [NSString stringWithFormat:@"AccTests?pageNo=%ld",(long)pageNo];
//    
//    NSLog(@"Fetching Accessions for Page No:%ld",(long)pageNo);
//    __weak typeof(self) weakSelf=self;
//    
//    [self GET:Accessions parameters:nil
//      success:^(AFHTTPRequestOperation *operation, id responseObject) {
//          processSuccessBlock(operation, responseObject);
//      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//          processFailureBlock(operation, error);
//         
//              if (retryCounter>0)
//              {
//                  retryCounter--;
//                  if (operation.response.statusCode==500)
//                  {
//                      if (retryCounter<=1)
//                      {
//                          NSLog(@"Sleeping for a few seconds...");
//                          [NSThread sleepForTimeInterval:2.0f];
//                      }
//                      NSLog(@"Retrying the operation again after internal server error with Retry Counter value:%d",retryCounter);
//                      [weakSelf retryOperationForOperation:operation WithSuccessBlock:successBlock AndFailureBlock:failureBlock];
//                  }
//                  if (operation.response.statusCode == 401) {
//                              NSLog(@"Authorization is denied,so refreshing credentials");
//                              
//                              [[AuthAPIClient sharedClient] refreshTokenWithSuccess:^(AFOAuthCredential *newCredential){
//                                  
//                               NSLog(@"Refresh Success:Update serializer token string value");
//                               [weakSelf updateCredential:newCredential];
//                               NSLog(@"Retrying the operation after refreshing token");
//                               [weakSelf retryOperationForOperation:operation WithSuccessBlock:successBlock AndFailureBlock:failureBlock];
//                      
//                          }failure:^(NSError *error){
//                              NSLog(@"Refresh Token Failure");
//                              NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
//                              NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
//                              NSLog(@"The dictionary has :%@",serializedData);
//                              if ([serializedData objectForKey:@"error"])
//                                  {
//                                      NSString * errorReason = [serializedData objectForKey:@"error"];
//                                      if ([errorReason isEqualToString:@"invalid_grant"])
//                                      {
//                                          NSLog(@"Failed to refresh token");
//                                          [AFOAuthCredential deleteCredentialWithIdentifier:kCredentialIdentifier];
//                                          NSLog(@"Credential  Deleted");
//
//                                          failureBlock(operation,error);
//                                      }
//                                  }
//                          }];
//                  }
//                  else
//                  {
//                      NSLog(@"Unknown Error:%@",error);
//                      failureBlock(operation,error);
//                  }
//                  
//              }
//             else
//             {
//                 NSLog(@"All the retries have been finished or internet connection not available...Maybe a message indicating that something went wrong");
//                
//                 failureBlock(operation,error);
//                 
//
//             }
//      }];
//}

-(void) retryOperationForOperation:(AFHTTPRequestOperation *)operation
                  WithSuccessBlock:(void (^)(AFHTTPRequestOperation *operation, id responseObject)) success
                  AndFailureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
    
                      AFHTTPRequestOperation *retryOperation = [self retryRequestForOperation:operation];
                      [retryOperation setCompletionBlockWithSuccess:success
                                                            failure:failure];
    
                      [retryOperation start];
                      NSLog(@"Operation Retried");

    
}


-(void)filterAccessionsWithSearchText:(NSString *)searchText WithSuccessBlock:(ApiClientSuccess)successBlock andFailureBlock:(ApiClientFailure)failureBlock {
    __block int retryCounter=kRetryCount;
    void (^processSuccessBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        successBlock(operation,responseObject);
    };
    
    void (^processFailureBlock)(AFHTTPRequestOperation *operation, NSError *error) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        if (operation.response.statusCode == 500) {
            NSLog(@"Got an internal server error while accession search");
            NSLog(@"Error:%@",error.userInfo);
            NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
            NSLog(@"The internal server error is :%@",serializedData);
            
            //failureBlock(operation,error);
        }
    };
    
    searchText = [searchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSString *FilterAccessions = [NSString stringWithFormat:@"FilterAccessions?searchString=%@",searchText];
    
    NSLog(@"Fetching Accessions for Search String....");
    __weak typeof(self) weakSelf=self;
    
    [self GET:FilterAccessions parameters:nil
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          processSuccessBlock(operation, responseObject);
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          processFailureBlock(operation, error);
          if (retryCounter>0)
          {
              retryCounter--;
              if (operation.response.statusCode==500)
              {
                  NSLog(@"Retrying the accession search operation again after internal server error");
                  [weakSelf retryOperationForOperation:operation WithSuccessBlock:successBlock AndFailureBlock:failureBlock];
              }
              if (operation.response.statusCode == 401) {
                  NSLog(@"Authorization is denied,so refreshing credentials");
                  
                  [[AuthAPIClient sharedClient] refreshTokenWithSuccess:^(AFOAuthCredential *newCredential){
                      
                      NSLog(@"Refresh Success:Update serializer token string value");
                      [weakSelf updateCredential:newCredential];
                      NSLog(@"Retrying the operation after refreshing token");
                      [weakSelf retryOperationForOperation:operation WithSuccessBlock:successBlock AndFailureBlock:failureBlock];
                      
                  }failure:^(NSError *error){
                      NSLog(@"Refresh Token Failure");
                      NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                      NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
                      NSLog(@"The dictionary has :%@",serializedData);
                      if ([serializedData objectForKey:@"error"])
                      {
                          NSString * errorReason = [serializedData objectForKey:@"error"];
                          if ([errorReason isEqualToString:@"invalid_grant"])
                          {
                              NSLog(@"Failed to refresh token");
                              [AFOAuthCredential deleteCredentialWithIdentifier:kCredentialIdentifier];
                              NSLog(@"Credential  Deleted");
                              
                              failureBlock(operation,error);
                          }
                      }
                  }];
              }
              else
              {
                  NSLog(@"Unknown Error:%@",error);
                  failureBlock(operation,error);
              }
              
          }
          else
          {
              NSLog(@"All the retries have been finished or internet connection not available...Maybe a message indicating that something went wrong");
              
              failureBlock(operation,error);
              
          }
      }];

    
}

- (void) validateAccessionFor:(NSString *) accNum WithSuccessBlock:(ApiClientSuccess)successBlock andFailureBlock:(ApiClientFailure)failureBlock {
    __block int retryCounter=1;
    void (^processSuccessBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        successBlock(operation,responseObject);
    };
    
    void (^processFailureBlock)(AFHTTPRequestOperation *operation, NSError *error) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        if (operation.response.statusCode == 500) {
            failureBlock(operation,error);
        }
    };
    NSString *validateAccession = [NSString stringWithFormat:@"ValidateAccession?accessionNumber=%@",accNum];
    
    NSLog(@"Validating Accession for Showing Report...%@",accNum);
    
    __weak typeof(self) weakSelf=self;
    [self GET:validateAccession parameters:nil
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          processSuccessBlock(operation, responseObject);
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          processFailureBlock(operation, error);
          if (operation.response.statusCode == 401) {
              NSLog(@"Authorization is denied");
              if (retryCounter>0)
              {
                  
                  [[AuthAPIClient sharedClient] refreshTokenWithSuccess:^(AFOAuthCredential *newCredential){
                      
                      //NSLog(@"Access token refreshed");
                      //[weakself updateCredential:newCredential];
                      NSLog(@"Update serializer token string value");
                      [weakSelf updateCredential:newCredential];
                      retryCounter--;
                      AFHTTPRequestOperation *retryOperation = [self retryRequestForOperation:operation];
                      [retryOperation setCompletionBlockWithSuccess:processSuccessBlock
                                                            failure:processFailureBlock];
                      
                      NSLog(@"Retry operation starting..with retry counter:%ld",(long)retryCounter);
                      
                      [retryOperation start];
                      
                  }failure:^(NSError *error){
                      NSLog(@"Failed to refresh token");
                  }];
              }
          }
      }];

    
}


- (void) addDeviceToken:(NSString *)dToken WithSuccessBlock:(ApiClientSuccess)successBlock andFailureBlock:(ApiClientFailure)failureBlock {
    
    __block int retryCounter=kRetryCount;
    void (^processSuccessBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        successBlock(operation,responseObject);
    };
    
    void (^processFailureBlock)(AFHTTPRequestOperation *operation, NSError *error) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        if (operation.response.statusCode == 500) {
            NSLog(@"Got an internal server error while accession search");
            NSLog(@"Error:%@",error.userInfo);
            NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
            NSLog(@"The internal server error is :%@",serializedData);
            
            //failureBlock(operation,error);
        }
    };

   
    struct utsname systemInfo;
    uname(&systemInfo);
    NSLog(@"Device Type:%@",[NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding]);
    NSLog(@"OS Version:%@",[[UIDevice currentDevice] systemVersion]);
    NSString *deviceType=[NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSString *osVersion =[[UIDevice currentDevice] systemVersion];
    
    NSString * dInfo = [NSString stringWithFormat:@"%@-%@",deviceType,osVersion];

    //NSString *validateAccession = [NSString stringWithFormat:@"ValidateAccession?accessionNumber=%@",accNum];
    NSString *addDeviceToken = [NSString stringWithFormat:@"RegisterIOSDevice?deviceToken=%@&deviceInfo=%@",dToken,dInfo];
    __weak typeof(self) weakSelf=self;

    
    [self POST:addDeviceToken parameters:nil
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          processSuccessBlock(operation, responseObject);
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             processFailureBlock(operation, error);
          
          if (retryCounter>0)
          {
              retryCounter--;
              if (operation.response.statusCode==500)
              {
                  NSLog(@"Retrying add device token again after internal server error");
                  [weakSelf retryOperationForOperation:operation WithSuccessBlock:successBlock AndFailureBlock:failureBlock];
              }
              if (operation.response.statusCode == 401) {
                  NSLog(@"Authorization is denied,so refreshing credentials");
                  
                  [[AuthAPIClient sharedClient] refreshTokenWithSuccess:^(AFOAuthCredential *newCredential){
                      
                      NSLog(@"Refresh Success:Update serializer token string value");
                      [weakSelf updateCredential:newCredential];
                      NSLog(@"Retrying the add device token operation after refreshing token");
                      [weakSelf retryOperationForOperation:operation WithSuccessBlock:successBlock AndFailureBlock:failureBlock];
                      
                  }failure:^(NSError *error){
                      NSLog(@"Refresh Token Failure");
                      NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                      NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
                      NSLog(@"The dictionary has :%@",serializedData);
                      if ([serializedData objectForKey:@"error"])
                      {
                          NSString * errorReason = [serializedData objectForKey:@"error"];
                          if ([errorReason isEqualToString:@"invalid_grant"])
                          {
                              NSLog(@"Failed to refresh token");
                              [AFOAuthCredential deleteCredentialWithIdentifier:kCredentialIdentifier];
                              NSLog(@"Credential  Deleted");
                              
                              failureBlock(operation,error);
                          }
                      }
                  }];
              }
              else
              {
                  NSLog(@"Unknown Error:%@",error);
                  failureBlock(operation,error);
              }
              
          }
          else
          {
              NSLog(@"All the retries have been finished or internet connection not available...Maybe a message indicating that something went wrong");
              
              failureBlock(operation,error);
              
          }
          
      }];

}

-(void) updateNotifications{
    if (![[AuthAPIClient sharedClient] isSignInRequired])
    {
        [self updateNotificationsWithSuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Notifications updated successfully");
        } andFailureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Failure while updating notifications");
            
        }];
    }
}

-(void) updateNotificationsWithSuccessBlock:(ApiClientSuccess)successBlock andFailureBlock:(ApiClientFailure)failureBlock {
    
    __block int retryCounter=1;
    void (^processSuccessBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        successBlock(operation,responseObject);
    };
    
    void (^processFailureBlock)(AFHTTPRequestOperation *operation, NSError *error) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        if (operation.response.statusCode == 500) {
            failureBlock(operation,error);
        }
    };
    
    NSInteger newStatus = [[[NSUserDefaults standardUserDefaults] objectForKey:@"sample_arr"] integerValue];
    NSInteger prelimStatus= [[[NSUserDefaults standardUserDefaults] objectForKey:@"prelim_results"] integerValue];
    NSInteger finalStatus = [[[NSUserDefaults standardUserDefaults] objectForKey:@"final_result"] integerValue];
    
    NSLog(@"The new notification values to be updated to the db are :%ld-%ld-%ld",newStatus,prelimStatus,finalStatus);
    
    NSString *dToken= [[NSUserDefaults standardUserDefaults] objectForKey:kVDLDeviceTokenString];
    
     NSString *updateNotifications = [NSString stringWithFormat:@"Notifications?deviceToken=%@&newStatus=%ld&prelimStatus=%ld&finalStatus=%ld",dToken,newStatus,prelimStatus,finalStatus];
    NSLog(@"call url is %@:",updateNotifications);
    
    __weak typeof(self) weakSelf=self;

    [self POST:updateNotifications parameters:nil
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          processSuccessBlock(operation, responseObject);
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"Error While updating notifications....%@",error);
          processFailureBlock(operation, error);
          if (operation.response.statusCode == 401) {
              NSLog(@"Authorization is denied");
              if (retryCounter>0)
              {
                  [[AuthAPIClient sharedClient] refreshTokenWithSuccess:^(AFOAuthCredential *newCredential){
                      
                      //NSLog(@"Access token refreshed");
                      //[weakself updateCredential:newCredential];
                      NSLog(@"Update serializer token string value");
                      [weakSelf updateCredential:newCredential];
                      retryCounter--;
//                      AFHTTPRequestOperation *retryOperation = [weakSelf retryRequestForOperation:operation];
//                      [retryOperation setCompletionBlockWithSuccess:processSuccessBlock
//                                                            failure:processFailureBlock];
                      
                      NSLog(@"Retry operation starting for updating notifs..with retry counter:%ld",(long)retryCounter);
                      
                      [weakSelf POST:updateNotifications parameters:nil
                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                             processSuccessBlock(operation, responseObject);
                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                             NSLog(@"Error While updating notifications 2n time....%@",error);
                         }];
                   
                  }failure:^(NSError *error){
                      NSLog(@"Failed to refresh token");
                  }];
              }
        }
          else
          {
              failureBlock(operation,error);
          }
          
      }];

    
}

-(void) downloadReportForAccession:(NSString *)AccessionNo WithRetryCounter:(int) retryCount WithCompletionBlock:(CustomCompletionBlock)completionBlock{
    
    if(retryCount==0)
    {
        NSLog(@"Already retried once with an updated credential");
        return;
    }
    
    retryCount--;
    NSString *pdfUrlString = [NSString stringWithFormat:@"%@Report?accessionNumber=%@",kBaseURL,AccessionNo];
    
    //AFOAuthCredential  *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:@"VetViewID"];
    __block BOOL downloaded=NO;
    
    
    if ([[AuthAPIClient sharedClient] isSignInRequired])
    {
        NSLog(@"ATVC:User is not logged in , send to login screen");
    }
    else
    {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        NSURL *pdfURL = [NSURL URLWithString:pdfUrlString];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:pdfURL];
        
        NSString *authToken = [NSString stringWithFormat:@"Bearer %@",[[AuthAPIClient sharedClient] retrieveCredential].accessToken];
        
        [request setValue:authToken forHTTPHeaderField:@"Authorization"];
        
        NSString *fileName= [NSString stringWithFormat:@"%@.pdf",AccessionNo];
        
        __weak typeof(self) weakSelf=self;
        
        
        //The following removes the temporary file ...its possible that the file could have been corrupt
        NSString *tmpDirectory=NSTemporaryDirectory();

        //NSString *ex = [NSString stringWithFormat:@"%@.pdf",self.accessionNumber];
        NSString *filePath = [tmpDirectory
                              stringByAppendingPathComponent:fileName];
        
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
        
        if (fileExists)
        {
            NSLog(@"File already existed..so removing it");
            NSError *error = nil;
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        }
        
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            NSURL *directoryURL = [NSURL fileURLWithPath:NSTemporaryDirectory()];
            return [directoryURL URLByAppendingPathComponent:fileName];
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            
            if (!error)
            {
                NSLog(@"File downloaded successfully");
                NSLog(@"File Downloaded to: %@", filePath);
                downloaded=YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(downloaded);
                });
               
            }
            else
            {
                downloaded=NO;
                NSHTTPURLResponse *httpResponse=(NSHTTPURLResponse *) response;
                NSLog(@"The status code got back is :%ld",(long)httpResponse.statusCode);
                
                if (httpResponse.statusCode==401)
                {
                    NSLog(@"Refresh Credentials....as we got back 401 unauthorized");
                    [[AuthAPIClient sharedClient] refreshTokenWithSuccess:^(AFOAuthCredential *newCredential){
                        
                        //NSLog(@"Access token refreshed");
                        NSLog(@"Update serializer token string value");
                        
                        [weakSelf updateCredential:newCredential];
                        [weakSelf downloadReportForAccession:AccessionNo WithRetryCounter:retryCount WithCompletionBlock:completionBlock];
                        
                    }failure:^(NSError *error){
                        NSLog(@"Failed to refresh token");
                    }];
                }
                
                if (httpResponse.statusCode==500)
                {
                    NSLog(@"Retrying accession report download request because of an internal server error");
                    [weakSelf downloadReportForAccession:AccessionNo WithRetryCounter:retryCount WithCompletionBlock:completionBlock];
                          
               }
                
                else
                {
                    completionBlock(false);
                    dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Problem while downloading the file" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertView show];
                        
                    });
                   
                }
            }
        }];
        
        [downloadTask resume];
    }

    
}



- (AFHTTPRequestOperation *)retryRequestForOperation:(AFHTTPRequestOperation *)operation{
    
    NSMutableURLRequest *request = [operation.request mutableCopy];
    [request addValue:nil forHTTPHeaderField:@"Authorization"];
    
    NSString *newAccessToken = [NSString stringWithFormat:@"Bearer %@",[AFOAuthCredential retrieveCredentialWithIdentifier:kCredentialIdentifier].accessToken];
    [request addValue:newAccessToken forHTTPHeaderField:@"Authorization"];
    
    AFHTTPRequestOperation *retryOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    retryOperation.responseSerializer=[AFJSONResponseSerializer serializer];
    //NSLog(@"Returning retryOperation");
    return retryOperation;
    
}

- (NSString *)errorMessageForResponse:(AFHTTPRequestOperation *)operation
{
    NSData *jsonData = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:0
                                                           error:nil];
    NSString *errorMessage = [json objectForKey:@"error"];
    return errorMessage;
}

@end
