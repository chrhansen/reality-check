//
//  LinkedInHelper.h
//  
//
//  Created by Christian Hansen on 01/11/12.
//  Copyright (c) 2012 Kwamecorp. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^AuthenticationHandler)(BOOL granted, NSError *error);

@interface RCLinkedInHelper : NSObject

- (void)loginWithWebView:(UIWebView *)webView completionHandler:(AuthenticationHandler)completionHandler;

- (BOOL)hasAccess;
- (BOOL)logout;
- (NSString *)username;

- (void)fetchUserInfoCurrrentUserSuccess:(void (^)(id JSON))success failure:(void (^)(NSError *error, id JSON))failure;
- (void)fetchHighResPhotoForCurrentUserSuccess:(void (^)(id JSON))success failure:(void (^)(NSError *error, id JSON))failure;
+ (RCLinkedInHelper *)sharedHelper;

@property (nonatomic, strong) RCLinkedInHelper *sharedHelper;

@end
