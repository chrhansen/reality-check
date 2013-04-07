//
//  TextViewController.m
//  Trip Insurance
//
//  Created by Christian Hansen on 06/04/13.
//  Copyright (c) 2013 ComedyHack. All rights reserved.
//

#import "TextViewController.h"
#import "RCTwilioHelper.h"

@interface TextViewController ()

@property (nonatomic, strong) NSMutableArray *texts;
@property (nonatomic, strong) NSTimer *timer;

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
    [self loadTexts];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(sendAText:) userInfo:nil repeats:YES];
    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"realityCheck_menuBarLogo.png"]];
    self.navigationItem.titleView = titleView;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                  @"You’re not STILL tripping, are you?"] mutableCopy];
}


#define SEAN @"+19492903567"
#define CHRISTIAN @"+14155685431"



- (void)sendAText:(NSTimer *)timer
{
    if (self.texts.lastObject) {
        NSString *text = self.texts[0];
        [self.texts removeObjectAtIndex:0];
        [[RCTwilioHelper sharedHelper] sendTextFromNumber:@"+14158814311" toNumber:CHRISTIAN bodyText:text];
    } else {
        [self.timer invalidate];
        self.timer = nil;
    }
}







- (IBAction)doneTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
