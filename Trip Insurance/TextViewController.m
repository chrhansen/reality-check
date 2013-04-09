//
//  TextViewController.m
//  Trip Insurance
//
//  Created by Christian Hansen on 06/04/13.
//  Copyright (c) 2013 ComedyHack. All rights reserved.
//

#import "TextViewController.h"
#import "RCTwilioHelper.h"
#import <QuartzCore/QuartzCore.h>

#define PhoneNumberKey @"PhoneNumberKey"

@interface TextViewController ()

@property (nonatomic, strong) NSMutableArray *texts;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSString *phoneNumber;

@end

@implementation TextViewController

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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"realityCheck_backgroundGradient"]];
    [self addTextShadowToLabel];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self startSendingTextsIfPhoneNumberStored];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)addTextShadowToLabel
{
    self.backgroundLabel.layer.shadowOpacity = 0.5;
    self.backgroundLabel.layer.shadowRadius = 3.0;
    self.backgroundLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.backgroundLabel.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    self.backgroundLabel.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    self.backgroundLabel.layer.shouldRasterize = YES;
}

- (void)startSendingTextsIfPhoneNumberStored
{
    NSString *phoneNumber = [[NSUserDefaults standardUserDefaults] valueForKey:PhoneNumberKey];
    if (phoneNumber.length > 0) {
        self.phoneNumber = phoneNumber;
        [self loadTexts];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(sendAText:) userInfo:nil repeats:YES];
    } else {
        [self showMissingPhoneNumberAlert];
    }
}



- (void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
}


- (void)showMissingPhoneNumberAlert
{
    UIAlertView *alertView = [UIAlertView.alloc initWithTitle:NSLocalizedString(@"No Phone Number", nil)
                                                      message:NSLocalizedString(@"To receive reassuring text messages, you have to add a phone number by logging out of reality and then enter your number as you log in again.", nil)
                                                     delegate:nil
                                            cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                            otherButtonTitles:nil];
    [alertView show];
}


- (void)loadTexts
{
    self.texts = [@[@"Hey there. Everything is going to be just fine.",
                  @"Everyone is proud of you, and you will feel better in the morning.",
                  @"You’re doing great.",
                  @"Look: everyone else is tripping JUST as hard, if not harder. They’re not judging. If anything, they’re judging that they LIKE YOU.",
                  @"Nothing matters anyway. Too soon? I meant it in a GOOD WAY.",
                  @"Maybe you should have a snack. It couldn’t hurt. It might even have tasty results!",
                  @"Still tripping? Hmmm. You probably shouldn’t be. But don’t be TOO concerned.",
                  @"Why would you bother to trip out this hard, if you’re just going to spend the entire time worrying.",
                  @"You’re not STILL tripping, are you?",
                  @"Oh, boy. Better get back to Reality Check\u2122",
                  @"Don’t want to trip forever? You should probably Upgrade Your Reality Check\u2122"]
                  mutableCopy];
}


#define TwilioNumber @"+14158814311"

- (void)sendAText:(NSTimer *)timer
{
    if (self.texts.lastObject) {
        NSString *text = self.texts[0];
        [self.texts removeObjectAtIndex:0];
        [[RCTwilioHelper sharedHelper] sendTextFromNumber:TwilioNumber toNumber:self.phoneNumber bodyText:text];
    } else {
        [self.timer invalidate];
        self.timer = nil;
    }
}



- (IBAction)doneTapped:(id)sender
{
    [self.timer invalidate];
    self.timer = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
