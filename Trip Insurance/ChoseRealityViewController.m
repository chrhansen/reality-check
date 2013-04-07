//
//  RealityViewController.m
//  Trip Insurance
//
//  Created by Christian Hansen on 06/04/13.
//  Copyright (c) 2013 ComedyHack. All rights reserved.
//

#import "ChoseRealityViewController.h"
#import <Rdio/Rdio.h>


//Rd.io keys
//Application: Reality Check
#define RDIO_KEY    @"59pkuyudg3jrdmrqyc6r2rs8"
#define RDIO_SECRET @"ur5FT9z9xQ"

@interface ChoseRealityViewController ()

@property (nonatomic, strong) Rdio *rdio;

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

@end
