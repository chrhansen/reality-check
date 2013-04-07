//
//  LinkedInViewController.m
//  Trip Insurance
//
//  Created by Christian Hansen on 06/04/13.
//  Copyright (c) 2013 ComedyHack. All rights reserved.
//

#import "LinkedInViewController.h"
#import "RCLinkedInHelper.h"

@interface LinkedInViewController ()

@end

@implementation LinkedInViewController

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
    [self loadProfile];
    [self loadHighResPhoto];
    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"realityCheck_menuBarLogo.png"]];
    self.navigationItem.titleView = titleView;

	// Do any additional setup after loading the view.
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self testAnimation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)loadProfile
{
    [[RCLinkedInHelper sharedHelper] fetchUserInfoCurrrentUserSuccess:^(id JSON) {
        [self updateUIWithDictionary:JSON];
    } failure:^(NSError *error, id JSON) {
        NSLog(@"error: %@", error.localizedDescription);
    }];
}


- (void)loadHighResPhoto
{
    [[RCLinkedInHelper sharedHelper] fetchHighResPhotoForCurrentUserSuccess:^(id JSON) {
        NSString *highResPath = [JSON[@"values"] lastObject];
        if (highResPath) [self.profileImageView setImageWithURL:[NSURL URLWithString:highResPath]];
        
        //[self updateUIWithDictionary:JSON];
    } failure:^(NSError *error, id JSON) {
        NSLog(@"error: %@", error.localizedDescription);
    }];
}



- (void)updateUIWithDictionary:(NSDictionary *)dictionary
{
    // Image
    if (self.profileImageView.image == nil) {
//        [self.profileImageView setImageWithURL:[NSURL URLWithString:dictionary[@"pictureUrl"]]];
    }
    
    // Name
    NSString *nameString = @"";
    if (dictionary[@"firstName"]) nameString = [nameString stringByAppendingString:dictionary[@"firstName"]];
    if (dictionary[@"lastName"]) nameString = [nameString stringByAppendingFormat:@" %@", dictionary[@"lastName"]];
    [self.nameLabel setText:nameString];
    
    // Job position
    self.jobPositionLabel.text = [dictionary[@"threeCurrentPositions"][@"values"] lastObject][@"company"][@"name"];
    self.jobCompanyLabel.text = [dictionary[@"threeCurrentPositions"][@"values"] lastObject][@"title"];
    
    // Recommendations
    NSString *recommendation = [dictionary[@"recommendationsReceived"][@"values"] lastObject][@"recommendationText"];
    if (recommendation) self.recommendationTextView.text = recommendation;
    
    NSDictionary *recommender = [dictionary[@"recommendationsReceived"][@"values"] lastObject][@"recommender"];
    if (recommender) {
        NSString *recommenderName = @"- ";
        if (recommender[@"firstName"]) recommenderName = [recommenderName stringByAppendingString:recommender[@"firstName"]];
        if (recommender[@"lastName"]) recommenderName = [recommenderName stringByAppendingFormat:@" %@", recommender[@"lastName"]];
        self.recommendationNameLabel.text = recommenderName;
    }

    // Skills
    self.skillCountLabel.text = [NSString stringWithFormat:@"%d", [dictionary[@"skills"][@"values"] count]];
}


- (IBAction)doneTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}




#pragma mark animations
- (void)testAnimation
{
    [UIView animateWithDuration:2.0 animations:^{
        CGAffineTransform transform = self.animatedLabel.transform;
        transform = CGAffineTransformTranslate(transform, -180.0f, -130.0f);
//        transform = CGAffineTransformRotate(transform, -M_PI_4);
        self.animatedLabel.transform = transform;
    } completion:^(BOOL finished) {
        NSLog(@"next anim");
    }];
}


@end
