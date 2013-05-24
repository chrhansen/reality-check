//
//  PremiumRealityTapViewController.m
//  Reality Check
//
//  Created by Christian Hansen on 23/05/13.
//  Copyright (c) 2013 ComedyHack. All rights reserved.
//

#import "PremiumRealityTapViewController.h"
#import "MBProgressHUD.h"

@interface PremiumRealityTapViewController ()

@property (nonatomic, strong) MBProgressHUD *wordHUD;
@property (nonatomic, strong) NSArray *streams;
@property (nonatomic, strong) NSMutableArray *currentStream;
@property (nonatomic) NSUInteger currentWordIndex;
@property (nonatomic, strong) NSMutableArray *wordLocations;
@property (nonatomic, getter = isStreamFinished) BOOL streamFinished;
@property (weak, nonatomic) IBOutlet UILabel *tapMeLabel;

@end


@implementation PremiumRealityTapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"realityCheck_menuBarLogo.png"]];
    self.navigationItem.titleView = titleView;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"realityCheck_backgroundGradient"]];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tapMeLabel.hidden = NO;
}


- (IBAction)doneTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (MBProgressHUD *)wordHUD
{
    if (!_wordHUD) {
        _wordHUD = [self defaultHUD];
        [self.view addSubview:_wordHUD];
    }
    return _wordHUD;
}

- (MBProgressHUD *)defaultHUD
{
    MBProgressHUD *defaultHUD = [[MBProgressHUD alloc] initWithView:self.view];
    defaultHUD.mode = MBProgressHUDModeText;
    defaultHUD.labelText = @"Test";
    defaultHUD.margin = 10.f;
    _wordHUD.removeFromSuperViewOnHide = YES;
    return defaultHUD;
}


#define FINGERPOINT_OFFSET 50.0f

- (void)showWord:(NSString *)word atLocation:(CGPoint)location
{
    [self.wordHUD hide:NO];
    CGPoint offset = [self centerOffsetForLocation:location];
    self.wordHUD.xOffset = offset.x;
    self.wordHUD.yOffset = offset.y - FINGERPOINT_OFFSET;
    self.wordHUD.labelText = word;
    [self.wordHUD show:NO];
}


- (void)showWords:(NSArray *)words atLocations:(NSArray *)locations
{
    if ([words count] != [locations count]) return;
    
    for (NSUInteger index = 0; index < [words count]; index++) {
        MBProgressHUD *HUD = [self defaultHUD];
        HUD.labelText = words[index];
        CGPoint offset = [self centerOffsetForLocation:[locations[index] CGPointValue]];
        HUD.xOffset = offset.x;
        HUD.yOffset = offset.y - FINGERPOINT_OFFSET;
        HUD.removeFromSuperViewOnHide = YES;
        [self.view addSubview:HUD];
        [HUD show:NO];
    }
}


- (CGPoint)centerOffsetForLocation:(CGPoint)location
{
    CGPoint offset;
    offset.x = location.x - self.view.bounds.size.width * 0.5f;
    offset.y = location.y - self.view.bounds.size.height * 0.5f;
    return offset;
}


- (void)resetHUDs
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    self.wordHUD = nil;
    self.streamFinished = NO;
    self.currentWordIndex = 0;
    self.tapMeLabel.hidden = NO;
}

- (IBAction)tapGesture:(UITapGestureRecognizer *)tapGesture
{
    if (self.isStreamFinished) {
        [self resetHUDs];
        return;
    }
    
    self.tapMeLabel.hidden = YES;
    
    CGPoint tapLocation = [tapGesture locationInView:self.view];
    if (self.currentWordIndex > [self.currentStream count] - 1) {
        [self showWords:self.currentStream atLocations:self.wordLocations];
        self.streamFinished = YES;
        self.currentStream = nil;
    } else {
        NSString *word = self.currentStream[self.currentWordIndex];
        self.currentWordIndex++;
        [self showWord:word atLocation:tapLocation];
        [self.wordLocations addObject:[NSValue valueWithCGPoint:tapLocation]];
    }
}


- (NSArray *)streams
{
    if (!_streams) _streams = @[@"Your friends freaking love you",
                                @"Your parents are super proud of you",
                                @"You’re really really really REALLY good-looking",
                                @"I mean your friends love the SHIT out of you",
                                @"You inspire others all the freaking time without even trying",
                                @"People look to you and think [“Right-On”]",
                                @"You have natural sense of really incredible rhythm",
                                @"Positive things spontaneously happen around you all the time and that’s pretty cool"];
    return _streams;
}

- (NSMutableArray *)currentStream
{
    if (!_currentStream) {
        NSInteger randomIndex = arc4random() % [self.streams count];
        _currentStream = [[[self.streams[randomIndex] copy] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] mutableCopy];
        self.currentWordIndex = 0;
        self.wordLocations = [NSMutableArray array];
    }
    return _currentStream;
}


@end
