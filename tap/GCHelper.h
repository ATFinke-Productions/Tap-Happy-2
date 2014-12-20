//
//  GCHelper.h
//  CatRace
//
//  Created by Ray Wenderlich on 4/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "FriendsPickerViewController.h"
#import "HelperMethods.h"

@protocol GCHelperDelegate<NSObject>
@optional
-(void)inviteReceived;
-(void) onAchievementsLoaded:(NSDictionary*)achievements;
-(void) onAchievementReported:(GKAchievement*)achievement;
- (void)matchStarted;
- (void)matchEnded;
- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID;
-(void) onScoresSubmitted:(bool)success;
-(void) onScoresOfFriendsToChallengeListReceived:(NSArray*)scores;
-(void) onPlayerInfoReceived:(NSArray*)players;

@end

@interface GCHelper : NSObject <GKMatchmakerViewControllerDelegate, GKMatchDelegate, GKGameCenterControllerDelegate> {
    BOOL gameCenterAvailable;
    BOOL userAuthenticated;
    
    UIViewController *presentingViewController;
    GKMatch *match;
    BOOL matchStarted;
    id <GCHelperDelegate> delegate;
    NSMutableDictionary *playersDict;
    GKInvite *pendingInvite;
    NSArray *pendingPlayersToInvite;
    
}
@property (nonatomic, readonly) NSMutableDictionary* achievements;
@property (nonatomic, readwrite) BOOL includeLocalPlayerScore;
@property (assign, readonly) BOOL gameCenterAvailable;
@property (retain) UIViewController *presentingViewController;
@property (retain) GKMatch *match;
@property (assign) id <GCHelperDelegate> delegate;
@property (retain) NSMutableDictionary *playersDict;
@property (retain) GKInvite *pendingInvite;
@property (retain) NSArray *pendingPlayersToInvite;
@property (nonatomic, readonly) NSError* lastError;
-(void) submitScore:(int64_t)score category:(NSString*)category;
-(void) reportAchievementWithID:(NSString*)identifier percentComplete:(float)percent;
-(void) authenticateLocalPlayer;
-(void) showGameCenterViewController;
-(void) shareScore:(int64_t)score catergory:(NSString*)category;
-(void) findScoresOfFriendsToChallenge;
-(void) getPlayerInfo:(NSArray*)playerList;
-(void) sendScoreChallengeToPlayers:(NSArray*)players withScore:(int64_t)score message:(NSString*)message;
-(void)showFriendsPickerViewControllerForScore:(int64_t)score;
+ (GCHelper *)sharedInstance;
- (void)findMatchWithMinPlayers:(int)minPlayers maxPlayers:(int)maxPlayers viewController:(UIViewController *)viewController delegate:(id<GCHelperDelegate>)theDelegate;
- (void) resetAchievements;


@end
