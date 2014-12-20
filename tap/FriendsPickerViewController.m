//
//  FriendsPickerViewController.m
//  MonkeyJump
//
//  Created by Fahim Farook on 18/8/12.
//
//


#import "FriendsPickerViewController.h"
#import <QuartzCore/QuartzCore.h>

#define kPlayerKey @"player"
#define kScoreKey @"score"
#define kIsChallengedKey @"isChallenged"

#define kCheckMarkTag 4

@interface FriendsPickerViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, GCHelperDelegate> {
    NSMutableDictionary *_dataSource;
    int64_t _score;
}

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UITextField *challengeTextField;

@end

@implementation FriendsPickerViewController

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

-(id)initWithScore:(int64_t) score {
    self = [super initWithNibName:@"FriendsPickerViewController" bundle:nil];
    if (self) {
        _score = score;
		_dataSource = [NSMutableDictionary dictionary];
		GCHelper *gameKitHelper = [GCHelper sharedInstance];
		gameKitHelper.delegate = self;
		[gameKitHelper findScoresOfFriendsToChallenge];
        
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 6.0) {
        sharebut.enabled = NO;
    }
    
    GCHelper *gameKitHelper = [GCHelper sharedInstance];
    gameKitHelper.delegate = self;
    
    UIBarButtonItem *cancelButton =
	[[UIBarButtonItem alloc]
	 initWithTitle:@"Cancel"
	 style:UIBarButtonItemStylePlain
	 target:self
	 action:@selector(cancelButtonPressed:)];
    
    UIBarButtonItem *challengeButton =
	[[UIBarButtonItem alloc]
	 initWithTitle:@"Challenge"
	 style:UIBarButtonItemStylePlain
	 target:self
	 action:@selector(challengeButtonPressed:)];
    
    self.navigationItem.leftBarButtonItem =
	cancelButton;
    self.navigationItem.rightBarButtonItem =
	challengeButton;
    self.navigationItem.title = @"Challenge";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancelButtonPressed:(id) sender {
    if (self.cancelButtonPressedBlock != nil) {
        self.cancelButtonPressedBlock();
    }
}

- (void)challengeButtonPressed:
(id) sender {
    
    //1
    
    
    //2
    NSMutableArray *playerIds =
    [NSMutableArray array];
    NSArray *allValues =
    [_dataSource allValues];
    
    for (NSDictionary *dict in allValues) {
        if ([dict[kIsChallengedKey]
             boolValue] == YES) {
            
            GKPlayer *player =
            dict[kPlayerKey];
            [playerIds addObject:
             player.playerID];
        }
    }
    if (playerIds.count > 0) {
        
        //3
        [[GCHelper sharedInstance]
         sendScoreChallengeToPlayers:playerIds
         withScore:_score message:@"Try to beat my score"];
    }
    
    if (self.challengeButtonPressedBlock) {
        self.challengeButtonPressedBlock();
    }
    
}

-(void)onScoresOfFriendsToChallengeListReceived:(NSArray*)scores {
    //1
    NSMutableArray *playerIds =
	[NSMutableArray array];
    
    //2
    [scores enumerateObjectsUsingBlock:
	 ^(id obj, NSUInteger idx, BOOL *stop){
		 
		 GKScore *score = (GKScore*) obj;
		 
		 //3
		 if(_dataSource[score.playerID]
			== nil) {
			 _dataSource[score.playerID] =
			 [NSMutableDictionary dictionary];
			 [playerIds addObject:score.playerID];
		 }
		 
		 //4
		 if (score.value < _score) {
			 [_dataSource[score.playerID]
			  setObject:[NSNumber numberWithBool:YES]
			  forKey:kIsChallengedKey];
		 }
		 
		 //5
		 [_dataSource[score.playerID]
		  setObject:score forKey:kScoreKey];
	 }];
    
    //6
    [[GCHelper sharedInstance]
	 getPlayerInfo:playerIds];
    [self.tableView reloadData];
}

-(void) onPlayerInfoReceived:(NSArray*)players {
    //1
    
    [players
	 enumerateObjectsUsingBlock:
	 ^(id obj, NSUInteger idx, BOOL *stop) {
		 
		 GKPlayer *player = (GKPlayer*)obj;
		 
		 //2
		 if (_dataSource[player.playerID]
			 == nil) {
			 _dataSource[player.playerID] =
			 [NSMutableDictionary dictionary];
		 }
		 [_dataSource[player.playerID]
		  setObject:player forKey:kPlayerKey];
		 
		 //3
		 [self.tableView reloadData];
	 }];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell identifier";
    static int ScoreLabelTag = 1;
    static int PlayerImageTag = 2;
    static int PlayerNameTag = 3;
    
    UITableViewCell *tableViewCell =
	[tableView
	 dequeueReusableCellWithIdentifier:
	 CellIdentifier];
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenHeight = screenSize.height;
    if (!tableViewCell) {
        
        tableViewCell =
		[[UITableViewCell alloc]
		 initWithStyle:UITableViewCellStyleDefault
		 reuseIdentifier:CellIdentifier];
        tableViewCell.selectionStyle =
		UITableViewCellSelectionStyleGray;
        tableViewCell.textLabel.textColor =
		[UIColor whiteColor];
        
        UILabel *playerName =
		[[UILabel alloc] initWithFrame:
		 CGRectMake(50, 0, 150, 48)];
        playerName.tag = PlayerNameTag;
        playerName.font = [UIFont boldSystemFontOfSize:16];
        playerName.backgroundColor =
		[UIColor clearColor];
        playerName.textAlignment =
		UIControlContentVerticalAlignmentCenter;
        [tableViewCell addSubview:playerName];
        
        
        
        UILabel *scoreLabel =
		[[UILabel alloc]
		 initWithFrame:
		 CGRectMake(screenHeight*0.4, 0, 150,
					tableViewCell.frame.size.height)];
        
        scoreLabel.tag = ScoreLabelTag;
        scoreLabel.backgroundColor =
		[UIColor clearColor];
        scoreLabel.textColor = [UIColor colorWithRed:81.0/255.0 green:102.0/255.0 blue:145.0/255.0 alpha:1.0];
        [tableViewCell.contentView
		 addSubview:scoreLabel];
        
        UIImageView *checkmark =
		[[UIImageView alloc]
		 initWithImage:[UIImage
						imageNamed:@"check.png"]];
        checkmark.tag = kCheckMarkTag;
        checkmark.hidden = NO;
        CGRect frame = checkmark.frame;
        frame.origin =
        CGPointMake(15, 13);
        checkmark.frame = frame;
        [tableViewCell.contentView
		 addSubview:checkmark];
    }
    NSDictionary *dict =
	[_dataSource allValues][indexPath.row];
    GKScore *score = dict[kScoreKey];
    GKPlayer *player = dict[kPlayerKey];
    
    NSNumber *number = dict[kIsChallengedKey];
    
    UIImageView *checkmark =
	(UIImageView*)[tableViewCell
				   viewWithTag:kCheckMarkTag];
    
    if ([number boolValue] == YES) {
        checkmark.hidden = NO;
    } else {
        checkmark.hidden = YES;
    }
    
    [player
	 loadPhotoForSize:GKPhotoSizeSmall
	 withCompletionHandler:
	 ^(UIImage *photo, NSError *error) {
		 if (!error) {
			 UIImageView *playerImage =
			 (UIImageView*)[tableView
							viewWithTag:PlayerImageTag];
			 playerImage.image = photo;
		 } else {
			 NSLog(@"Error loading image %@",error);
		 }
	 }];
    
    UILabel *playerName =
	(UILabel*)[tableViewCell
			   viewWithTag:PlayerNameTag];
    playerName.text = player.displayName;
    
    UILabel *scoreLabel =
	(UILabel*)[tableViewCell
			   viewWithTag:ScoreLabelTag];
    scoreLabel.text = score.formattedValue;
    return tableViewCell;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	return @"Only Game Center Friends Playing Tap Happy Can Be Challenged";
}
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:
(NSIndexPath *)indexPath {
    
    BOOL isChallenged = NO;
    
    //1
    UITableViewCell *tableViewCell =
	[tableView cellForRowAtIndexPath:
	 indexPath];
    
    //2
    UIImageView *checkmark =
	(UIImageView*)[tableViewCell
				   viewWithTag:kCheckMarkTag];
    
    //3
    if (checkmark.isHidden == NO) {
        checkmark.hidden = YES;
    } else {
        checkmark.hidden = NO;
        isChallenged = YES;
    }
    NSArray *array =
	[_dataSource allValues];
    
    NSMutableDictionary *dict =
	array[indexPath.row];
    
    //4
    [dict setObject:[NSNumber
                     numberWithBool:isChallenged]
			 forKey:kIsChallengedKey];
    [tableView deselectRowAtIndexPath:indexPath
							 animated:YES];
}
-(IBAction)share:(id)sender{
    UIActivityViewController *share = [[UIActivityViewController alloc]initWithActivityItems:@[@"Check out Tap Happy for iOS (http://bit.ly/TgvnUd), so we can challenge each other's high scores through Game Center!"] applicationActivities:nil];
    [self presentViewController:share animated:YES completion:nil];
}
@end
