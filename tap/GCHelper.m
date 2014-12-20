//
//  GCHelper.m
//  CatRace
//
//  Created by Ray Wenderlich on 4/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GCHelper.h"
#import "GameConstants.h"

@implementation GCHelper

@synthesize gameCenterAvailable;
@synthesize presentingViewController;
@synthesize match;
@synthesize delegate = _delegate;
@synthesize playersDict;
@synthesize pendingInvite;
@synthesize pendingPlayersToInvite;

#pragma mark Initialization

- (BOOL)isGameCenterAvailable {
	// check for presence of GKLocalPlayer API
	Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
	
	// check if the device is running iOS 4.1 or later
	NSString *reqSysVer = @"4.1";
	NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
	BOOL osVersionSupported = ([currSysVer compare:reqSysVer 
                                           options:NSNumericSearch] != NSOrderedAscending);
	
	return (gcClass && osVersionSupported);
}

- (id)init {
    if ((self = [super init])) {
        gameCenterAvailable = [self isGameCenterAvailable];
        if (gameCenterAvailable) {
            NSNotificationCenter *nc = 
            [NSNotificationCenter defaultCenter];
            [nc addObserver:self 
                   selector:@selector(authenticationChanged) 
                       name:GKPlayerAuthenticationDidChangeNotificationName 
                     object:nil];
        }
    }
    return self;
}


#pragma mark Internal functions

- (void)authenticationChanged {
    
    if ([GKLocalPlayer localPlayer].isAuthenticated && !userAuthenticated) {
        NSLog(@"Authentication changed: player authenticated.");
        userAuthenticated = TRUE;
        
        [GKMatchmaker sharedMatchmaker].inviteHandler = ^(GKInvite *acceptedInvite, NSArray *playersToInvite) {
            
            NSLog(@"Received invite");
            self.pendingInvite = acceptedInvite;
            self.pendingPlayersToInvite = playersToInvite;
            if ([_delegate respondsToSelector:@selector(inviteReceived)]) {
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setInteger:1 forKey:@"InviteWaiting"];
                [defaults synchronize];
                [_delegate inviteReceived];
            }
            
            
        };
        
    } else if (![GKLocalPlayer localPlayer].isAuthenticated && userAuthenticated) {
        NSLog(@"Authentication changed: player not authenticated");
        userAuthenticated = FALSE;
    }
    
}

- (void)lookupPlayers {
    
    NSLog(@"Looking up %d players...", match.playerIDs.count);
    [GKPlayer loadPlayersForIdentifiers:match.playerIDs withCompletionHandler:^(NSArray *players, NSError *error) {
        
        if (error != nil) {
            NSLog(@"Error retrieving player info: %@", error.localizedDescription);
            matchStarted = NO;
            [delegate matchEnded];
        } else {
            
            // Populate players dict
            self.playersDict = [NSMutableDictionary dictionaryWithCapacity:players.count];
            for (GKPlayer *player in players) {
                NSLog(@"Found player: %@", player.alias);
                [playersDict setObject:player forKey:player.playerID];
            }
            
            // Notify delegate match can begin
            matchStarted = YES;
            [delegate matchStarted];
            
        }
    }];
    
}

#pragma mark User functions



- (void)findMatchWithMinPlayers:(int)minPlayers maxPlayers:(int)maxPlayers viewController:(UIViewController *)viewController delegate:(id<GCHelperDelegate>)theDelegate {
    
    if (!gameCenterAvailable) return;
    
    matchStarted = NO;
    self.match = nil;
    self.presentingViewController = viewController;
    delegate = theDelegate;
    [self dismissModalViewController];
    GKMatchmakerViewController *mmvc;
    
    
    if (pendingInvite != nil) {
        mmvc  = [[GKMatchmakerViewController alloc] initWithInvite:pendingInvite];
    } else {
        GKMatchRequest *request = [[GKMatchRequest alloc] init]; 
        request.minPlayers = minPlayers;     
        request.maxPlayers = maxPlayers;
        request.playersToInvite = pendingPlayersToInvite;
        mmvc = [[GKMatchmakerViewController alloc] initWithMatchRequest:request];    
    }
     mmvc.matchmakerDelegate = self;
    [self presentViewController:mmvc];
    self.pendingInvite = nil;
    self.pendingPlayersToInvite = nil;
    
}

#pragma mark GKMatchmakerViewControllerDelegate

// The user has cancelled matchmaking
- (void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"MatchmakerCancelled"];
    [defaults synchronize];
    [self dismissModalViewController];
}

// Matchmaking has failed with an error
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"MatchmakerCancelled"];
    [defaults synchronize];
    [self dismissModalViewController];
    NSLog(@"Error finding match: %@", error.localizedDescription);    
}

// A peer-to-peer match has been found, the game should start
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindMatch:(GKMatch *)theMatch {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:@"MatchmakerCancelled"];
    [defaults synchronize];
    [self dismissModalViewController];
    self.match = theMatch;
    match.delegate = self;
    if (!matchStarted && match.expectedPlayerCount == 0) {
        NSLog(@"Ready to start match!");
        [self lookupPlayers];
    }
}


