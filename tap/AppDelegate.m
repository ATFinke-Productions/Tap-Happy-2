//
//  AppDelegate.m
//  tap
//
//  Created by Andrew on 2/21/13.
//  Copyright (c) 2013 Andrew. All rights reserved.
//

#import "AppDelegate.h"
#import "GCHelper.h"
#import "iRate.h"
#import "MKiCloudSync.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
   /*NSDictionary *defaultsDictionary = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
     for (NSString *key in [defaultsDictionary allKeys]) {
     [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
     }
     [[NSUserDefaults standardUserDefaults] synchronize];*/
    //[TestFlight takeOff:@"6afffdfcce8160de948c11f3f36b8913_MjA5MTkyMDEyLTAzLTI4IDE4OjI4OjMwLjIxNjAwOA"];
    [MKiCloudSync start];
    [iRate sharedInstance].daysUntilPrompt = 3;
    [iRate sharedInstance].usesUntilPrompt = 3;

  //  [ATFinke start];
    [[GCHelper sharedInstance] authenticateLocalPlayer];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if (![[defaults valueForKey:@"lastVersion"] isEqual:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]]) {
        [defaults setValue:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"] forKey:@"lastVersion"];
        NSDateFormatter *currentTimeFor = [NSDateFormatter new];
        [currentTimeFor setDateFormat:@"MM/dd hh:mm a"];
        [defaults setValue:[NSString stringWithFormat:@"Build Time: %@",[currentTimeFor stringFromDate:[NSDate date]]] forKey:@"BuildTime"];
        NSLog(@"%@,%@",[defaults valueForKey:@"lastVersion"],[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]);
    }
    [defaults synchronize];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:@"Playing"]) {
        [defaults setBool:YES forKey:@"ForceDisconnected"];
    }
    [defaults setBool:NO forKey:@"Playing"];
    [defaults synchronize];
    
    closeTime = [NSDate date];
    NSTimeInterval timeDifference = [closeTime timeIntervalSinceDate:openTime];
    
    float totalTime = [defaults floatForKey:@"timeInGame"] + timeDifference;
    [defaults setFloat:totalTime forKey:@"timeInGame"];
    [defaults synchronize];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    openTime = [NSDate date];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
