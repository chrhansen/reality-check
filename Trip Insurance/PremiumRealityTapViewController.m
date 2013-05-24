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

@end


@implementation PremiumRealityTapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"realityCheck_menuBarLogo.png"]];
    self.navigationItem.titleView = titleView;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"realityCheck_backgroundGradient"]];

}


- (MBProgressHUD *)wordHUD
{
    if (!_wordHUD) {
        _wordHUD = [[MBProgressHUD alloc] initWithView:self.view];
        _wordHUD.mode = MBProgressHUDModeText;
        _wordHUD.labelText = @"Test";
        _wordHUD.margin = 10.f;
//        _wordHUD.removeFromSuperViewOnHide = YES;
        [self.view addSubview:_wordHUD];
    }
    return _wordHUD;
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

- (CGPoint)centerOffsetForLocation:(CGPoint)location
{
    CGPoint offset;
    offset.x = location.x - self.view.bounds.size.width * 0.5f;
    offset.y = location.y - self.view.bounds.size.height * 0.5f;
    return offset;
}


- (IBAction)tapGesture:(UITapGestureRecognizer *)tapGesture
{
    CGPoint tapLocation = [tapGesture locationInView:self.view];
    NSString *word = self.currentStream[0];
    [self.currentStream removeObject:word];
    if (![self.currentStream count]) self.currentStream = nil;
    [self showWord:word atLocation:tapLocation];
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
    }
    return _currentStream;
}


@end
