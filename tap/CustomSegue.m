//
//  CustomSegue.m
//  tap
//
//  Created by Andrew on 2/24/13.
//  Copyright (c) 2013 Andrew. All rights reserved.
//

#import "CustomSegue.h"
#import <QuartzCore/QuartzCore.h>
@implementation CustomSegue


- (void) perform
{
    /*CATransition* transition = [CATransition animation];
    
    transition.duration = 3;
    transition.type = kcatra;*/
    
    CATransition *transition = [CATransition animation];
    transition.delegate = self;
    transition.duration = .5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    NSString *types = @"moveIn";
    NSString *subtypes = kCATransitionFromBottom;
    
    transition.type = types;
    transition.subtype = subtypes;
    
    [[self.sourceViewController navigationController].view.layer addAnimation:transition forKey:kCATransition];
    [[self.sourceViewController navigationController] pushViewController:[self destinationViewController] animated:NO];
}

@end