#pragma mark GKMatchDelegate

// The match received data sent from the player.
- (void)match:(GKMatch *)theMatch didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID {
    
    if (match != theMatch) return;
    
    [delegate match:theMatch didReceiveData:data fromPlayer:playerID];
}

// The player state changed (eg. connected or disconnected)
- (void)match:(GKMatch *)theMatch player:(NSString *)playerID didChangeState:(GKPlayerConnectionState)state {
    
    if (match != theMatch) return;
    
    switch (state) {
        case GKPlayerStateConnected: 
            // handle a new player connection.
            NSLog(@"Player connected!");
            
            if (!matchStarted && theMatch.expectedPlayerCount == 0) {
                NSLog(@"Ready to start match!");
                [self lookupPlayers];
            }
            
            break; 
        case GKPlayerStateDisconnected:
            // a player just disconnected. 
            NSLog(@"Player disconnected!");
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            if ([defaults boolForKey:@"CanDisconnect"]) {
                [defaults setBool:YES forKey:@"Disconnected"];
            }
            [defaults synchronize];
            matchStarted = NO;
            [delegate matchEnded];
            break;
    }                 
    
}

// The match was unable to connect with the player due to an error.
- (void)match:(GKMatch *)theMatch connectionWithPlayerFailed:(NSString *)playerID withError:(NSError *)error {
    
    if (match != theMatch) return;
    
    NSLog(@"Failed to connect to player with error: %@", error.localizedDescription);
    matchStarted = NO;
    [delegate matchEnded];
}

// The match was unable to be established with any players due to an error.
- (void)match:(GKMatch *)theMatch didFailWithError:(NSError *)error {
    
    if (match != theMatch) return;
    
    NSLog(@"Match failed with error: %@", error.localizedDescription);
    matchStarted = NO;
    [delegate matchEnded];
}


#pragma mark Singleton stuff

+(id) sharedInstance {
    static GCHelper *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance =
		[[GCHelper alloc] init];
    });
    return sharedInstance;
}

#pragma mark Player Authentication

-(void)authenticateLocalPlayer {
	if ([[[UIDevice currentDevice] systemVersion]floatValue] >= 6.0) {
     GKLocalPlayer* localPlayer = [GKLocalPlayer localPlayer];
	
    __weak GKLocalPlayer *blockLocalPlayer = localPlayer;
    
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error) {
        
        [self setLastError:error];
        
        if (blockLocalPlayer.authenticated) {
            userAuthenticated = YES;
        } else if(viewController) {
            [self presentViewController:viewController];
        } else {
            userAuthenticated = NO;
        }
    };
    }
    else{
    
    NSLog(@"Authenticating local user...");
    if ([GKLocalPlayer localPlayer].authenticated == NO) {
        [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:nil];
    } else {
        NSLog(@"Already authenticated!");
    }
    }
}

#pragma mark Game Center UI method

-(void) showGameCenterViewController {
    //1
    GKGameCenterViewController *gameCenterViewController = [[GKGameCenterViewController alloc] init];
    
    //2
    gameCenterViewController.gameCenterDelegate = self;
    
    //3
    gameCenterViewController.viewState = GKGameCenterViewControllerStateDefault;
    
    //4
    [self presentViewController:gameCenterViewController];
}

-(void) submitScore:(int64_t)score category:(NSString*)category {
    //1: Check if Game Center features are enabled
    if (!userAuthenticated) {
        NSLog(@"Player not authenticated");
        return;
    }
    
    //2: Create a GKScore object
    GKScore* gkScore = [[GKScore alloc] initWithCategory:category];
    
    //3: Set the score value
    gkScore.value = score;
    
    //4: Send the score to Game Center
    [gkScore reportScoreWithCompletionHandler:^(NSError* error) {
        
        [self setLastError:error];
        
        BOOL success = (error == nil);
        
        if ([delegate respondsToSelector:@selector(onScoresSubmitted:)]) {
            
            [delegate onScoresSubmitted:success];
        }
    }];
}

-(void)shareScore:(int64_t)score catergory:(NSString*)category {
    //1
    GKScore* gkScore = [[GKScore alloc] initWithCategory:category];
    gkScore.value = score;
    
    //2
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]
                                                        initWithActivityItems:@[gkScore]
                                                        applicationActivities:nil];
    
    //3
    activityViewController.completionHandler =
    ^(NSString *activityType, BOOL completed) {
        
        if (completed)
            [self dismissModalViewController];
    };
    
    //4
    [self presentViewController:
	 activityViewController];
}




-(void) findScoresOfFriendsToChallenge {
    //1
    GKLeaderboard *leaderboard = [[GKLeaderboard alloc] init];
    
    //2
    leaderboard.category = kGameTaps;
    
    //3
    leaderboard.playerScope = GKLeaderboardPlayerScopeFriendsOnly;
    
    //4
    leaderboard.range = NSMakeRange(1, 100);
    
    //5
    [leaderboard loadScoresWithCompletionHandler:^(NSArray *scores, NSError *error) {
        
        [self setLastError:error];
        
        BOOL success = (error == nil);
        
        if (success) {
            if (!_includeLocalPlayerScore) {
                NSMutableArray *friendsScores = [NSMutableArray array];
                
                for (GKScore *score in scores) {
                    if (![score.playerID isEqualToString:[GKLocalPlayer localPlayer].playerID]) {
                        [friendsScores addObject:score];
                    }
                }
                scores = friendsScores;
            }
            if ([_delegate respondsToSelector:@selector(onScoresOfFriendsToChallengeListReceived:)]) {
                [_delegate onScoresOfFriendsToChallengeListReceived:scores];
            }
        }
    }];
}

