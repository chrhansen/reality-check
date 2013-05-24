//
//  LinkedInHelper.m
//  Reality Check
//
//  Created by Christian Hansen
//

#import "RCLinkedInHelper.h"
#import "AFJSONRequestOperation.h"
#import "KeychainItemWrapper.h"
#import "OAuth1Controller.h"

// Authentication
#define LinkedInAPIKey @"4nmz48hs6mlp"
#define LinkedInAPISecret @"PEkeNjjSQ6jOqvQr"
#define LinkedInAuthenticationURL @"https://api.linkedin.com/uas/"

// API
#define LinkedInAPIURL @"http://api.linkedin.com/v1/"
#define LBLinkedAPIMethodGetFriends @"~/connections"
#define RCLinkedInKeyChainIdentifier @"RCLinkedInKeyChainIdentifier"

// Error
#define LBLinkedInErrorDomain @"com.realitycheck.linkedin"


@interface RCLinkedInHelper ()
{
    AuthenticationHandler _loginCompletionHandler;
}

@property (nonatomic, strong) OAuth1Controller *oauth1Controller;
@property (nonatomic, strong) NSString *oauthToken;
@property (nonatomic, strong) NSString *oauthTokenSecret;

@end


@implementation RCLinkedInHelper

+ (RCLinkedInHelper *)sharedHelper
{
    static RCLinkedInHelper *_sharedHelper = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedHelper = [[self alloc] init];
    });
    return _sharedHelper;
}


- (BOOL)hasAccess
{
    if (!self.oauthToken
        || self.oauthTokenSecret)
    {
        KeychainItemWrapper *keychainWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:RCLinkedInKeyChainIdentifier accessGroup:nil];
        
        self.oauthToken = [keychainWrapper objectForKey:(__bridge_transfer id)kSecAttrAccount];
        self.oauthTokenSecret = [keychainWrapper objectForKey:(__bridge_transfer id)kSecValueData];
    }
    return ((self.oauthToken.length > 0) && (self.oauthTokenSecret.length > 0));
}


- (void)loginWithWebView:(UIWebView *)webView completionHandler:(AuthenticationHandler)completionHandler
{
    [self.oauth1Controller loginWithWebView:webView completion:^(NSDictionary *oauthTokens, NSError *error) {
        if (!error) {
            [self storeAccessTokenInKeychain:oauthTokens];
            [self fetchUserInfoCurrrentUserSuccess:^(id JSON) {
                NSDictionary *jsonDic = (NSDictionary *)JSON;
                NSString *profileURL = jsonDic[@"publicProfileUrl"];
                KeychainItemWrapper *keychainWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:RCLinkedInKeyChainIdentifier accessGroup:nil];
                [keychainWrapper setObject:profileURL.lastPathComponent forKey:(__bridge_transfer id)kSecAttrComment];
            } failure:^(NSError *error, id JSON) {
                NSLog(@"LinkedIn user name could not be fetched");
                KeychainItemWrapper *keychainWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:RCLinkedInKeyChainIdentifier accessGroup:nil];
                [keychainWrapper setObject:@"" forKey:(__bridge_transfer id)kSecAttrComment];
            }];
            completionHandler(YES, error);
        } else {
            completionHandler(NO, error);
        }
    }];
}


- (OAuth1Controller *)oauth1Controller
{
    if (_oauth1Controller == nil) {
        _oauth1Controller = [OAuth1Controller new];
    }
    return _oauth1Controller;
}



- (void)storeAccessTokenInKeychain:(NSDictionary *)oauthTokens
{
    self.oauthToken = oauthTokens[@"oauth_token"];
    self.oauthTokenSecret = oauthTokens[@"oauth_token_secret"];
    
    KeychainItemWrapper *keychainWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:RCLinkedInKeyChainIdentifier accessGroup:nil];
    [keychainWrapper setObject:[self.oauthToken copy] forKey:(__bridge_transfer id)kSecAttrAccount];
    [keychainWrapper setObject:[self.oauthTokenSecret copy] forKey:(__bridge_transfer id)kSecValueData];
}


