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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"realityCheck_backgroundGradient"]];
	// Do any additional setup after loading the view.
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([[RCLinkedInHelper sharedHelper] hasAccess]
        && [[NSUserDefaults standardUserDefaults] boolForKey:AlreadyPromptedForPhoneNumberKey] == YES) {
        [self performSegueWithIdentifier:@"show reality options" sender:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"show reality options"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        ChoseRealityViewController *choseRealityViewController = (ChoseRealityViewController *)navigationController.topViewController;
        choseRealityViewController.delegate = self;
    }
}


- (void)promptForTelephoneNumber
{
    UIAlertView *alertView = [UIAlertView.alloc initWithTitle:NSLocalizedString(@"Telephone Number", nil)
                                                      message:NSLocalizedString(@"Add your telephone to enable reassuring text messages.", nil)
                                                     delegate:self
                                            cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                            otherButtonTitles:NSLocalizedString(@"Add", nil), nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textField = [alertView textFieldAtIndex:0];
    textField.placeholder = @"+12223334444";
    [alertView show];
}



#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString *telephoneNumber = [alertView textFieldAtIndex:0].text;
        [self setPhoneNumberInUserDefaults:telephoneNumber];
    }
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:AlreadyPromptedForPhoneNumberKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if ([[RCLinkedInHelper sharedHelper] hasAccess]) {
        [self performSegueWithIdentifier:@"show reality options" sender:self];
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
                                 if ([[NSUserDefaults standardUserDefaults] boolForKey:AlreadyPromptedForPhoneNumberKey] == NO) {
                                     [weakSelf promptForTelephoneNumber];
                                 }
                             }];
                         }];
                     }];
}


- (void)setPhoneNumberInUserDefaults:(NSString *)phoneNumber
{
    [[NSUserDefaults standardUserDefaults] setValue:phoneNumber forKey:PhoneNumberKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - ChoseRealityViewControllerDelegate
- (void)choseRealityViewControllerDidTapLogout:(ChoseRealityViewController *)choseRealityViewController
{
    [RCLinkedInHelper.sharedHelper logout];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:AlreadyPromptedForPhoneNumberKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self setPhoneNumberInUserDefaults:@""];
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
