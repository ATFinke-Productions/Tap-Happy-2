//
//  CustomSeguePop.m
//  tap
//
//  Created by Andrew on 2/24/13.
//  Copyright (c) 2013 Andrew. All rights reserved.
//

#import "CustomSeguePop.h"
#import <QuartzCore/QuartzCore.h>
@implementation CustomSeguePop

- (void) perform
{
    CATransition *transition = [CATransition animation];
    transition.delegate = self;
    transition.duration = .5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    NSString *types = @"reveal";
    NSString *subtypes = kCATransitionFromTop;
    
    transition.type = types;
    transition.subtype = subtypes;
    
    [[self.sourceViewController navigationController].view.layer addAnimation:transition forKey:kCATransition];
    [[self.sourceViewController navigationController] popToRootViewControllerAnimated:NO];
}
@end
