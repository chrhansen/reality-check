//
//  TextViewController.m
//  Trip Insurance
//
//  Created by Christian Hansen on 06/04/13.
//  Copyright (c) 2013 ComedyHack. All rights reserved.
//

#import "ReassuringMessageViewController.h"
#import <QuartzCore/QuartzCore.h>

#define PhoneNumberKey @"PhoneNumberKey"

@interface ReassuringMessageViewController ()

@property (nonatomic, strong) NSMutableArray *texts;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSString *phoneNumber;

@end

@implementation ReassuringMessageViewController


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
    [self startShowingMessages];
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

- (void)startShowingMessages
{
        [self loadTexts];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(sendAText:) userInfo:nil repeats:YES];
}



- (void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
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

- (void)showAlertWithMessage:(NSString *)message
{
    UIAlertView *alertView = [UIAlertView.alloc initWithTitle:NSLocalizedString(@"Reality Check\u2122", nil)
                                                      message:message
                                                     delegate:nil
                                            cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                            otherButtonTitles:nil];
    [alertView show];
}


- (void)sendAText:(NSTimer *)timer
{
    if ([self.texts count]) {
        NSString *text = self.texts[0];
        [self.texts removeObjectAtIndex:0];
        [self showAlertWithMessage:text];
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
