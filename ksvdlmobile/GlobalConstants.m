//
//  GlobalConstants.m
//  ksvdlmobile
//
//  Created by Praveen on 7/6/15.
//  Copyright (c) 2015 Praveen. All rights reserved.
//

#import "GlobalConstants.h"

@implementation GlobalConstants

//Local PC
NSString *const kBaseURL=@"http://129.130.128.31/TestProjects/VetViewAPI/";
NSString *const kTokenURLString = @"http://129.130.128.31/TestProjects/VetViewAPI/oauth2/token";

//Test Web Server
//NSString *const kBaseURL=@"http://129.130.129.27/KSVDL/VetViewAPI/";
//NSString *const kTokenURLString = @"http://129.130.129.27/KSVDL/VetViewAPI/oauth2/token";


//Local PC test version
//NSString *const kBaseURL=@"http://129.130.128.31/TestProjects/TestAuthAPI/api/Orders/";
//NSString *const kTokenURLString = @"http://129.130.128.31/TestProjects/TestAuthAPI/oauth2/token";

NSString *const kCredentialIdentifier=@"VetViewID";
NSString *const kClientId=@"vdliosapp";
NSString *const kClientSecret=@"dummy";
NSString *const kVDLYoutubeURL=@"https://www.youtube.com/channel/UCtx-lIIXqj5PAMQYryXaRhA";
NSString *const kVDLTestFeesURL=@"https://vetview2.vet.k-state.edu/LabPortal/catalog.zul";
NSString *const kVDLFeedbackFormURL=@"http://goo.gl/forms/OK3kc7PF2W";
NSString *const kVDLHelpPage=@"http://www.ksvdl.org/mobileapp/help.html";
NSString *const kVDLDeviceTokenString=@"ksvdldevicetoken";
NSString *const kVDLUserString=@"vdlusername";
const int kRetryCount=3;

@end
