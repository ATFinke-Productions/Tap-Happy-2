//
//  MainViewController.m
//  tap
//
//  Created by Andrew on 2/21/13.
//  Copyright (c) 2013 Andrew. All rights reserved.
//

#import "MultiViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface MultiViewController ()

@end

@implementation MultiViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self buttonDesgin];
    GCHelper *gameKitHelper = [GCHelper sharedInstance];
    gameKitHelper.delegate = self;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:@"SinglePlayer"];
    [defaults synchronize];
    _Started = false;
    ourRandom = arc4random();
    [self setGameState:kGameStateWaitingForMatch];
    receivedRandom = NO;
    
    isPlayer1 = YES;
    
    ourRandom = arc4random();
    [self setGameState:kGameStateWaitingForMatch];
    _Started = true;
    
    
    float radius = 95.0;
    
    self.ButtonView.hidden = NO;
    [self.ButtonView.layer setMasksToBounds:YES];
    [self.ButtonView.layer setBorderColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.8].CGColor];
    [self.ButtonView.layer setBorderWidth:8.0];
    [self.ButtonView.layer setCornerRadius:radius];
    
    [self.outerButtonView.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.outerButtonView.layer setShadowOffset:CGSizeMake(0, 3)];
    [self.outerButtonView.layer setShadowOpacity:0.3];
    [self.outerButtonView.layer setShadowRadius:3.0];
    [self.outerButtonView.layer setCornerRadius:radius];
    
    player1ScoreLabel.font = [UIFont fontWithName:@"UbuntuTitling-Bold" size:20];
    player1label.font = [UIFont fontWithName:@"UbuntuTitling-Bold" size:20];
    player2ScoreLabel.font = [UIFont fontWithName:@"UbuntuTitling-Bold" size:20];
    player2label.font = [UIFont fontWithName:@"UbuntuTitling-Bold" size:20];
    
    
    [HUD show:YES];
    
    [self debugEnabler];
    
	// Do any additional setup after loading the view, typically from a nib.
}
-(void)debugEnabler{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults boolForKey:@"debugModeEnabled"]) {
        debugLabel.hidden = NO;
        percentLabel.hidden = NO;
    }
}
-(void)viewDidAppear:(BOOL)animated{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:@"MatchmakerCancelled"]) {
        [HUD hide:YES];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    if (!hasPresentedGC){
        hasPresentedGC = YES;
        [[GCHelper sharedInstance] findMatchWithMinPlayers:2 maxPlayers:2 viewController:self delegate:self];
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.delegate = self;
        HUD.labelText = @"Loading";
        HUD.square = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)tapButton:(id)sender{
    
    if (gameState != kGameStateActive) return;
    
    [self sendMove];
    
    if (isPlayer1) {
        player1score++;
        player1ScoreLabel.text = [NSString stringWithFormat:@"%lld" ,player1score];
    } else {
        player2score++;
        player2ScoreLabel.text = [NSString stringWithFormat:@"%lld" ,player2score];
    }
    [self cycleThroughTap];
}

-(void)cycleThroughTap{
    tapCount++;
    if (tapCount == 1) {
        [tapButton setTitle: @"Tap" forState: UIControlStateNormal];
    }
    else if (tapCount ==2){
        [tapButton setTitle: @"Tap Tap" forState: UIControlStateNormal];
    }
    else if (tapCount == 3){
        [tapButton setTitle: @"Tap Tap Tap" forState: UIControlStateNormal];
    }
    else if (tapCount == 4){
        [tapButton setTitle: @"Tap Tap Tap Tap" forState: UIControlStateNormal];
    }
    else if (tapCount == 5){
        [tapButton setTitle: @"Tap Tap Tap Tap Tap" forState: UIControlStateNormal];
        tapCount = 0;
    }
}


-(void)startGamewithTime:(int)seconds{

    self.Started = true;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"CanDisconnect"];
    [defaults synchronize];
    timeLeft = seconds;
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
    scoretimer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(updateScore) userInfo:nil repeats:YES];
    [self populateLabelwithTime:timeLeft];
}