- (BOOL)logout
{
    KeychainItemWrapper *keychainWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:RCLinkedInKeyChainIdentifier accessGroup:nil];
    [keychainWrapper resetKeychainItem];
    self.oauthTokenSecret = nil;
    self.oauthToken = nil;
    return YES;
}


- (NSURLRequest *)preparedRequestForPath:(NSString *)path parameters:(NSDictionary *)params httpMethod:(NSString *)method
{
    [self hasAccess];
    return [OAuth1Controller preparedRequestForPath:path parameters:params HTTPmethod:method oauthToken:self.oauthToken oauthSecret:self.oauthTokenSecret];
}


- (void)getPath:(NSString *)path parameters:(NSDictionary *)params completion:(void (^)(NSError *error, id JSON))completion
{
    NSMutableDictionary *allParams = [@{@"format" : @"json"} mutableCopy];
    [allParams addEntriesFromDictionary:params];
    NSURLRequest *preparedRequest = [self preparedRequestForPath:path parameters:allParams httpMethod:@"GET"];
    
    AFJSONRequestOperation *jsonRequest = [AFJSONRequestOperation JSONRequestOperationWithRequest:preparedRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if (response.statusCode == 200) {
            if (completion) {
                completion(nil, JSON);
            }
        } else {
            NSString *errorString = [NSString stringWithFormat:@"Error: http response code not 200: %i", response.statusCode];
            NSError *error = [NSError errorWithDomain:LBLinkedInErrorDomain code:0 userInfo:@{@"userInfo" : errorString}];
            if (completion) {
                completion(JSON, error);
            }
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if (completion) {
            completion(error, JSON);
        }
    }];
    [jsonRequest start];
}


- (void)fetchUserInfoCurrrentUserSuccess:(void (^)(id JSON))success failure:(void (^)(NSError *error, id JSON))failure
{   
    NSString *path = @"people/~:(id,first-name,last-name,public-profile-url,picture-url,three-current-positions,recommendations-received,skills)";
    NSDictionary *parameters = @{@"format" : @"json"};
    [self getPath:path parameters:parameters completion:^(NSError *error, id JSON) {
        if (!error) {
            if (success) success(JSON);
        } else {
            if (failure) failure(error, JSON);
        }
    }];
}

- (void)fetchHighResPhotoForCurrentUserSuccess:(void (^)(id JSON))success failure:(void (^)(NSError *error, id JSON))failure
{
    NSString *path = @"people/~/picture-urls::(original)";
    NSDictionary *parameters = @{@"format" : @"json"};
    [self getPath:path parameters:parameters completion:^(NSError *error, id JSON) {
        if (!error) {
            if (success) success(JSON);
        } else {
            if (failure) failure(error, JSON);
        }
    }];
}



- (id)currentAccount
{
    return nil;
}

- (void)fetchUserInfoForUserID:(NSString *)userID
                       success:(void (^)(id JSON))success
                       failure:(void (^)(NSError *error, id JSON))failure
{
    // http://api.linkedin.com/v1/people/UTBMVTUzYC/picture-urls::(original)
    NSString *path = @"people/UTBMVTUzYC/picture-urls::(original)";
    NSDictionary *parameters = @{@"format" : @"json"};
    [self getPath:path parameters:parameters completion:^(NSError *error, id JSON) {
        if (!error) {
            if (success) success(JSON);
        } else {
            if (failure) failure(error, JSON);
        }
    }];
}



- (NSString *)username
{
    if ([self hasAccess]) {
        KeychainItemWrapper *keychainWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:RCLinkedInKeyChainIdentifier accessGroup:nil];
        return [[keychainWrapper objectForKey:(__bridge_transfer id)kSecAttrComment] copy];
    }
    return nil;
}



@end
