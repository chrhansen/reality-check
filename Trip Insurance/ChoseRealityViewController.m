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



- (void)dealloc
{
    [self stopMusic];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self.rdio.player playSource:@"t2626158"];  // try Enya: http://rd.io/x/QQ9HNzdNn0g/
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


// HELL MODE ---------------------------------------------------------------------

- (IBAction)toggleHellModeTapped:(id)sender
{
    if (self.state == RealityStateNormal) {
        self.state = RealityStateHellMode;
        [self loadAlerts];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(sendAlert:) userInfo:nil repeats:YES];

    } else {
        self.state = RealityStateNormal;
        [self.timer invalidate];
        self.timer = nil;
    }
    
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
    NSLog(@"Alerts: %@", self.alerts);
    if (self.alerts.lastObject) {
        NSString *text = self.alerts[0];
        [self.alerts removeObjectAtIndex:0];
        [self showAlertWithText:text andTitle:@"Reality Check (TM)"];
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
