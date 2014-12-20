//
//  StatViewController.m
//  tap
//
//  Created by Andrew on 2/23/13.
//  Copyright (c) 2013 Andrew. All rights reserved.
//

#import "StatViewController.h"

@interface StatViewController ()

@end

@implementation StatViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    GCHelper *gameKitHelper = [GCHelper sharedInstance];
    gameKitHelper.delegate = self;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    int wins = [defaults integerForKey:@"totalWinsEver"];
    int loss = [defaults integerForKey:@"totalLossesEver"];
    
    MostTapsInOneGame.text = [NSString stringWithFormat:@"Most Taps In One Game: %d",[defaults integerForKey:@"bestTapsGame"]];
    TotalTaps.text = [NSString stringWithFormat:@"Total Taps: %d",[defaults integerForKey:@"totalTapsEver"]];
    Wins.text = [NSString stringWithFormat:@"Total Wins: %d",wins];
    Games.text = [NSString stringWithFormat:@"Total Games Played: %d",[defaults integerForKey:@"totalGames"]];
    Losses.text = [NSString stringWithFormat:@"Total Losses: %d",loss];

    float inGameTimePlaying = [defaults integerForKey:@"totalGames"] * 10;
    float tapEver = [defaults integerForKey:@"totalTapsEver"];
    tapsPerSecond.text = [NSString stringWithFormat:@"Taps Per Second: %f",tapEver/inGameTimePlaying];
    
    float ratio = (float)wins / (float)loss;
    if (ratio > 0.00001) {
        Ratio.text = [NSString stringWithFormat:@"Win / Loss Ratio: %f",ratio];
    }
    else {
        Ratio.text = @"Win / Loss Ratio: 0";
    }

    float timeInGame = [defaults floatForKey:@"timeInGame"];
    int hours,minutes, seconds;
    hours = timeInGame / 3600;
    minutes = (timeInGame - (hours*3600)) / 60;
    seconds = fmod(timeInGame, 60);
    TimeInGame.text = [NSString stringWithFormat:@"Time In Game: %02dh:%02dm:%02ds",hours,minutes,seconds];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 6.0) {
        sharebut.hidden = YES;
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(viewDidLoad)
                                                name:UIApplicationDidBecomeActiveNotification
                                              object:nil];
    
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
   
}

-(IBAction)share:(id)sender{
    UIActivityViewController *share = [[UIActivityViewController alloc]initWithActivityItems:@[[NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n",MostTapsInOneGame.text,TotalTaps.text,Games.text,tapsPerSecond.text, TimeInGame.text,@"---Multiplayer Stats---",Wins.text,Losses.text,Ratio.text]] applicationActivities:nil];
    [self presentViewController:share animated:YES completion:nil];
}

-(void)inviteReceived{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)showLeaderboards:(id)sender{
    GKLeaderboardViewController *leaderboardViewController = [[GKLeaderboardViewController alloc] init];
    leaderboardViewController.leaderboardDelegate = self;
    [self presentViewController:leaderboardViewController animated:YES completion:nil];
}
@end
