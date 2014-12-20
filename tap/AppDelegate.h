//
//  AppDelegate.h
//  tap
//
//  Created by Andrew on 2/21/13.
//  Copyright (c) 2013 Andrew. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    NSDate *closeTime;
    NSDate *openTime;
}

@property (strong, nonatomic) UIWindow *window;

@end
