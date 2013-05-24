//
//  LoginViewController.m
//  Trip Insurance
//
//  Created by Christian Hansen on 06/04/13.
//  Copyright (c) 2013 ComedyHack. All rights reserved.
//

#import "LoginViewController.h"
#import "ChoseRealityViewController.h"
#import "LoginWebViewController.h"
#import "RCLinkedInHelper.h"

#define AlreadyPromptedForPhoneNumberKey @"AlreadyPromptedForPhoneNumberKey"
#define PhoneNumberKey @"PhoneNumberKey"

@interface LoginViewController () <ChoseRealityViewControllerDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) NSString *oauthToken;
@property (nonatomic, strong) NSString *oauthTokenSecret;

@end

@implementation LoginViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"realityCheck_backgroundGradient"]];
	// Do any additional setup after loading the view.
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([[RCLinkedInHelper sharedHelper] hasAccess]) {
        [self performSegueWithIdentifier:@"show reality options" sender:self];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"show reality options"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        ChoseRealityViewController *choseRealityViewController = (ChoseRealityViewController *)navigationController.topViewController;
        choseRealityViewController.delegate = self;
    }
}



- (IBAction)loginTapped:(id)sender
{
    LoginWebViewController *webLoginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginWebViewController"];
    __weak LoginViewController *weakSelf = self;
    [self presentViewController:webLoginViewController
                       animated:YES
                     completion:^{
                         [RCLinkedInHelper.sharedHelper loginWithWebView:webLoginViewController.webView completionHandler:^(BOOL granted, NSError *error) {
                             if (!error) {
                                 NSLog(@"LinkedIn login success");
                             } else {
                                 NSLog(@"LinkedIn login ERROR");
                             }
                             [weakSelf dismissViewControllerAnimated:YES completion:^{
                                 NSLog(@"completed login");
                                 if ([RCLinkedInHelper.sharedHelper hasAccess]) {
                                     [weakSelf performSegueWithIdentifier:@"show reality options" sender:weakSelf];
                                 }
                             }];
                         }];
                     }];
}



#pragma mark - ChoseRealityViewControllerDelegate
- (void)choseRealityViewControllerDidTapLogout:(ChoseRealityViewController *)choseRealityViewController
{
    [RCLinkedInHelper.sharedHelper logout];
    [self removeWebViewCookies];
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)removeWebViewCookies
{
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        if (cookie.isSecure) {
            [storage deleteCookie:cookie];
        }
    }
}


- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