-(void)updateScore{
    if (!isPlayer1) {
        player1ScoreLabel.text = [NSString stringWithFormat:@"%lld" ,player1score];
    } else {
        player2ScoreLabel.text = [NSString stringWithFormat:@"%lld" ,player2score];
    }
}
- (void)updateTimer:(NSTimer *)timer {
    if (updateLabelClock) {
    timeLeft -= 1 ;
    [self populateLabelwithTime:timeLeft];
    if (timeLeft < 3) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:NO forKey:@"CanDisconnect"];
        [defaults synchronize];
    }
    }
}
-(void)updateStats{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:player2score forKey:@"player2score"];
    [defaults setInteger:player1score forKey:@"player1score"];
    [defaults synchronize];
}
- (void)populateLabelwithTime:(int)seconds {
    int minutes = seconds / 60;
    seconds -= minutes * 60;
    
    timeLabel.text = [NSString stringWithFormat:@"%@%02dm:%02ds", (seconds<0?@"-":@""), minutes, seconds];
    
    [self updateStats];
    
    if (minutes + seconds < 0) {
        NSLog(@"P1:%lld  P2 %lld",player1score,player2score);
        [timer invalidate];
        timeLabel.text = @"00m:00s";
        tapButton.enabled = NO;
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        HUD.mode = MBProgressHUDModeDeterminate;
        HUD.labelText = @"Done!";
        HUD.detailsLabelText = @"Results Loading...";
        [HUD showWhileExecuting:@selector(myProgressTask) onTarget:self withObject:nil animated:YES];
        [UIView beginAnimations:@"off" context:NULL];
        [UIView setAnimationDuration:4.0];
        int pushUpDown = -150;
        self.ButtonView2.frame = CGRectOffset(self.ButtonView2.frame, 0, -pushUpDown);
        self.ButtonView3.frame = CGRectOffset(self.ButtonView3.frame, 0, -pushUpDown);
        bar1.frame = CGRectOffset(bar1.frame, 0, -pushUpDown);
        bar2.frame = CGRectOffset(bar2.frame, 0, -pushUpDown);
        player1label.frame = CGRectOffset(player1label.frame, 0, -pushUpDown);
        player2label.frame = CGRectOffset(player2label.frame, 0, -pushUpDown);
        player1ScoreLabel.frame = CGRectOffset(player1ScoreLabel.frame, 0, -pushUpDown);
        player2ScoreLabel.frame = CGRectOffset(player2ScoreLabel.frame, 0, -pushUpDown);
        [UIView commitAnimations];
    }
}


// Add new methods to bottom of file
#pragma mark GCHelperDelegate



- (void)endScene:(EndReason)endReason {
    NSLog(@"P1:%lld  P2 %lld",player1score,player2score);
    _Started = false;
    
    if (gameState == kGameStateDone) return;
    [self setGameState:kGameStateDone];

    
    /*if (endReason == kEndReasonWin) {
        [self presentViewController:vc animated:YES completion:nil];
        
    } else if (endReason == kEndReasonLose) {
        [self presentViewController:vc animated:YES completion:nil];
    }*/
    
    if (isPlayer1) {
        if (endReason == kEndReasonWin) {
            [self sendGameOver:true];
        } else if (endReason == kEndReasonLose) {
            [self sendGameOver:false];
        }
    }
    [HUD hide:YES];
    [self updateStats];
    [self performSegueWithIdentifier: @"end" sender: self];
}

-(void)myProgressTask {
	// This just increases the progress indicator in a loop
	float progress = 0.0f;
	while (progress < 1.3f) {
		progress += 0.01f;
		HUD.progress = progress;
		usleep(50000);
        [self updateStats];
	}
    if (!isPlayer1) return;
    
    if (player1score > player2score) {
        if (isPlayer1) {
            [self endScene:kEndReasonWin];
        } else {
            [self endScene:kEndReasonLose];
        }
    } else if (player1score < player2score) {
        if (isPlayer1) {
            [self endScene:kEndReasonLose];
        } else {
            [self endScene:kEndReasonWin];
        }
    }
    else {
        [self endScene:kEndReasonWin];
    }
}


