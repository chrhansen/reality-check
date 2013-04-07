//
//  PuppiesViewController.m
//  Trip Insurance
//
//  Created by Christian Hansen on 06/04/13.
//  Copyright (c) 2013 ComedyHack. All rights reserved.
//

#import "PuppiesViewController.h"

@interface PuppiesViewController ()

@end

@implementation PuppiesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//#define PUPPY_URL @"http://tapestri.es/f/QR1zCG8kj/"
#define PUPPY_URL @"http://tapestri.es/f/QR1zCG8kj/"


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showHTMLString:PUPPY_URL];
    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"realityCheck_menuBarLogo.png"]];
    self.navigationItem.titleView = titleView;
	// Do any additional setup after loading the view.
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self hideNavigationBar:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hideNavigationBar:(BOOL)hide
{
//    [[UIApplication sharedApplication] setStatusBarHidden:hide withAnimation:UIStatusBarAnimationSlide];
    [self.navigationController setNavigationBarHidden:hide animated:YES];
}

- (void)showHTMLString:(NSString *)HTMLString
{
    NSURL *url = [NSURL URLWithString:HTMLString];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
}

- (IBAction)doneTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)handleLongPress:(UILongPressGestureRecognizer *)longPressGesture
{
    if (longPressGesture.state == UIGestureRecognizerStateBegan) {
        [self hideNavigationBar:!self.navigationController.isNavigationBarHidden];
    }
}


@end
