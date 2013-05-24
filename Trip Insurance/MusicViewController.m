//
//  MusicViewController.m
//  Reality Check
//
//  Created by Christian Hansen on 07/04/13.
//  Copyright (c) 2013 ComedyHack. All rights reserved.
//

#import "MusicViewController.h"
#import <Rdio/Rdio.h>
#import "RealityAPIKeys.h"
#import <QuartzCore/QuartzCore.h>

//Rd.io keys
//#define RDIO_KEY    @"" API keys are imported from "RealityAPIKeys.h"
//#define RDIO_SECRET @""

@interface MusicViewController () <RdioDelegate>

@property (nonatomic, strong) Rdio *rdio;

@end

@implementation MusicViewController

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
    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"realityCheck_menuBarLogo.png"]];
    self.navigationItem.titleView = titleView;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"realityCheck_backgroundGradient"]];
    [self addTextShadowToLabel];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self playMusic];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopMusic];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)addTextShadowToLabel
{
    self.backgroundLabel.layer.shadowOpacity = 0.5;
    self.backgroundLabel.layer.shadowRadius = 3.0;
    self.backgroundLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.backgroundLabel.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    self.backgroundLabel.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    self.backgroundLabel.layer.shouldRasterize = YES;
}

- (void)playMusic
{
    if (!self.rdio) {
        self.rdio = [[Rdio alloc] initWithConsumerKey:RDIO_KEY andSecret:RDIO_SECRET delegate:self];
    }
    [self.rdio.player playAndRestart:YES];
    [self.rdio.player playSource:@"t1232137"];  // try Enya: http://rd.io/x/QQ9HNzdNn0g/
}


- (void)stopMusic
{
    [self.rdio.player stop];
}


#pragma mark - Rdio delegates

- (void)rdioDidAuthorizeUser:(NSDictionary *)user withAccessToken:(NSString *)accessToken
{
    NSLog(@"%s", __PRETTY_FUNCTION__);

}
- (IBAction)tappedDone:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
