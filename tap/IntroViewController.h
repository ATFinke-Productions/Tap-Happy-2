//
//  IntroViewController.h
//  tap
//
//  Created by Andrew on 2/22/13.
//  Copyright (c) 2013 Andrew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import <QuartzCore/QuartzCore.h>

@interface IntroViewController : UIViewController <UIActionSheetDelegate,GKLeaderboardViewControllerDelegate,GKAchievementViewControllerDelegate> {
    BOOL isCompatible;
    MBProgressHUD *HUD;
    IBOutlet UILabel *menuLabel;
    IBOutlet UILabel *pro;
    IBOutlet UILabel *pro1;
    IBOutlet UILabel *pro2;
    IBOutlet UIButton *but1;
    IBOutlet UIButton *but2;
    IBOutlet UIButton *but3;
    IBOutlet UIButton *but4;
    IBOutlet UIButton *but7;
    IBOutlet UINavigationBar *but5;
    IBOutlet UIButton *but6;
    IBOutlet UILabel *buildLabel;
    
    NSTimer *timer;
    int pushUpDown;
    
}
-(IBAction)challenge:(id)sender;
-(IBAction)email:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *outerButtonView;
@property (weak, nonatomic) IBOutlet UIButton *ButtonView;
@property (weak, nonatomic) IBOutlet UIView *outerButtonView1;
@property (weak, nonatomic) IBOutlet UIButton *ButtonView1;
@property (weak, nonatomic) IBOutlet UIView *outerButtonView2;
@property (weak, nonatomic) IBOutlet UIButton *ButtonView2;
@property (weak, nonatomic) IBOutlet UIView *outerButtonView3;
@property (weak, nonatomic) IBOutlet UIButton *ButtonView3;
@property (weak, nonatomic) IBOutlet UIView *outerButtonView4;
@property (weak, nonatomic) IBOutlet UIButton *ButtonView4;

@end
