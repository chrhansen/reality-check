//
//  LoginWebViewController.h
//  Simple-OAuth1
//
//  Created by Christian Hansen on 02/12/12.
//  Copyright (c) 2012 Christian-Hansen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginWebViewController;

@protocol LoginWebViewControllerDelegate <NSObject>
@optional
- (void)loginWebViewControllerDidTapCancel:(LoginWebViewController *)loginWebVC;
@end

@interface LoginWebViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) id<LoginWebViewControllerDelegate> delegate;

@end
