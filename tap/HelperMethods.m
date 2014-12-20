//
//  HelperMethods.m
//  MonkeyJump
//
//  Created by Fahim Farook on 18/8/12.
//
//

#import "HelperMethods.h"
#import "GameConstants.h"

@implementation HelperMethods

+(void)reportAchievementsForWins:(int64_t)wins{

    NSString *rootPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 	 NSUserDomainMask, YES)[0];
    
    NSString *plistPath =
	[rootPath
	 stringByAppendingPathComponent:
	 kAchievementsWinsFileName];
    
    if (![[NSFileManager defaultManager]
          fileExistsAtPath:plistPath]) {
        
        plistPath =
		[[NSBundle mainBundle]
		 pathForResource:kAchievementsWinsResourceName
		 ofType:@"plist"];
    }
    
    // 2
    NSArray *achievements =
	[NSArray arrayWithContentsOfFile:plistPath];
    
    // 3
    if (achievements == nil) {
        NSLog(@"Error reading plist: %@",
              kAchievementsWinsFileName);
        return;
    }
    
    // 4
    for (NSDictionary *achievementDetail
		 in achievements) {
        
        NSString *achievementId =
		achievementDetail[@"achievementId"];
        
        NSString *number =
		achievementDetail[@"number"];
        
        float percentComplete =
		(wins * 1.0f/[number intValue])
		* 100;
        NSLog(@"%lld  needed:%@  percent:%f",wins,number,percentComplete);
        if (percentComplete > 100)
            percentComplete = 100;
        
        [[GCHelper sharedInstance] reportAchievementWithID:achievementId 		 percentComplete:percentComplete];
    }
}

+(void)reportAchievementsForTaps:(int64_t)taps{
    NSString *rootPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 	 NSUserDomainMask, YES)[0];
    
    NSString *plistPath =
	[rootPath
	 stringByAppendingPathComponent:
	 kAchievementsTapsFileName];
    
    if (![[NSFileManager defaultManager]
          fileExistsAtPath:plistPath]) {
        
        plistPath =
		[[NSBundle mainBundle]
		 pathForResource:kAchievementsTapsResourceName
		 ofType:@"plist"];
    }
    
    // 2
    NSArray *achievements =
	[NSArray arrayWithContentsOfFile:plistPath];
    
    // 3
    if (achievements == nil) {
        NSLog(@"Error reading plist: %@",
              kAchievementsTapsFileName);
        return;
    }
    
    // 4
    for (NSDictionary *achievementDetail
		 in achievements) {
        
        NSString *achievementId =
		achievementDetail[@"achievementId"];
        
        NSString *number =
		achievementDetail[@"number"];
        
        float percentComplete =
		(taps * 1.0f/[number intValue])
		* 100;
        
        if (percentComplete > 100)
            percentComplete = 100;
        if (percentComplete < 100)
            percentComplete = 0;
        [[GCHelper sharedInstance] reportAchievementWithID:achievementId 		 percentComplete:percentComplete];
    }
}
+(void)reportAchievementsForLosses:(int64_t)loss{

    NSString *rootPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 	 NSUserDomainMask, YES)[0];
    
    NSString *plistPath =
	[rootPath
	 stringByAppendingPathComponent:
	 kAchievementsLossFileName];
    
    if (![[NSFileManager defaultManager]
          fileExistsAtPath:plistPath]) {
        
        plistPath =
		[[NSBundle mainBundle]
		 pathForResource:kAchievementsLossResourceName
		 ofType:@"plist"];
    }
    
    // 2
    NSArray *achievements =
	[NSArray arrayWithContentsOfFile:plistPath];
    
    // 3
    if (achievements == nil) {
        NSLog(@"Error reading plist: %@",
              kAchievementsLossFileName);
        return;
    }
    
    // 4
    for (NSDictionary *achievementDetail
		 in achievements) {
        
        NSString *achievementId =
		achievementDetail[@"achievementId"];
        
        NSString *number =
		achievementDetail[@"number"];
        
        float percentComplete =
		(loss * 1.0f/[number intValue])
		* 100;
        NSLog(@"%lld  needed:%@  percent:%f",loss,number,percentComplete);
        if (percentComplete > 100)
            percentComplete = 100;
        
        [[GCHelper sharedInstance] reportAchievementWithID:achievementId 		 percentComplete:percentComplete];
    }
}
+(void)reportAchievementsForTotal:(int64_t)total{
    NSString *rootPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 	 NSUserDomainMask, YES)[0];
    
    NSString *plistPath =
	[rootPath
	 stringByAppendingPathComponent:
	 kAchievementsTotalFileName];
    
    if (![[NSFileManager defaultManager]
          fileExistsAtPath:plistPath]) {
        
        plistPath =
		[[NSBundle mainBundle]
		 pathForResource:kAchievementsTotalResourceName
		 ofType:@"plist"];
    }
    
    // 2
    NSArray *achievements =
	[NSArray arrayWithContentsOfFile:plistPath];
    
    // 3
    if (achievements == nil) {
        NSLog(@"Error reading plist: %@",
              kAchievementsTotalFileName);
        return;
    }
    
    // 4
    for (NSDictionary *achievementDetail
		 in achievements) {
        
        NSString *achievementId =
		achievementDetail[@"achievementId"];
        
        NSString *number =
		achievementDetail[@"number"];
        
        float percentComplete =
		(total * 1.0f/[number intValue])
		* 100;
        
        if (percentComplete > 100)
            percentComplete = 100;
        
        [[GCHelper sharedInstance] reportAchievementWithID:achievementId 		 percentComplete:percentComplete];
    }
}
@end
