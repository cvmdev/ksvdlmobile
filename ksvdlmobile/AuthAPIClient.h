//
//  AuthAPIClient.h
//  ksvdlmobile
//
//  Created by Praveen on 5/20/15.
//  Copyright (c) 2015 Praveen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFOAuth2Client.h"

@interface AuthAPIClient : AFOAuth2Client
typedef void (^CustomCompletionBlock)(BOOL finished);
+ (instancetype) sharedClient;
- (void)refreshTokenWithSuccess:(void (^)(AFOAuthCredential *newCredential))success
                        failure:(void (^)(NSError *error))failure;
-(BOOL) hasUserEverLoggedIn;
- (bool)isSignInRequired;
- (AFOAuthCredential *)retrieveCredential;
- (void) logOutWithRetryCount:(int)retryCounter
           AndCompletionBlock:(CustomCompletionBlock)completionBlock;

@end
