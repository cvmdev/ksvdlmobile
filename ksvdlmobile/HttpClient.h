//
//  HttpClient.h
//  ksvdlmobile
//
//  Created by Praveen on 7/6/15.
//  Copyright (c) 2015 Praveen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "AFOAuth2Client.h"

@interface HttpClient : AFHTTPRequestOperationManager

typedef void (^ApiClientSuccess)(AFHTTPRequestOperation *operation,id responseObject);
typedef void (^ApiClientFailure)(AFHTTPRequestOperation *operation,NSError * error);
typedef void (^CustomCompletionBlock)(BOOL finished);

+ (HttpClient *) sharedHTTPClient;
- (instancetype) initWithBaseURL:(NSURL *)url;

- (void) fetchAccessionsForPageNo:(NSInteger) pageNo
                 WithSuccessBlock:(ApiClientSuccess)successBlock
                  andFailureBlock:(ApiClientFailure)failureBlock;

- (void) filterAccessionsWithSearchText:(NSString *)searchText
                       WithSuccessBlock:(ApiClientSuccess)successBlock
                  andFailureBlock:(ApiClientFailure)failureBlock;

//- (void) removeTokenAndLogoutUser;

- (void) validateAccessionFor:(NSString *) accNum
             WithSuccessBlock:(ApiClientSuccess)successBlock
              andFailureBlock:(ApiClientFailure)failureBlock;

- (void) downloadReportForAccession:(NSString *)AccessionNo
                   WithRetryCounter:(int) retryCount
                WithCompletionBlock:(CustomCompletionBlock)completionBlock;

- (void) addDeviceToken: (NSString *) dToken
       WithSuccessBlock:(ApiClientSuccess)successBlock
        andFailureBlock:(ApiClientFailure)failureBlock;

- (void) updateNotificationsWithCompletionBlock :(CustomCompletionBlock) completionBlock;

//-(void) updateNotificationsWithSuccessBlock:(ApiClientSuccess)successBlock andFailureBlock:(ApiClientFailure)failureBlock;

-(void) updateCredential:(AFOAuthCredential *)credential;

-(void) fetchTestAndFeesWithSuccessBlock:(ApiClientSuccess)successBlock
                         andFailureBlock:(ApiClientFailure)failureBlock;

@end
