//
//  AuthAPIClient.m
//  ksvdlmobile
//
//  Created by Praveen on 5/20/15.
//  Copyright (c) 2015 Praveen. All rights reserved.
//

#import "AuthAPIClient.h"

@implementation AuthAPIClient
static NSString * const baseURL=@"http://129.130.128.31/TestProjects/TestAuthAPI/";
static NSString * const tokenURLString = @"http://129.130.128.31/TestProjects/TestAuthAPI/oauth2/token";

+ (instancetype)sharedClient{
    static AuthAPIClient *_sharedClient=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        NSURL * url = [NSURL URLWithString:baseURL];
        _sharedClient=[AuthAPIClient clientWithBaseURL:url clientID:@"vdliosapp" secret:@"dummy"];
        
    });
    return _sharedClient;
}

@end
