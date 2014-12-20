//
//  ResultViewController.h
//  tap
//
//  Created by Andrew on 2/22/13.
//  Copyright (c) 2013 Andrew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import "HelperMethods.h"
#import <QuartzCore/QuartzCore.h>

@interface ResultViewController : UIViewController <GKLeaderboardViewControllerDelegate>{
    
    IBOutlet UILabel *resultLabel;
    IBOutlet UILabel *gameCountLabel;
    IBOutlet UILabel *totalCountLabel;
    IBOutlet UILabel *totalWinsLabel;
    IBOutlet UILabel *titleLabel;
    
    IBOutlet UIButton *lead1;
    IBOutlet UIButton *lead2;
    IBOutlet UIButton *lead3;
    IBOutlet UIButton *lead4;
    
    IBOutlet UIImageView *bar;
    IBOutlet UIView *LeaderboardView;
    
    BOOL areButtonsVisible;
    int pushUpDown;
}

-(IBAction)toggleLeaderboards:(id)sender;
-(IBAction)viewLeaderboardWins:(id)sender;
-(IBAction)viewLeaderboardCount:(id)sender;
-(IBAction)viewLeaderboardTotal:(id)sender;
-(IBAction)challenge:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *outerButtonView;
@property (weak, nonatomic) IBOutlet UIButton *ButtonView;
@property (weak, nonatomic) IBOutlet UIView *outerButtonView1;
@property (weak, nonatomic) IBOutlet UIButton *ButtonView1;
@property (weak, nonatomic) IBOutlet UIView *outerButtonView2;
@property (weak, nonatomic) IBOutlet UIButton *ButtonView2;
@property (weak, nonatomic) IBOutlet UIView *outerButtonView3;
@property (weak, nonatomic) IBOutlet UIButton *ButtonView3;

@end
