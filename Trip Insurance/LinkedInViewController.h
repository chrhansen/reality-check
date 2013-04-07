//
//  LinkedInViewController.h
//  Trip Insurance
//
//  Created by Christian Hansen on 06/04/13.
//  Copyright (c) 2013 ComedyHack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LinkedInViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobPositionLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobCompanyLabel;
@property (weak, nonatomic) IBOutlet UITextView *recommendationTextView;
@property (weak, nonatomic) IBOutlet UILabel *recommendationNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *skillCountLabel;

#pragma mark Animation
@property (weak, nonatomic) IBOutlet UILabel *animatedLabel;




- (IBAction)doneTapped:(id)sender;

@end
