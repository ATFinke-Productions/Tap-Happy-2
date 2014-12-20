//
//  SingleViewController.h
//  tap
//
//  Created by Andrew on 2/22/13.
//  Copyright (c) 2013 Andrew. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleViewController : UIViewController {
    IBOutlet UILabel *timeLabel;
    IBOutlet UIButton *tapButton;
    IBOutlet UILabel *player1ScoreLabel;
    int64_t player1score;
    
    NSTimer * timer;
    int timeLeft;
    
    MBProgressHUD *HUD;
    BOOL updateLabelClock;
    
}

@property (nonatomic,assign) BOOL Started;
@property (weak, nonatomic) IBOutlet UIView *outerButtonView;
@property (weak, nonatomic) IBOutlet UIButton *ButtonView;
@property (weak, nonatomic) IBOutlet UIView *outerButtonView3;
@property (weak, nonatomic) IBOutlet UIButton *ButtonView3;
@property (weak, nonatomic) IBOutlet UIView *outerButtonView4;
@property (weak, nonatomic) IBOutlet UIButton *ButtonView4;
-(IBAction)tapButton:(id)sender;

-(void)populateLabelwithTime:(int)milliseconds;


@end
