//
//  LinkedInViewController.m
//  Trip Insurance
//
//  Created by Christian Hansen on 06/04/13.
//  Copyright (c) 2013 ComedyHack. All rights reserved.
//

#import "LinkedInViewController.h"
#import "RCLinkedInHelper.h"
#import <QuartzCore/QuartzCore.h>
#import "LoginWebViewController.h"

@interface LinkedInViewController () <LoginWebViewControllerDelegate>

@property (nonatomic) BOOL sholdLogin;

@end

@implementation LinkedInViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.sholdLogin = YES;
    [self loadProfile];
    [self loadHighResPhoto];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"realityCheck_menuBarLogo.png"]];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"realityCheck_backgroundGradient"]];
    [self addImageViewStyling];
    [self addTextViewBorder];
	// Do any additional setup after loading the view.
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.sholdLogin == YES
        && ![[RCLinkedInHelper sharedHelper] hasAccess]) {
        [self login];
    }
}



- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if([UIScreen mainScreen].bounds.size.height == 568.0f) {
        [self adjustPositionsFor4InchPhone];
    }
}


- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)adjustPositionsFor4InchPhone
{
    self.jobPositionLabel.center = CGPointMake(160.0f, 232.0f);
    self.jobCompanyLabel.center = CGPointMake(160.0f, 254.0f);
    self.recommendationTextView.bounds = CGRectMake(0, 0, self.recommendationTextView.bounds.size.width, 180);
    self.recommendationTextView.center = CGPointMake(160.f, 370.0f);
}



- (void)loadProfile
{
    [[RCLinkedInHelper sharedHelper] fetchUserInfoCurrrentUserSuccess:^(id JSON) {
        [self updateUIWithDictionary:JSON];
    } failure:^(NSError *error, id JSON) {
        NSLog(@"error: %@", error.localizedDescription);
    }];
}


- (void)loadHighResPhoto
{
    [[RCLinkedInHelper sharedHelper] fetchHighResPhotoForCurrentUserSuccess:^(id JSON) {
        NSString *highResPath = [JSON[@"values"] lastObject];
        if (highResPath) [self.profileImageView setImageWithURL:[NSURL URLWithString:highResPath]];
    } failure:^(NSError *error, id JSON) {
        NSLog(@"error: %@", error.localizedDescription);
    }];
}


- (void)addImageViewStyling
{
    self.imageViewBackgroundView.layer.shadowRadius = 2.0f;
    self.imageViewBackgroundView.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    self.imageViewBackgroundView.layer.shadowOpacity = 0.5f;
    
    self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profileImageView.layer.borderWidth = 1.0f;
    self.profileImageView.layer.shadowRadius = 1.0f;
    self.profileImageView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.profileImageView.layer.shadowOpacity = 0.8f;
}


- (void)addTextViewBorder
{
    self.recommendationTextView.layer.borderWidth = 1.0f;
    self.recommendationTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    self.recommendationTextView.layer.shadowRadius = 4.0f;
    self.recommendationTextView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.recommendationTextView.layer.shadowOpacity = 0.5f;
}

- (void)updateUIWithDictionary:(NSDictionary *)dictionary
{
    // Image
    if (self.profileImageView.image == nil) {
//        [self.profileImageView setImageWithURL:[NSURL URLWithString:dictionary[@"pictureUrl"]]];
    }
    
    // Name
    NSString *nameString = @"";
    if (dictionary[@"firstName"]) nameString = [nameString stringByAppendingString:dictionary[@"firstName"]];
    if (dictionary[@"lastName"]) nameString = [nameString stringByAppendingFormat:@" %@", dictionary[@"lastName"]];
    [self.nameLabel setText:nameString];
    
    // Job position
    self.jobPositionLabel.text = [dictionary[@"threeCurrentPositions"][@"values"] lastObject][@"company"][@"name"];
    self.jobCompanyLabel.text = [dictionary[@"threeCurrentPositions"][@"values"] lastObject][@"title"];
    
    // Recommendations
    NSString *recommendation = [dictionary[@"recommendationsReceived"][@"values"] lastObject][@"recommendationText"];
    if (recommendation) self.recommendationTextView.text = recommendation;
    
    NSDictionary *recommender = [dictionary[@"recommendationsReceived"][@"values"] lastObject][@"recommender"];
    if (recommender) {
        NSString *recommenderName = @"- ";
        if (recommender[@"firstName"]) recommenderName = [recommenderName stringByAppendingString:recommender[@"firstName"]];
        if (recommender[@"lastName"]) recommenderName = [recommenderName stringByAppendingFormat:@" %@", recommender[@"lastName"]];
        self.recommendationNameLabel.text = recommenderName;
    }

    // Skills
    NSString *skillsCountText = [NSString stringWithFormat:@"%d", [dictionary[@"skills"][@"values"] count]];
    if (skillsCountText == nil || skillsCountText.length == 0) {
        skillsCountText = @"0";
    }
    self.skillCountLabel.text = skillsCountText;
}


- (IBAction)doneTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -
- (void)login
{
    LoginWebViewController *webLoginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginWebViewController"];
    webLoginViewController.delegate = self;
    __weak LinkedInViewController *weakSelf = self;
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
                                     [weakSelf loadProfile];
                                     [weakSelf loadHighResPhoto];
                                 }
                             }];
                         }];
                     }];
}


- (IBAction)logout
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


#pragma mark LoginWebViewControllerDelegate
- (void)loginWebViewControllerDidTapCancel:(LoginWebViewController *)loginWebVC
{
    self.sholdLogin = NO;
    __weak LinkedInViewController *weakSelf = self;
    [loginWebVC dismissViewControllerAnimated:YES completion:^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
}

@end
