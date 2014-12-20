//
//  ResultViewController.m
//  tap
//
//  Created by Andrew on 2/22/13.
//  Copyright (c) 2013 Andrew. All rights reserved.
//

#import "ResultViewController.h"
#import "MultiViewController.h"
@interface ResultViewController () <GCHelperDelegate>

@end

@implementation ResultViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)inviteReceived{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)viewLeaderboardWins:(id)sender{
    GKLeaderboardViewController *leaderboardViewController = [[GKLeaderboardViewController alloc] init];
    leaderboardViewController.leaderboardDelegate = self;
    leaderboardViewController.category = kTotalWins;
    [self presentViewController:leaderboardViewController animated:YES completion:nil];
}
-(IBAction)viewLeaderboardCount:(id)sender{
    GKLeaderboardViewController *leaderboardViewController = [[GKLeaderboardViewController alloc] init];
    leaderboardViewController.leaderboardDelegate = self;
    leaderboardViewController.category = kGameTaps;
    [self presentViewController:leaderboardViewController animated:YES completion:nil];
}
-(IBAction)viewLeaderboardTotal:(id)sender{
    GKLeaderboardViewController *leaderboardViewController = [[GKLeaderboardViewController alloc] init];
    leaderboardViewController.leaderboardDelegate = self;
    leaderboardViewController.category = kTotalTaps;
    [self presentViewController:leaderboardViewController animated:YES completion:nil];
}

-(void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}


-(IBAction)toggleLeaderboards:(id)sender{
    if (areButtonsVisible == NO) {
        [UIView beginAnimations:@"off" context:NULL];
        [UIView setAnimationDuration:1.0];
        bar.frame = CGRectOffset(bar.frame, 0, -pushUpDown);
        titleLabel.frame = CGRectOffset(titleLabel.frame, 0, -pushUpDown);
        gameCountLabel.frame = CGRectOffset(gameCountLabel.frame, 0, -pushUpDown);
        totalCountLabel.frame = CGRectOffset(totalCountLabel.frame, 0, -pushUpDown);
        totalWinsLabel.frame = CGRectOffset(totalWinsLabel.frame, 0, -pushUpDown);
        lead1.frame = CGRectOffset(lead1.frame, 0, -pushUpDown);
        lead2.frame = CGRectOffset(lead2.frame, 0, -pushUpDown);
        lead3.frame = CGRectOffset(lead3.frame, 0, -pushUpDown);
        lead4.frame = CGRectOffset(lead4.frame, 0, -pushUpDown);
        LeaderboardView.frame = CGRectOffset(LeaderboardView.frame, 0, -pushUpDown);
        [UIView commitAnimations];
        areButtonsVisible = YES;
    }
    else {
        [UIView beginAnimations:@"on" context:NULL];
        [UIView setAnimationDuration:1.0];
        bar.frame = CGRectOffset(bar.frame, 0, pushUpDown);
        titleLabel.frame = CGRectOffset(titleLabel.frame, 0, pushUpDown);
        gameCountLabel.frame = CGRectOffset(gameCountLabel.frame, 0, pushUpDown);
        totalCountLabel.frame = CGRectOffset(totalCountLabel.frame, 0, pushUpDown);
        totalWinsLabel.frame = CGRectOffset(totalWinsLabel.frame, 0, pushUpDown);
        lead1.frame = CGRectOffset(lead1.frame, 0, pushUpDown);
        lead2.frame = CGRectOffset(lead2.frame, 0, pushUpDown);
        lead3.frame = CGRectOffset(lead3.frame, 0, pushUpDown);
        lead4.frame = CGRectOffset(lead4.frame, 0, pushUpDown);
        LeaderboardView.frame = CGRectOffset(LeaderboardView.frame, 0, pushUpDown);
        [UIView commitAnimations];
        areButtonsVisible = NO;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self buttonDesgin];
    if ([[[UIDevice currentDevice] systemVersion]floatValue] < 6.0) {
        lead4.hidden = YES;
    }
    GCHelper *gameKitHelper = [GCHelper sharedInstance];
    gameKitHelper.delegate = self;
    
    pushUpDown = 240;

    areButtonsVisible = NO;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:@"SinglePlayer"]) {
        [self singlePlayerDone];
    }
    else {
        [self multiplayerDone];
    }
    [defaults setInteger:[defaults integerForKey:@"totalGames"]+1 forKey:@"totalGames"];
    [defaults synchronize];
    
    bar.frame = CGRectOffset(bar.frame, 0, pushUpDown);
    titleLabel.frame = CGRectOffset(titleLabel.frame, 0, pushUpDown);
    gameCountLabel.frame = CGRectOffset(gameCountLabel.frame, 0, pushUpDown);
    totalCountLabel.frame = CGRectOffset(totalCountLabel.frame, 0, pushUpDown);
    totalWinsLabel.frame = CGRectOffset(totalWinsLabel.frame, 0, pushUpDown);
    lead1.frame = CGRectOffset(lead1.frame, 0, pushUpDown);
    lead2.frame = CGRectOffset(lead2.frame, 0, pushUpDown);
    lead3.frame = CGRectOffset(lead3.frame, 0, pushUpDown);
    lead4.frame = CGRectOffset(lead4.frame, 0, pushUpDown);
    LeaderboardView.frame = CGRectOffset(LeaderboardView.frame, 0, pushUpDown);

    // Do any additional setup after loading the view from its nib.
}