- (void)matchStarted {
    NSLog(@"Match started");
    if (receivedRandom) {
        [self setGameState:kGameStateWaitingForStart];
    } else {
        [self setGameState:kGameStateWaitingForRandomNumber];
    }
    [self sendRandomNumber];
    [self tryStartGame];
}

- (void)matchEnded {
    [HUD hide:YES];
    NSLog(@"Match ended");
    [timer invalidate];
    [scoretimer invalidate];
    [[GCHelper sharedInstance].match disconnect];
    [GCHelper sharedInstance].match = nil;
    [self endScene:kEndReasonDisconnect];
}

- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID {
    
    packageRecive++;
    debugLabel.text = [NSString stringWithFormat:@"%@\nPackages Sent: %d Recived: %d",matchStatus,packageSent,packageRecive];
    // Store away other player ID for later
    if (otherPlayerID == nil) {
        otherPlayerID = playerID;
    }
    
    Message *message = (Message *) [data bytes];
    if (message->messageType == kMessageTypeRandomNumber) {
        
        MessageRandomNumber * messageInit = (MessageRandomNumber *) [data bytes];
        percentLabel.text = [NSString stringWithFormat:@"R#:%ud,%ud", messageInit->randomNumber, ourRandom];
        bool tie = false;
        
        if (messageInit->randomNumber == ourRandom) {
            NSLog(@"TIE!");
            tie = true;
            ourRandom = arc4random();
            [self sendRandomNumber];
        } else if (ourRandom > messageInit->randomNumber) {
            NSLog(@"We are player 1");
            isPlayer1 = YES;
            
        } else {
            NSLog(@"We are player 2");
            isPlayer1 = NO;
        }
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:isPlayer1 forKey:@"isPlayer1"];
        [defaults synchronize];
        
        if (!tie) {
            receivedRandom = YES;
            if (gameState == kGameStateWaitingForRandomNumber) {
                [self setGameState:kGameStateWaitingForStart];
            }
            [self tryStartGame];
        }
        
    } else if (message->messageType == kMessageTypeGameBegin) {
        
        [self setGameState:kGameStateActive];
        [self setupStringsWithOtherPlayerId:playerID];
        
    } else if (message->messageType == kMessageTypeMove) {
        
        if (!isPlayer1) {
            player1score++;
            player1ScoreLabel.text = [NSString stringWithFormat:@"%lld" ,player1score];
        } else {
            player2score++;
            player2ScoreLabel.text = [NSString stringWithFormat:@"%lld" ,player2score];
        }
        
        
        
    } else if (message->messageType == kMessageTypeGameOver) {
        
        MessageGameOver * messageGameOver = (MessageGameOver *) [data bytes];
        NSLog(@"Received game over with player 1 won: %d", messageGameOver->player1Won);
        
        if (messageGameOver->player1Won) {
            [self endScene:kEndReasonLose];
        } else {
            [self endScene:kEndReasonWin];
        }
        
    }
}
- (void)tryStartGame {
    
    if (isPlayer1 && gameState == kGameStateWaitingForStart) {
        [self setGameState:kGameStateActive];
        [self sendGameBegin];
        [self setupStringsWithOtherPlayerId:otherPlayerID];
    }
    
}
- (void)setGameState:(GameState)state {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    gameState = state;
    
    if (gameState == kGameStateWaitingForMatch) {
        HUD.detailsLabelText = @"Status: Waiting for match";
        matchStatus= @"Status: Waiting for match";
        [defaults setBool:NO forKey:@"Playing"];
    } else if (gameState == kGameStateWaitingForRandomNumber) {
        HUD.detailsLabelText = @"Status: Waiting for rand #";
        matchStatus= @"Status: Waiting for rand #";
        [defaults setBool:YES forKey:@"Playing"];
    } else if (gameState == kGameStateWaitingForStart) {
        HUD.detailsLabelText = @"Status: Waiting for start";
        matchStatus= @"Status: Waiting for start";
        [defaults setBool:YES forKey:@"Playing"];
    } else if (gameState == kGameStateActive) {
        [self startGamewithTime:kGameTime];
        _Started = true;
        [HUD hide:YES];
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.mode = MBProgressHUDModeDeterminate;
        HUD.labelText = @"Get Ready!";
        HUD.detailsLabelText = @"Tap as fast as you can!";
        [HUD showWhileExecuting:@selector(myStartTask) onTarget:self withObject:nil animated:YES];
        [defaults setBool:YES forKey:@"Playing"];
        matchStatus = @"Status: Active";
    } else if (gameState == kGameStateDone) {
        matchStatus = @"Status: Done";
        [defaults setBool:NO forKey:@"Playing"];
    }
    [defaults synchronize];
    debugLabel.text = [NSString stringWithFormat:@"%@\nPackages Sent: %d Recived: %d",matchStatus,packageSent,packageRecive];
}

