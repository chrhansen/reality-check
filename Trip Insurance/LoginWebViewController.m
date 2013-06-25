//
//  LoginWebViewController.m
//  Simple-OAuth1
//
//  Created by Christian Hansen on 02/12/12.
//  Copyright (c) 2012 Christian-Hansen. All rights reserved.
//

#import "LoginWebViewController.h"

@implementation LoginWebViewController

- (IBAction)cancelTapped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(loginWebViewControllerDidTapCancel:)]) {
        [self.delegate loginWebViewControllerDidTapCancel:self];
    }
}

@end
