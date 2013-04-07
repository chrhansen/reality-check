//
//  TripTrackerViewController.h
//  Reality Check
//
//  Created by Christian Hansen on 07/04/13.
//  Copyright (c) 2013 ComedyHack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TripTrackerViewController : UIViewController <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *emptyFormImageView;
@property (weak, nonatomic) IBOutlet UIImageView *filledFormImageView;

- (IBAction)changeForm:(id)sender;

@end
