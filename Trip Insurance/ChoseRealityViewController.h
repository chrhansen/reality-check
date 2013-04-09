//
//  RealityViewController.h
//  Trip Insurance
//
//  Created by Christian Hansen on 06/04/13.
//  Copyright (c) 2013 ComedyHack. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChoseRealityViewController;

@protocol ChoseRealityViewControllerDelegate <NSObject>

- (void)choseRealityViewControllerDidTapLogout:(ChoseRealityViewController *)choseRealityViewController;

@end


@interface ChoseRealityViewController : UIViewController

- (IBAction)toggleHellModeTapped:(id)sender;



@property (weak, nonatomic) IBOutlet UIButton *linkedInButton;
@property (weak, nonatomic) IBOutlet UIButton *tripTrackerButton;
@property (weak, nonatomic) IBOutlet UIButton *textMessageButton;
@property (weak, nonatomic) IBOutlet UIButton *playWithPuppiesButton;
@property (weak, nonatomic) IBOutlet UIButton *hellModeButton;
@property (weak, nonatomic) IBOutlet UIButton *soothingSoundsButton;

@property (weak, nonatomic) IBOutlet UILabel *linkedInLabel;
@property (weak, nonatomic) IBOutlet UILabel *tripTrackerLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UILabel *puppiesLabel;
@property (weak, nonatomic) IBOutlet UILabel *hellModeLabel;
@property (weak, nonatomic) IBOutlet UILabel *soothingLabel;

@property (nonatomic, weak) id<ChoseRealityViewControllerDelegate> delegate;

@end
