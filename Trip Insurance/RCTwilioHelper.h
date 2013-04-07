//
//  RCTwilioHelper.h
//  Trip Insurance
//
//  Created by Christian Hansen on 06/04/13.
//  Copyright (c) 2013 ComedyHack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCTwilioHelper : NSObject

- (void)sendTextFromNumber:(NSString *)fromNumber toNumber:(NSString *)toNumber bodyText:(NSString *)bodyText;
+ (RCTwilioHelper *)sharedHelper;

@property (nonatomic, strong) RCTwilioHelper *sharedHelper;

@end
