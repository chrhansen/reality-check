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
	// Do any additional setup after loading the view.
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


- (void)updateUIWithDictionary:(NSDictionary *)dictionary
{
    // Image
//    NSLog(@"dictionary: %@", dictionary);
    [self.profileImageView setImageWithURL:[NSURL URLWithString:dictionary[@"pictureUrl"]]];
    
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
@end
