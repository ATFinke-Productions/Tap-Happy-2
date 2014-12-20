//
//  SingleViewController.m
//  tap
//
//  Created by Andrew on 2/22/13.
//  Copyright (c) 2013 Andrew. All rights reserved.
//

#import "SingleViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface SingleViewController () 

@end

@implementation SingleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self buttonDesgin];
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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"SinglePlayer"];
    [defaults synchronize];
    player1ScoreLabel.font = [UIFont fontWithName:@"UbuntuTitling-Bold" size:60];
    _Started = false;
    _Started = true;
    [HUD hide:YES];
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.mode = MBProgressHUDModeDeterminate;
    HUD.labelText = @"Get Ready!";
    HUD.detailsLabelText = @"Tap as fast as you can!";
    [HUD showWhileExecuting:@selector(myStartTask) onTarget:self withObject:nil animated:YES];
    [self startGamewithTime:kGameTime];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    updateLabelClock = YES;
}
-(IBAction)tapButton:(id)sender{
    player1score++;
    player1ScoreLabel.text = [NSString stringWithFormat:@"%lld" ,player1score];
}

-(void)startGamewithTime:(int)seconds{
    
    self.Started = true;
    [tapButton setTitle: @"Tap" forState: UIControlStateNormal];
    timeLeft = seconds;
    [self populateLabelwithTime:timeLeft];
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
}


- (void)updateTimer:(NSTimer *)timer {
    if (updateLabelClock) {
    timeLeft -= 1 ;
    [self populateLabelwithTime:timeLeft];
    }
}
- (void)populateLabelwithTime:(int)seconds {
    int minutes = seconds / 60;
    seconds -= minutes * 60;
    
    timeLabel.text = [NSString stringWithFormat:@"%@%02dm:%02ds", (seconds<0?@"-":@""), minutes, seconds];
    if (minutes + seconds < 0) {
        [timer invalidate];
        [tapButton setTitle: @"Tap To Start" forState: UIControlStateNormal];
        timeLabel.text = @"00m:00s";
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:player1score forKey:@"lastScore"];
        [defaults synchronize];
        [self performSegueWithIdentifier: @"end1" sender: self];
    }
}

-(void)buttonDesgin{
    float radius = 20.0;

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