-(void) getPlayerInfo:(NSArray*)playerList {
    //1
    if (userAuthenticated == NO)
        return;
    
    //2
    if ([playerList count] > 0) {
        [GKPlayer
		 loadPlayersForIdentifiers:
		 playerList
		 withCompletionHandler:
		 ^(NSArray* players, NSError* error) {
             
			 [self setLastError:error];
             
			 if ([_delegate respondsToSelector: @selector(onPlayerInfoReceived:)]) {
				 [_delegate onPlayerInfoReceived:players];
			 }
         }];
	}
}

-(void)sendScoreChallengeToPlayers:(NSArray*)players withScore:(int64_t)score message:(NSString*)message {
    //1
    GKScore *gkScore = [[GKScore alloc] initWithCategory:kGameTaps];
    gkScore.value = score;
    
    //2
    [gkScore issueChallengeToPlayers:players message:message];
}

-(void)showFriendsPickerViewControllerForScore:(int64_t)score {
    FriendsPickerViewController
	*friendsPickerViewController =
	[[FriendsPickerViewController alloc]
	 initWithScore:score];
    
    friendsPickerViewController.
	cancelButtonPressedBlock = ^() {
        [self dismissModalViewController];
    };
    
    friendsPickerViewController.
	challengeButtonPressedBlock = ^() {
        [self dismissModalViewController];
    };
    
    UINavigationController *navigationController =
	[[UINavigationController alloc]
	 initWithRootViewController:
	 friendsPickerViewController];
    
    [self presentViewController:navigationController];
}

-(void)loadAchievements {
    //1
    if (!userAuthenticated) {
        NSLog(@"Player not authenticated");
        return;
    }
	
    //2
    [GKAchievement loadAchievementsWithCompletionHandler:^(NSArray* loadedAchievements, NSError* error) {
        
        [self setLastError:error];
        
        if (_achievements == nil) {
            _achievements =
            [[NSMutableDictionary alloc] init];
        } else {
            [_achievements removeAllObjects];
        }
        
        for (GKAchievement* achievement in loadedAchievements) {
            achievement.showsCompletionBanner = YES;
            _achievements[achievement.identifier] = achievement;
        }
        if ([_delegate respondsToSelector:
             @selector(onAchievementsLoaded:)]) {
            [_delegate onAchievementsLoaded:_achievements];
        }
    }];
}

-(GKAchievement*)getAchievementByID:(NSString*)identifier {
    //1
    GKAchievement* achievement = _achievements[identifier];
    
    //2
    if (achievement == nil) {
        // Create a new achievement object
        achievement = [[GKAchievement alloc] initWithIdentifier:identifier];
        achievement.showsCompletionBanner = YES;
        _achievements[achievement.identifier] = achievement;
    }
    return achievement;
}

-(void)reportAchievementWithID:(NSString*)identifier percentComplete:(float)percent {
    //1
    if (!userAuthenticated) {
        NSLog(@"Player not authenticated");
        return;
    }
    
    //2
    GKAchievement* achievement = [self getAchievementByID:identifier];
    
    //3
    if (achievement != nil && achievement.percentComplete < percent) {
        
		achievement.percentComplete = percent;
        
		[achievement reportAchievementWithCompletionHandler:^(NSError* error) {
            
            [self setLastError:error];
            
            if ([_delegate respondsToSelector:@selector(onAchievementReported:)]) {
                [_delegate onAchievementReported:achievement];
            }
        }];
	}
}



#pragma mark Property setters
-(void) setLastError:(NSError*)error {
    _lastError = [error copy];
	if (_lastError) {
		NSLog(@"GameKitHelper ERROR: %@", [[_lastError userInfo] description]);
	}
}

#pragma mark UIViewController stuff
-(UIViewController*) getRootViewController {
	return [UIApplication sharedApplication].keyWindow.rootViewController;
}

-(void)presentViewController:(UIViewController*)vc {
	UIViewController* rootVC = [self getRootViewController];
	[rootVC presentViewController:vc animated:YES completion:nil];
}

-(void) dismissModalViewController {
    UIViewController* rootVC = [self getRootViewController];
    [rootVC dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark GKGameCenterControllerDelegate method
-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController {
    [self dismissModalViewController];
}
- (void) resetAchievements
{
    // Clear all locally saved achievement objects.
    _achievements = [[NSMutableDictionary alloc] init];
    // Clear all progress saved on Game Center
    [GKAchievement resetAchievementsWithCompletionHandler:^(NSError *error)
     {
         if (error != nil);
             // handle errors
             }];
}




#pragma mark Singleton stuff



@end
