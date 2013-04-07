//
//  RealityViewController.h
//  Trip Insurance
//
//  Created by Christian Hansen on 06/04/13.
//  Copyright (c) 2013 ComedyHack. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChoseRealityViewController;

@protocol ChoseRealityViewControllerDelegate <NSObject>

- (void)choseRealityViewControllerDidTapLogout:(ChoseRealityViewController *)choseRealityViewController;

@end


@interface ChoseRealityViewController : UIViewController

@property (nonatomic, weak) id<ChoseRealityViewControllerDelegate> delegate;

@end
