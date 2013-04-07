//
//  PuppiesViewController.h
//  Trip Insurance
//
//  Created by Christian Hansen on 06/04/13.
//  Copyright (c) 2013 ComedyHack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PuppiesViewController : UIViewController <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)doneTapped:(id)sender;

@end
