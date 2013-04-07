//
//  TripTrackerViewController.m
//  Reality Check
//
//  Created by Christian Hansen on 07/04/13.
//  Copyright (c) 2013 ComedyHack. All rights reserved.
//

#import "TripTrackerViewController.h"

@interface TripTrackerViewController ()

@end

@implementation TripTrackerViewController

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
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"realityCheck_menuBarLogo.png"]];

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)doneTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)changeForm:(id)sender
{
    self.emptyFormImageView.hidden = YES;
    self.filledFormImageView.hidden = NO;
}

@end