-(void)singlePlayerDone{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:@"Playing"];
    if ([defaults integerForKey:@"lastScore"] > [defaults integerForKey:@"bestTapsGame"]) {
        [defaults setInteger:[defaults integerForKey:@"lastScore"] forKey:@"bestTapsGame"];
    }
    
    int totalTaps = [defaults integerForKey:@"totalTapsEver"] + [defaults integerForKey:@"lastScore"];
    [defaults setInteger:totalTaps forKey:@"totalTapsEver"];
    
    [defaults synchronize];
    
    for (int taps = 0; taps <= [defaults integerForKey:@"lastScore"]; taps++) {

    }
    resultLabel.text = [NSString stringWithFormat:@"You tapped %ld times before time ran out", (long)[defaults integerForKey:@"lastScore"]];
    
    gameCountLabel.text = [NSString stringWithFormat:@"Your Record Is %ld Taps", (long)[defaults integerForKey:@"bestTapsGame"]];
    totalCountLabel.text = [NSString stringWithFormat:@"Your Total Is %ld Taps", (long)[defaults integerForKey:@"totalTapsEver"]];
    
    totalWinsLabel.text = [NSString stringWithFormat:@"Your Record Is %ld W, %ld L", (long)[defaults integerForKey:@"totalWinsEver"],(long)[defaults integerForKey:@"totalLossesEver"]];
    [self gameCenterSubmit];
}
-(void)multiplayerDone{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults integerForKey:@"player1score"] > [defaults integerForKey:@"player2score"]) {
        [defaults setValue:[NSString stringWithFormat:@"%d",[defaults integerForKey:@"player1score"]-[defaults integerForKey:@"player2score"]] forKey:@"gameScoreDifference"];
        if ([defaults boolForKey:@"isPlayer1"]) {
            [defaults setValue:@"beat" forKey:@"resultText"];
            [defaults setInteger:[defaults integerForKey:@"player1score"] forKey:@"lastScore"];
        } else {
            [defaults setValue:@"lost to" forKey:@"resultText"];
            [defaults setInteger:[defaults integerForKey:@"player2score"] forKey:@"lastScore"];
        }
    } else if ([defaults integerForKey:@"player1score"] < [defaults integerForKey:@"player2score"]) {
        [defaults setValue:[NSString stringWithFormat:@"%d",[defaults integerForKey:@"player2score"]-[defaults integerForKey:@"player1score"]] forKey:@"gameScoreDifference"];
        if ([defaults boolForKey:@"isPlayer1"]) {
            [defaults setValue:@"lost to" forKey:@"resultText"];
            [defaults setInteger:[defaults integerForKey:@"player1score"] forKey:@"lastScore"];
        } else {
            [defaults setValue:@"beat" forKey:@"resultText"];
            [defaults setInteger:[defaults integerForKey:@"player2score"] forKey:@"lastScore"];
        }
    }
    else {
        [defaults setValue:@"having the same ammount of" forKey:@"gameScoreDifference"];
        [defaults setValue:@"tied with" forKey:@"resultText"];
        if ([defaults boolForKey:@"isPlayer1"]) {
            [defaults setInteger:[defaults integerForKey:@"player1score"] forKey:@"lastScore"];
        } else {
            [defaults setInteger:[defaults integerForKey:@"player2score"] forKey:@"lastScore"];
        }
    }
    [defaults synchronize];
    
    
  
    [defaults setBool:NO forKey:@"Playing"];
    if ([defaults integerForKey:@"lastScore"] > [defaults integerForKey:@"bestTapsGame"]) {
        [defaults setInteger:[defaults integerForKey:@"lastScore"] forKey:@"bestTapsGame"];
    }
    
    int totalTaps = [defaults integerForKey:@"totalTapsEver"] + [defaults integerForKey:@"lastScore"];
    [defaults setInteger:totalTaps forKey:@"totalTapsEver"];
    
    [defaults synchronize];
    
    
    
    
    if ([defaults boolForKey:@"Disconnected"]) {
        
        if ([defaults boolForKey:@"ForceDisconnected"]) {
            int totalLosses = [defaults integerForKey:@"totalLossesEver"] + 1;
            [defaults setInteger:totalLosses forKey:@"totalLossesEver"];
            resultLabel.text = @"You disconnected during the match. Game counted as a loss.";
            [defaults setBool:NO forKey:@"ForceDisconnected"];
        }
        else {
            resultLabel.text = @"Opponent disconnected. Match counted as a win.";
            [defaults setBool:NO forKey:@"Disconnected"];
            int totalWins = [defaults integerForKey:@"totalWinsEver"] + 1;
            [defaults setInteger:totalWins forKey:@"totalWinsEver"];
            [defaults synchronize];
        }
    }
    else {
        if ([[defaults valueForKey:@"gameScoreDifference"]intValue] ==1) {
            resultLabel.text = [NSString stringWithFormat:@"%@ %@ %@ by %@ tap", [defaults valueForKey:@"UserName"],[defaults valueForKey:@"resultText"], [defaults valueForKey:@"P2Name"], [defaults valueForKey:@"gameScoreDifference"]];
        }
        else {
            resultLabel.text = [NSString stringWithFormat:@"%@ %@ %@ by %@ taps", [defaults valueForKey:@"UserName"],[defaults valueForKey:@"resultText"], [defaults valueForKey:@"P2Name"], [defaults valueForKey:@"gameScoreDifference"]];
        }
        
        if ([[defaults valueForKey:@"resultText"] isEqual:@"beat"]) {
            int totalWins = [defaults integerForKey:@"totalWinsEver"] + 1;
            [defaults setInteger:totalWins forKey:@"totalWinsEver"];
        }
        
        else {
            int totalLosses = [defaults integerForKey:@"totalLossesEver"] + 1;
            [defaults setInteger:totalLosses forKey:@"totalLossesEver"];
        }
        
        [defaults synchronize];
        
    }
    
    
    
    gameCountLabel.text = [NSString stringWithFormat:@"Your Record Is %ld Taps", (long)[defaults integerForKey:@"bestTapsGame"]];
    totalCountLabel.text = [NSString stringWithFormat:@"Your Total Is %ld Taps", (long)[defaults integerForKey:@"totalTapsEver"]];
    
    totalWinsLabel.text = [NSString stringWithFormat:@"Your Record Is %ld W, %ld L", (long)[defaults integerForKey:@"totalWinsEver"],(long)[defaults integerForKey:@"totalLossesEver"]];
    
    [self gameCenterSubmit];
    for (int taps = 0; taps <= [defaults integerForKey:@"lastScore"]; taps++) {

    }
}