-(void)myStartTask {
	// This just increases the progress indicator in a loop
	float progress = 0.0f;
	while (progress < 1.0f) {
		progress += 0.015f;
		HUD.progress = progress;
		usleep(50000);
	}
    [HUD hide:YES];
    updateLabelClock = true;
}


- (void)sendData:(NSData *)data {
    NSError *error;
    BOOL success = [[GCHelper sharedInstance].match sendDataToAllPlayers:data withDataMode:GKMatchSendDataReliable error:&error];
    if (!success) {
        NSLog(@"Error sending init packet");
        [self matchEnded];
    }
    packageSent++;
    debugLabel.text = [NSString stringWithFormat:@"%@\nPackages Sent: %d Recived: %d",matchStatus,packageSent,packageRecive];
}

- (void)sendRandomNumber {
    
    MessageRandomNumber message;
    message.message.messageType = kMessageTypeRandomNumber;
    message.randomNumber = ourRandom;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageRandomNumber)];
    [self sendData:data];
}

- (void)sendGameBegin {
    
    MessageGameBegin message;
    message.message.messageType = kMessageTypeGameBegin;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageGameBegin)];
    [self sendData:data];
    
}

- (void)sendMove {
    
    MessageMove message;
    message.message.messageType = kMessageTypeMove;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageMove)];
    [self sendData:data];
    
}

- (void)sendGameOver:(BOOL)player1Won {
    
    MessageGameOver message;
    message.message.messageType = kMessageTypeGameOver;
    message.player1Won = player1Won;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageGameOver)];
    [self sendData:data];
    
}

- (void)setupStringsWithOtherPlayerId:(NSString *)playerID {
    
    GKPlayer *player = [[GCHelper sharedInstance].playersDict objectForKey:playerID];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (isPlayer1) {
        
        player1label.text = [NSString stringWithFormat:@"%@",[GKLocalPlayer localPlayer].alias];
        [defaults setValue:[NSString stringWithFormat:@"%@ (You)",[GKLocalPlayer localPlayer].alias] forKey:@"UserName"];
        
        player2label.text = [NSString stringWithFormat:@"%@",player.alias];
        [defaults setValue:[NSString stringWithFormat:@"%@",player.alias] forKey:@"P2Name"];
        
    } else {
        
        player2label.text = [NSString stringWithFormat:@"%@",[GKLocalPlayer localPlayer].alias];
        [defaults setValue:[NSString stringWithFormat:@"%@ (You)",[GKLocalPlayer localPlayer].alias] forKey:@"UserName"];
                        
        player1label.text = [NSString stringWithFormat:@"%@",player.alias];
        [defaults setValue:[NSString stringWithFormat:@"%@",player.alias] forKey:@"P2Name"];
        
    }
    [defaults synchronize];
}

-(void)buttonDesgin{
    float radius = 20.0;
    
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
    
    self.ButtonView4.hidden = NO;
    [self.ButtonView4.layer setMasksToBounds:YES];
    [self.ButtonView4.layer setBorderColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.8].CGColor];
    [self.ButtonView4.layer setBorderWidth:3.0];
    [self.ButtonView4.layer setCornerRadius:radius];
    
    [self.outerButtonView4.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.outerButtonView4.layer setShadowOffset:CGSizeMake(0, 3)];
    [self.outerButtonView4.layer setShadowOpacity:0.3];
    [self.outerButtonView4.layer setShadowRadius:3.0];
    [self.outerButtonView4.layer setCornerRadius:radius];
}
                        
@end