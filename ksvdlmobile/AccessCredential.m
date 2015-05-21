//
//  AccessCredential.m
//  ksvdlmobile
//
//  Created by Praveen on 4/29/15.
//  Copyright (c) 2015 Praveen. All rights reserved.
//

#import "AccessCredential.h"


@implementation AccessCredential

#define DICTIONARY_KEY @"TokenKeys"
#define ACCESS_TOKEN @"access_token"
#define REFRESH_TOKEN @"refresh_token"
#define ACCESS_TOKEN_EXPIRATION @"access_token_exp"
#define REFRESH_TOKEN_EXPIRATION @"refresh_token_exp"

-(id) initWithIdentifier:(NSString *)keyId
{
    if ((self = [super init])){
        NSDictionary * dictionary = @{ACCESS_TOKEN:[NSNull null],
                                      REFRESH_TOKEN:[NSNull null],
                                      ACCESS_TOKEN_EXPIRATION:[NSNull null],
                                      REFRESH_TOKEN_EXPIRATION:[NSNull null]};
        
       [Lockbox setDictionary:dictionary forKey:DICTIONARY_KEY];
        
    }
    return self;
}
-(BOOL) isClientLoggedIn{
    return [self accessToken] !=nil;
}

- (void) clearTokens{
    [self setAccessToken:nil];
    [self setRefreshToken:nil];
}

- (NSString * ) accessToken {
    return [self getValueForKey:ACCESS_TOKEN];
}

- (NSString * ) refreshToken {
    return [self getValueForKey:REFRESH_TOKEN];
}

- (void) setAccessToken:(NSString *)accessToken{
    [self setSecureValue:accessToken forKey:ACCESS_TOKEN];
}

- (void) setRefreshToken:(NSString *)refreshToken{
    [self setSecureValue:refreshToken forKey:REFRESH_TOKEN];
}

- (NSString *) getValueForKey:(NSString *)key{
    
    NSDictionary * dictionary = [Lockbox dictionaryForKey:DICTIONARY_KEY];
    return [dictionary objectForKey:key];
}

- (void) setSecureValue:(NSString *)value forKey:(NSString *)key{
    
    NSMutableDictionary* mutableDict = [[Lockbox dictionaryForKey:DICTIONARY_KEY] mutableCopy];
    
    mutableDict[key]=value;
    
    [Lockbox setDictionary:mutableDict forKey:key];
}

@end
