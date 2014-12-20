//
//  StatViewController.h
//  tap
//
//  Created by Andrew on 2/23/13.
//  Copyright (c) 2013 Andrew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import <QuartzCore/QuartzCore.h>
@interface StatViewController : UIViewController <GCHelperDelegate,GKLeaderboardViewControllerDelegate> {
    IBOutlet UILabel *MostTapsInOneGame;
    IBOutlet UILabel *TotalTaps;
    IBOutlet UILabel *TimeInGame;
    IBOutlet UILabel *Wins;
    IBOutlet UILabel *Games;
    IBOutlet UILabel *Losses;
    IBOutlet UILabel *Ratio;
    IBOutlet UILabel *tapsPerSecond;
    IBOutlet UIButton *sharebut;
}

@property (weak, nonatomic) IBOutlet UIView *outerButtonView;
@property (weak, nonatomic) IBOutlet UIButton *ButtonView;
-(IBAction)showLeaderboards:(id)sender;
-(IBAction)share:(id)sender;

@end
