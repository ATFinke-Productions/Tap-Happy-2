//
//  MainViewController.h
//  tap
//
//  Created by Andrew on 2/21/13.
//  Copyright (c) 2013 Andrew. All rights reserved.
//

typedef enum {
    kMessageTypeRandomNumber = 0,
    kMessageTypeGameBegin,
    kMessageTypeMove,
    kMessageTypeGameOver
} MessageType;

typedef struct {
    MessageType messageType;
} Message;

typedef struct {
    Message message;
    uint32_t randomNumber;
} MessageRandomNumber;

typedef struct {
    Message message;
} MessageGameBegin;

typedef struct {
    Message message;
} MessageMove;

typedef struct {
    Message message;
    BOOL player1Won;
} MessageGameOver;

typedef enum {
    kEndReasonWin,
    kEndReasonLose,
    kEndReasonDisconnect
} EndReason;

typedef enum {
    kGameStateWaitingForMatch = 0,
    kGameStateWaitingForRandomNumber,
    kGameStateWaitingForStart,
    kGameStateActive,
    kGameStateDone
} GameState;

@interface MultiViewController : UIViewController <GCHelperDelegate,MBProgressHUDDelegate>{
    
    IBOutlet UILabel *timeLabel;
    IBOutlet UILabel *debugLabel;
    IBOutlet UILabel *percentLabel;
    IBOutlet UIButton *tapButton;
    NSString *matchStatus;
    int tapCount;
    
    IBOutlet UILabel *player1label;
    IBOutlet UILabel *player2label;
    IBOutlet UILabel *player1ScoreLabel;
    IBOutlet UILabel *player2ScoreLabel;
    int64_t player1score;
    int64_t player2score;
    
    NSTimer * timer;
    NSTimer * scoretimer;

    int timeLeft;
    
    BOOL isPlayer1;
    BOOL isPlayer2;

    BOOL receivedRandom;
    BOOL updateLabelClock;
    BOOL hasPresentedGC;
    
    uint32_t ourRandom;
    GameState gameState;
    NSString *otherPlayerID;
    MBProgressHUD *HUD;
    
    
    IBOutlet UIImageView *bar1;
    IBOutlet UIImageView *bar2;
    
    int packageRecive;
    int packageSent;
}

@property (nonatomic,assign) BOOL Started;
@property (weak, nonatomic) IBOutlet UIView *outerButtonView;
@property (weak, nonatomic) IBOutlet UIButton *ButtonView;

@property (weak, nonatomic) IBOutlet UIView *outerButtonView2;
@property (weak, nonatomic) IBOutlet UIButton *ButtonView2;
@property (weak, nonatomic) IBOutlet UIView *outerButtonView3;
@property (weak, nonatomic) IBOutlet UIButton *ButtonView3;
@property (weak, nonatomic) IBOutlet UIView *outerButtonView4;
@property (weak, nonatomic) IBOutlet UIButton *ButtonView4;
-(IBAction)tapButton:(id)sender;

-(void)populateLabelwithTime:(int)milliseconds;

@end
