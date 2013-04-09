//
//  RealityViewController.m
//  Trip Insurance
//
//  Created by Christian Hansen on 06/04/13.
//  Copyright (c) 2013 ComedyHack. All rights reserved.
//

#import "ChoseRealityViewController.h"
#import <Rdio/Rdio.h>

typedef enum {
    RealityStateNormal, 
    RealityStateHellMode 
} RealityState;


//Rd.io keys
//Application: Reality Check
#define RDIO_KEY    @"59pkuyudg3jrdmrqyc6r2rs8"
#define RDIO_SECRET @"ur5FT9z9xQ"

@interface ChoseRealityViewController ()

@property (nonatomic, strong) Rdio *rdio;
@property (nonatomic) RealityState state;
@property (nonatomic, strong) UIImageView *brokenGlassImageView;
@property (nonatomic, strong) NSMutableArray *alerts;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ChoseRealityViewController

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
    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"realityCheck_menuBarLogo.png"]];
    self.navigationItem.titleView = titleView;
    self.state = RealityStateNormal;
	// Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self startMusicIfNotPlaying];
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if([UIScreen mainScreen].bounds.size.height == 568.0) {
        [self adjustPositionsFor4InchPhone];
    }
}

- (void)dealloc
{
    [self stopMusic];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"show soothing sounds"]) {
        [self stopMusic];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)adjustPositionsFor4InchPhone
{
    // Adjust button positions
    self.linkedInButton.center = CGPointMake(94, 70);
    self.tripTrackerButton.center = CGPointMake(227, 70);
    self.textMessageButton.center = CGPointMake(94, 210);
    self.playWithPuppiesButton.center = CGPointMake(227, 210);
    self.hellModeButton.center = CGPointMake(94, 350);
    self.soothingSoundsButton.center = CGPointMake(227, 350);
    
    CGFloat labelOffset = 60.0f;
    // Adjust label positions
    self.linkedInLabel.center = CGPointMake(94, 70+labelOffset);
    self.tripTrackerLabel.center = CGPointMake(227, 70+labelOffset);
    self.textLabel.center = CGPointMake(94, 210+labelOffset);
    self.puppiesLabel.center = CGPointMake(227, 210+labelOffset);
    self.hellModeLabel.center = CGPointMake(94, 350+labelOffset);
    self.soothingLabel.center = CGPointMake(227, 350+labelOffset);
}


- (IBAction)logoutOfRealityTapped:(id)sender
{
    [self.delegate choseRealityViewControllerDidTapLogout:self];
}


- (void)startMusicIfNotPlaying
{
    if (self.rdio.player.state != RDPlayerStatePlaying) {
        [self playMusic];
    }
}



- (void)playMusic
{
    if (self.state == RealityStateNormal) {
        [self.rdio.player playSource:@"t2626158"];  // Normal "Back to Life"
    } else {
        [self.rdio.player playSource:@"t24756929"];  // Hell Mode Dub Step
    }
}


- (void)stopMusic
{
    [self.rdio.player stop];
}


- (Rdio *)rdio
{
    if (_rdio == nil) {
        self.rdio = [[Rdio alloc] initWithConsumerKey:RDIO_KEY andSecret:RDIO_SECRET delegate:nil];
    }
    return _rdio;
}

- (IBAction)upgradeToPremiumTapped:(id)sender
{
    UIAlertView *alertView = [UIAlertView.alloc initWithTitle:NSLocalizedString(@"Premium Reality $99", nil)
                                                      message:NSLocalizedString(@"Click \"Buy\" to upgrade Reality Check\u2122 to Premium Reality for just $99/year.", nil)
                                                     delegate:nil
                                            cancelButtonTitle:NSLocalizedString(@"Buy", nil)
                                            otherButtonTitles:NSLocalizedString(@"Cancel", nil), nil];
    [alertView show];
}

// HELL MODE ---------------------------------------------------------------------

- (IBAction)toggleHellModeTapped:(id)sender
{
    [self stopMusic];
    if (self.state == RealityStateNormal) {
        self.state = RealityStateHellMode;
        [self loadAlerts];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(sendAlert:) userInfo:nil repeats:YES];

    } else {
        self.state = RealityStateNormal;
        [self.timer invalidate];
        self.timer = nil;
    }
    [self startMusicIfNotPlaying];
    [self updateButtonPhotos];
    [self updateBrokenGlass];
}


- (void)updateButtonPhotos
{
    switch (self.state) {
        case RealityStateNormal:
            [self.linkedInButton setImage:[UIImage imageNamed:@"btn_realityCheck_btn_confirmYourIdentity_x2.png"] forState:UIControlStateNormal];
            [self.tripTrackerButton setImage:[UIImage imageNamed:@"btn_realityCheck_btn_tripTracker_x2.png"] forState:UIControlStateNormal];
            [self.textMessageButton setImage:[UIImage imageNamed:@"btn_realityCheck_btn_reassuringTextMessages_x2.png"] forState:UIControlStateNormal];
            [self.playWithPuppiesButton setImage:[UIImage imageNamed:@"btn_realityCheck_btn_playWithPuppies_x2.png"] forState:UIControlStateNormal];
            break;
        case RealityStateHellMode:
            [self.linkedInButton setImage:[UIImage imageNamed:@"btn_realityCheck_btn_confirmYourIdentity_broken.png"] forState:UIControlStateNormal];
            [self.tripTrackerButton setImage:[UIImage imageNamed:@"btn_realityCheck_btn_tripTracker_broken@2x.png"] forState:UIControlStateNormal];
            [self.textMessageButton setImage:[UIImage imageNamed:@"btn_realityCheck_btn_reassuringTextMessages_broken@2x.png"] forState:UIControlStateNormal];
            [self.playWithPuppiesButton setImage:[UIImage imageNamed:@"btn_realityCheck_btn_playWithPuppies_broken@2x.png"] forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}


- (void)updateBrokenGlass
{
    switch (self.state) {
        case RealityStateNormal:
            [self.brokenGlassImageView removeFromSuperview];
            break;
        case RealityStateHellMode:
        {
            self.brokenGlassImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"realityCheck_crackedOverlay.png"]];
            [self.view.window addSubview:self.brokenGlassImageView];
        }
            break;
            
        default:
            break;
    }
}


- (void)sendAlert:(NSTimer *)timer
{
    if (self.alerts.lastObject) {
        NSString *text = self.alerts[0];
        [self.alerts removeObjectAtIndex:0];
        [self showAlertWithText:text andTitle:@"Reality Check\u2122"];
    } else {
        [self.timer invalidate];
        self.timer = nil;
    }
}


- (void)loadAlerts
{
    self.alerts = [@[@"Um. Fuck.",
                   @"What did you do?",
                   @"This isn’t supposed to happen!!!",
                   @"YOU. RUINED. EVERYTHING.",
                   @"BACK2REALITYBACK2REALITYBACK2REALITYBACK2REALITYBACK2REALITYBACK2REALITYBACK2REALITYBACK2REALITYBACK2REALITYBACK2REALITYBACK2REALITYBACK2REALITYBACK2REALITYBACK2REALITYBACK2REALITYBACK2REALITYBACK2REALITY"]
                   mutableCopy];
}

- (void)showAlertWithText:(NSString *)text andTitle:(NSString *)title
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:text delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

@end
