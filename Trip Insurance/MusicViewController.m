//
//  MusicViewController.m
//  Reality Check
//
//  Created by Christian Hansen on 07/04/13.
//  Copyright (c) 2013 ComedyHack. All rights reserved.
//

#import "MusicViewController.h"
#import <Rdio/Rdio.h>


//Rd.io keys
//Application: Reality Check
#define RDIO_KEY    @"59pkuyudg3jrdmrqyc6r2rs8"
#define RDIO_SECRET @"ur5FT9z9xQ"

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)playMusic
{
    if (!self.rdio) {
        self.rdio = [[Rdio alloc] initWithConsumerKey:RDIO_KEY andSecret:RDIO_SECRET delegate:self];
    }
    [self.rdio.player playSource:@"t2626158"];  // try Enya: http://rd.io/x/QQ9HNzdNn0g/
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
