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



@interface LoginViewController () <ChoseRealityViewControllerDelegate>

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
    if ([[RCLinkedInHelper sharedHelper] hasAccess]) {
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
        ChoseRealityViewController *choseRealityViewController = segue.destinationViewController;
        choseRealityViewController.delegate = self;
    }
}


- (IBAction)loginTapped:(id)sender
{
    LoginWebViewController *webLoginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginWebViewController"];
    [self presentViewController:webLoginViewController
                       animated:YES
                     completion:^{
                         [RCLinkedInHelper.sharedHelper loginWithWebView:webLoginViewController.webView
                                                       completionHandler:^(BOOL granted, NSError *error)
                          {
                              if (!error)
                              {
                                  NSLog(@"LinkedIn login success");
                              }
                              else
                              {
                                  NSLog(@"LinkedIn login ERROR");
                              }
                              [self dismissViewControllerAnimated:YES completion:^{
                                  NSLog(@"completed login");
                                  //completion(error);
                              }];
                          }];
                     }];
}



#pragma mark - ChoseRealityViewControllerDelegate
- (void)choseRealityViewControllerDidTapLogout:(ChoseRealityViewController *)choseRealityViewController
{
    [RCLinkedInHelper.sharedHelper logout];
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
