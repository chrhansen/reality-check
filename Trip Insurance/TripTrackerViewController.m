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

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFields;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) MBProgressHUD *progressHUD;
@property (nonatomic, strong) NSMutableArray *spinnerSteps;
@property (nonatomic, strong) NSMutableArray *answers;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation TripTrackerViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"realityCheck_menuBarLogo.png"]];

	// Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.scrollView setContentSize:CGSizeMake(self.view.bounds.size.width, 800.0f)];
}


- (void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
}

- (IBAction)doneTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)submit:(id)sender
{
    self.progressHUD =[[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:self.progressHUD];
    self.progressHUD.labelText = @"Loading";
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
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(updateTextFields) userInfo:nil repeats:YES];
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

- (NSMutableArray *)answers
{
    if (!_answers) _answers = [@[NSLocalizedString(@"Guess so", nil),
                               NSLocalizedString(@"Don't know / NA", nil),
                               NSLocalizedString(@"Buttload", nil),
                               NSLocalizedString(@"Mushrooms, DMT", nil)] mutableCopy];
    return _answers;
}


- (void)updateTextFields
{
    NSString *answer = [self.answers lastObject];
    if (answer) {
        [self.answers removeObject:answer];
        UITextField *textField = [self textFieldWithTag:4 - [self.answers count]];
        textField.text = answer;
    } else {
        [self.timer invalidate];
        self.timer = nil;
        self.answers = nil;
        [self showConclusion];
    }
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
