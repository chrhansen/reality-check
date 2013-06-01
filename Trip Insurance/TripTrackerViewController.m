//
//  TripTrackerViewController.m
//  Reality Check
//
//  Created by Christian Hansen on 07/04/13.
//  Copyright (c) 2013 ComedyHack. All rights reserved.
//

#import "TripTrackerViewController.h"
#import "MBProgressHUD.h"

@interface TripTrackerViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFields;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) MBProgressHUD *progressHUD;
@property (nonatomic, strong) NSMutableArray *spinnerSteps;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation TripTrackerViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"realityCheck_menuBarLogo.png"]];
    [self styleSubmitButton];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.scrollView setContentSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height + 150)];
}


- (void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
}


- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (IBAction)doneTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)styleSubmitButton
{
    UIImage *buttonImage = [[UIImage imageNamed:@"whiteButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *highlightedButtonImage = [[UIImage imageNamed:@"whiteButtonHighlight"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    [self.submitButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.submitButton setBackgroundImage:highlightedButtonImage forState:UIControlStateHighlighted];

}

- (IBAction)submit:(id)sender
{
    self.progressHUD =[[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:self.progressHUD];
    self.progressHUD.labelText = @"Loading";
    self.progressHUD.dimBackground = YES;
	[self prepareSpinnerSteps];
    [self.progressHUD show:YES];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.2 target:self selector:@selector(updateSpinner) userInfo:nil repeats:YES];
}


- (void)prepareSpinnerSteps
{
    self.spinnerSteps = [NSMutableArray array];
    [self.spinnerSteps addObject:NSLocalizedString(@"Finished!", nil)];
    [self.spinnerSteps addObject:NSLocalizedString(@"Almost there...", nil)];
    [self.spinnerSteps addObject:NSLocalizedString(@"Calculating...", nil)];
    [self.spinnerSteps addObject:NSLocalizedString(@"Processing...", nil)];
    [self.spinnerSteps addObject:NSLocalizedString(@"Sending...", nil)];
}


- (void)updateSpinner
{
    NSString *message = [self.spinnerSteps lastObject];
    if (message) {
        [self.spinnerSteps removeObject:message];
        self.progressHUD.labelText = message;
    } else {
        self.progressHUD.removeFromSuperViewOnHide = YES;
        [self.progressHUD hide:YES];
        [self.timer invalidate];
        self.timer = nil;
        [self showConclusion];
    }
}


- (void)showConclusion
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Reality Check\u2122"
                                                        message:NSLocalizedString(@"Hopefully you will be fine in a couple of hours.", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                              otherButtonTitles:nil];
    [alertView show];
}


- (UITextField *)textFieldWithTag:(NSInteger)tag
{
    for (UITextField *textField in self.textFields) {
        if (textField.tag == tag) {
            return textField;
            break;
        }
    }
    return nil;
}


#pragma mark - UITextField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)currentTextField
{
    NSInteger nextTag = currentTextField.tag + 1;
    if (nextTag <= 4) {
        for (UITextField *textField in self.textFields) {
            if (textField.tag == nextTag) {
                [currentTextField resignFirstResponder];
                [textField becomeFirstResponder];
                break;
            }
        }
    } else {
        [currentTextField resignFirstResponder];
    }
    return YES;
}

@end
