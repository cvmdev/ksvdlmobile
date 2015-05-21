//
//  AccessCredential.h
//  ksvdlmobile
//
//  Created by Praveen on 4/29/15.
//  Copyright (c) 2015 Praveen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LockBox.h"

@interface AccessCredential : NSObject

-(id) initWithIdentifier:(NSString *) keyId;

- (BOOL) isClientLoggedIn;
- (NSString *) accessToken;
- (NSString *) refreshToken;
-(void) clearTokens;
-(void) setAccessToken: (NSString * ) accessToken;
-(void) setRefreshToken: (NSString * ) refreshToken;

@end
