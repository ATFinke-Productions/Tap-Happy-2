//
//  HelperMethods.h
//  MonkeyJump
//
//  Created by Fahim Farook on 18/8/12.
//
//

#import <Foundation/Foundation.h>

@interface HelperMethods : NSObject

+(void)reportAchievementsForWins:(int64_t) wins;
+(void)reportAchievementsForTaps:(int64_t)taps;
+(void)reportAchievementsForLosses:(int64_t)loss;
+(void)reportAchievementsForTotal:(int64_t)total;
@end
