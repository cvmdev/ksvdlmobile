//
//  AuthAPIClient.m
//  ksvdlmobile
//
//  Created by Praveen on 5/20/15.
//  Copyright (c) 2015 Praveen. All rights reserved.
//

#import "AuthAPIClient.h"
#import "GlobalConstants.h"

@implementation AuthAPIClient


+ (instancetype)sharedClient{
    static AuthAPIClient *_sharedClient=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        NSURL * url = [NSURL URLWithString:kBaseURL];
        _sharedClient=[AuthAPIClient clientWithBaseURL:url clientID:kClientId secret:kClientSecret];
        
    });
    return _sharedClient;
}


-(BOOL)hasUserEverLoggedIn
{
    AFOAuthCredential  *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:kCredentialIdentifier];
    if (!credential)
        return false;
    else
    {
        if (credential.isExpired)
            return true;
    }
    return false;
}

- (bool)isSignInRequired {
    AFOAuthCredential *credential = [self retrieveCredential];
    if (credential == nil) {
        return true;
    }
    
    return false;
}

-(NSString *) getDeviceToken
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * dToken = [defaults objectForKey:kVDLDeviceTokenString];
    return dToken;
}

- (AFOAuthCredential *)retrieveCredential
{
    return [AFOAuthCredential retrieveCredentialWithIdentifier:kCredentialIdentifier];
}

-(void) logOutWithRetryCount:(int)retryCounter
          AndCompletionBlock:(CustomCompletionBlock)completionBlock

{
    
    __block int retryCount=retryCounter;
    __weak typeof(self) weakSelf=self;
    NSString * postLogout = [NSString stringWithFormat:@"LogoutDevice?tokenId=%@&appType=IOS&deviceToken=%@",self.retrieveCredential.refreshToken,self.getDeviceToken];
    
    [self POST:postLogout parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        NSLog(@"Removed Refresh token and Device Token..Now deleting from device");
      
        [AFOAuthCredential deleteCredentialWithIdentifier:kCredentialIdentifier];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kVDLUserString];
        
        completionBlock(true);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if (retryCounter>0)
         {
             if ((operation.response.statusCode==401) || (operation.response.statusCode==500))
                 {
                     NSLog(@"There was an error while logging out,so retrying request");
                    
                     [weakSelf logOutWithRetryCount:retryCount--
                                 AndCompletionBlock:completionBlock];
                      
                     
                 }
             
         }
         else
         {
         NSLog(@"There was a problem logging out/revoking the refresh token:%@",error);
         NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
         NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
         NSLog(@"The dictionary has :%@",serializedData);
         completionBlock(false);
         }
     }];
   
    
    
}
- (void)refreshTokenWithSuccess:(void (^)(AFOAuthCredential *newCredential))success
                        failure:(void (^)(NSError *error))failure
{
    NSLog(@"[AUTHAPICLIENT] Refreshing Token...");
    
    AFOAuthCredential *credential = [self retrieveCredential];
    if (credential == nil) {
        NSLog(@"credential is nil");
        if (failure) {
            NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
            [errorDetail setValue:@"Failed to get credentials" forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:@"vet.ksu.edu" code:200 userInfo:errorDetail];
            failure(error);
        }
        return;
    }
    
    NSLog(@"refreshing the access token...for refreshToken: %@", credential.refreshToken);
    
    [self authenticateUsingOAuthWithURLString:kTokenURLString
                                 refreshToken:credential.refreshToken
                                      success:^(AFOAuthCredential *newCredential) {
                                          NSLog(@" new access token after refreshing is %@", newCredential.accessToken);
                                          [AFOAuthCredential storeCredential:newCredential withIdentifier:kCredentialIdentifier];
                                          
                                          if (success) {
                                              success(newCredential);
                                          }
                                      }
                                      failure:^(NSError *error) {
                                          NSLog(@"an error occurred refreshing credential: %@", error);
                                          if (failure) {
                                              failure(error);
                                          }
                                      }];
}



@end