-(void)gameCenterSubmit {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [[GCHelper sharedInstance]submitScore:(int64_t)[defaults integerForKey:@"totalTapsEver"] category:kTotalTaps];
    [[GCHelper sharedInstance]submitScore:(int64_t)[defaults integerForKey:@"totalWinsEver"] category:kTotalWins];
    [[GCHelper sharedInstance]submitScore:(int64_t)[defaults integerForKey:@"bestTapsGame"] category:kGameTaps];
 
    [HelperMethods reportAchievementsForWins:[defaults integerForKey:@"totalWinsEver"]];
    [HelperMethods reportAchievementsForTaps:[defaults integerForKey:@"bestTapsGame"]];
    [HelperMethods reportAchievementsForLosses:[defaults integerForKey:@"totalLossesEver"]];
    [HelperMethods reportAchievementsForTotal:[defaults integerForKey:@"totalTapsEver"]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)challenge:(id)sender{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [[GCHelper sharedInstance] showFriendsPickerViewControllerForScore:[defaults integerForKey:@"lastScore"]];
}

-(void)buttonDesgin{
    float radius = 20.0;
    
    self.ButtonView.hidden = NO;
    [self.ButtonView.layer setMasksToBounds:YES];
    [self.ButtonView.layer setBorderColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.8].CGColor];
    [self.ButtonView.layer setBorderWidth:3.0];
    [self.ButtonView.layer setCornerRadius:radius];
    
    [self.outerButtonView.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.outerButtonView.layer setShadowOffset:CGSizeMake(0, 3)];
    [self.outerButtonView.layer setShadowOpacity:0.3];
    [self.outerButtonView.layer setShadowRadius:3.0];
    [self.outerButtonView.layer setCornerRadius:radius];
    
    self.ButtonView1.hidden = NO;
    [self.ButtonView1.layer setMasksToBounds:YES];
    [self.ButtonView1.layer setBorderColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.8].CGColor];
    [self.ButtonView1.layer setBorderWidth:3.0];
    [self.ButtonView1.layer setCornerRadius:radius];
    
    [self.outerButtonView1.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.outerButtonView1.layer setShadowOffset:CGSizeMake(0, 3)];
    [self.outerButtonView1.layer setShadowOpacity:0.3];
    [self.outerButtonView1.layer setShadowRadius:3.0];
    [self.outerButtonView1.layer setCornerRadius:radius];
    
    self.ButtonView2.hidden = NO;
    [self.ButtonView2.layer setMasksToBounds:YES];
    [self.ButtonView2.layer setBorderColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.8].CGColor];
    [self.ButtonView2.layer setBorderWidth:3.0];
    [self.ButtonView2.layer setCornerRadius:radius];
    
    [self.outerButtonView2.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.outerButtonView2.layer setShadowOffset:CGSizeMake(0, 3)];
    [self.outerButtonView2.layer setShadowOpacity:0.3];
    [self.outerButtonView2.layer setShadowRadius:3.0];
    [self.outerButtonView2.layer setCornerRadius:radius];
    
    self.ButtonView3.hidden = NO;
    [self.ButtonView3.layer setMasksToBounds:YES];
    [self.ButtonView3.layer setBorderColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.8].CGColor];
    [self.ButtonView3.layer setBorderWidth:3.0];
    [self.ButtonView3.layer setCornerRadius:radius];
    
    [self.outerButtonView3.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.outerButtonView3.layer setShadowOffset:CGSizeMake(0, 3)];
    [self.outerButtonView3.layer setShadowOpacity:0.3];
    [self.outerButtonView3.layer setShadowRadius:3.0];
    [self.outerButtonView3.layer setCornerRadius:radius];
    
}
@end
