//
//  PuppiesViewController.m
//  Trip Insurance
//
//  Created by Christian Hansen on 06/04/13.
//  Copyright (c) 2013 ComedyHack. All rights reserved.
//

#import "PuppiesViewController.h"
#import "RealityAPIKeys.h"
#import <QuartzCore/QuartzCore.h>

@interface PuppiesViewController ()

@property (nonatomic, weak) IBOutlet UIButton *doneButton;

@end

@implementation PuppiesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showHTMLString:PUPPY_URL];
    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"realityCheck_menuBarLogo.png"]];
    self.navigationItem.titleView = titleView;
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hideNavigationBar:YES];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self styleButton];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

-(void)styleButton
{
    self.doneButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.doneButton.layer.shadowRadius = 4.0f;
    self.doneButton.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    self.doneButton.layer.shadowOpacity = 0.5f;
    self.doneButton.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    self.doneButton.layer.shouldRasterize = YES;
    self.doneButton.alpha = 0.7f;
    
    UIImage *buttonImage = [[UIImage imageNamed:@"tanButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *highlightedButtonImage = [[UIImage imageNamed:@"tanButtonHighlight"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    [self.doneButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.doneButton setBackgroundImage:highlightedButtonImage forState:UIControlStateHighlighted];
    
    [self.doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

}

- (void)hideNavigationBar:(BOOL)hide
{
    [[UIApplication sharedApplication] setStatusBarHidden:hide withAnimation:UIStatusBarAnimationSlide];
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
