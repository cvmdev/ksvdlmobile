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
+ (instancetype) sharedClient;
@end
