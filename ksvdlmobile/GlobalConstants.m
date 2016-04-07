//
//  GlobalConstants.m
//  ksvdlmobile
//
//  Created by Praveen on 7/6/15.
//  Copyright (c) 2015 Praveen. All rights reserved.
//

#import "GlobalConstants.h"

@implementation GlobalConstants


//Live Web Server
NSString *const kBaseURL=@"https://www.vet.k-state.edu/services/KSVDLMobile/";
NSString *const kTokenURLString = @"https://www.vet.k-state.edu/services/KSVDLMobile/oauth2/token";

//Local PC
//NSString *const kBaseURL=@"http://129.130.128.31/TestProjects/VetViewAPI/";
//NSString *const kTokenURLString = @"http://129.130.128.31/TestProjects/VetViewAPI/oauth2/token";

//Test Web Server
//NSString *const kBaseURL=@"http://129.130.129.27/KSVDL/VetViewAPI/";
//NSString *const kTokenURLString = @"http://129.130.129.27/KSVDL/VetViewAPI/oauth2/token";


//Local PC test version
//NSString *const kBaseURL=@"http://129.130.128.31/TestProjects/TestAuthAPI/KSVDL/";
//NSString *const kTokenURLString = @"http://129.130.128.31/TestProjects/TestAuthAPI/oauth2/token";

NSString *const kCredentialIdentifier=@"VetViewID";
NSString *const kClientId=@"vdliosapp";
NSString *const kClientSecret=@"dummy";
NSString *const kVDLYoutubeURL=@"https://www.youtube.com/channel/UCtx-lIIXqj5PAMQYryXaRhA";
NSString *const kVDLTestFeesURL=@"http://www.ksvdl.org/resources/test.html";
NSString *const kVDLFeedbackFormURL=@"http://goo.gl/forms/OK3kc7PF2W";
NSString *const kVDLHelpPage=@"https://www.vet.k-state.edu/asp/app/helpfile.html";
NSString *const kVDLPortalLogin=@"https://vetview2.vet.k-state.edu/LabPortal";
NSString *const kVDLPortalRegister=@"https://vetview2.vet.k-state.edu/LabPortal/registration/Index";
NSString *const kVDLPortalResetPwd=@"https://vetview2.vet.k-state.edu/LabPortal/login/pwdChange";
NSString *const kVDLDeviceTokenString=@"ksvdldevicetoken";
NSString *const kVDLUserString=@"vdlusername";
NSString *const kVDLPromotionString=@"https://www.vet.k-state.edu/asp/app/app_promotion.html";
const int kRetryCount=3;

@end
