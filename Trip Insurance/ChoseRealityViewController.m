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


// HELL MODE

- (IBAction)toggleHellModeTapped:(id)sender
{
    if (self.state == RealityStateNormal) {
        self.state = RealityStateHellMode;
    } else {
        self.state = RealityStateNormal;
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
    }}

@end
