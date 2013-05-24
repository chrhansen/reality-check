//
//  UINavigationController+Rotations.m
//  Reality Check
//
//  Created by Christian Hansen on 24/05/13.
//  Copyright (c) 2013 ComedyHack. All rights reserved.
//

#import "UINavigationController+Rotations.h"

@implementation UINavigationController (Rotations)

-(BOOL)shouldAutorotate
{
    return [self.topViewController shouldAutorotate];
}

-(NSUInteger)supportedInterfaceOrientations
{
    return [self.topViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}

@end
