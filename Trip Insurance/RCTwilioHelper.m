//
//  RCTwilioHelper.m
//  Trip Insurance
//
//  Created by Christian Hansen on 06/04/13.
//  Copyright (c) 2013 ComedyHack. All rights reserved.
//

#import "RCTwilioHelper.h"

@implementation RCTwilioHelper

+ (RCTwilioHelper *)sharedHelper
{
    static RCTwilioHelper *_sharedHelper = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedHelper = [[self alloc] init];
    });
    return _sharedHelper;
}

#define SID @"AC77939e261abc0fc3d87e3eeea597d0ae"
#define SECRET @"b9cf54cc2141ab58425fe9095239a53f"

- (void)sendTextFromNumber:(NSString *)fromNumber toNumber:(NSString *)toNumber bodyText:(NSString *)bodyText
{
    NSLog(@"Sending request.");
    
    // Common constants
    NSString *kTwilioSID = SID;
    NSString *kTwilioSecret = SECRET;
    NSString *kFromNumber = fromNumber;
    NSString *kToNumber = toNumber;
    NSString *kMessage = bodyText;
    
    // Build request
    NSString *urlString = [NSString stringWithFormat:@"https://%@:%@@api.twilio.com/2010-04-01/Accounts/%@/SMS/Messages", kTwilioSID, kTwilioSecret, kTwilioSID];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    
    // Set up the body
    NSString *bodyString = [NSString stringWithFormat:@"From=%@&To=%@&Body=%@", kFromNumber, kToNumber, kMessage];
    NSData *data = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    
    AFJSONRequestOperation *jsonRequest = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if (response.statusCode == 200) {
//            NSLog(@"JSON: %@", JSON);
        } else {
//            NSString *errorString = [NSString stringWithFormat:@"Error: http response code not 200: %i", response.statusCode];
//            NSLog(@"Error: %@", errorString);
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
//        NSLog(@"Error: %@", error.localizedDescription);
    }];
    [jsonRequest start];
}


@end
