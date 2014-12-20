//
//  IntroViewController.m
//  tap
//
//  Created by Andrew on 2/22/13.
//  Copyright (c) 2013 Andrew. All rights reserved.
//

#import "IntroViewController.h"

@interface IntroViewController () <GCHelperDelegate>

@end

@implementation IntroViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
    }
    return self;
}

-(void)inviteReceived{
    if (isCompatible) {
    [self performSegueWithIdentifier:@"game" sender:self];
    }
    else {
    [self notCompatibleAlert];
    }
}

-(void)notCompatibleAlert{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	HUD.mode = MBProgressHUDModeDeterminate;
	HUD.labelText = @"Please Upgrade";
    HUD.detailsLabelText = @"For now, this feature is only available on iOS 6.0 and newer";
	[HUD showWhileExecuting:@selector(myProgressTask) onTarget:self withObject:nil animated:YES];
}
- (void)myProgressTask {
	// This just increases the progress indicator in a loop
	float progress = 0.0f;
	while (progress < 1.0f) {
		progress += 0.01f;
		HUD.progress = progress;
		usleep(50000);
	}
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self buttonDesgin];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        pushUpDown = 1140;
        menuLabel.font = [UIFont fontWithName:@"MyriadPro-BoldCond" size:150];
        pro.font = [UIFont fontWithName:@"UbuntuTitling-Bold" size:60];
        pro1.font = [UIFont fontWithName:@"UbuntuTitling-Bold" size:60];
        pro2.font = [UIFont fontWithName:@"UbuntuTitling-Bold" size:50];
    }
    else
    {
        pushUpDown = 540;
        menuLabel.font = [UIFont fontWithName:@"MyriadPro-BoldCond" size:70];
        pro.font = [UIFont fontWithName:@"UbuntuTitling-Bold" size:40];
        pro1.font = [UIFont fontWithName:@"UbuntuTitling-Bold" size:40];
        pro2.font = [UIFont fontWithName:@"UbuntuTitling-Bold" size:30];
    }
    
    if ([[[UIDevice currentDevice] systemVersion]floatValue] >= 6.0) {
        isCompatible = YES;
    }
    else {
        isCompatible = NO;
    }
    [self viewDidAppear:YES];
    
    GCHelper *gameKitHelper = [GCHelper sharedInstance];
    gameKitHelper.delegate = self;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:4.0
                                             target:self
                                           selector:@selector(transitionStart)
                                           userInfo:nil
                                            repeats:YES];
	
        but1.frame = CGRectOffset(but1.frame, 0, pushUpDown);
        but2.frame = CGRectOffset(but2.frame, 0, pushUpDown);
        but3.frame = CGRectOffset(but3.frame, 0, pushUpDown);
        but4.frame = CGRectOffset(but4.frame, 0, pushUpDown);
        but7.frame = CGRectOffset(but7.frame, 0, pushUpDown);
        but5.frame = CGRectOffset(but5.frame, 0, -pushUpDown);
        menuLabel.frame = CGRectOffset(menuLabel.frame, 0, pushUpDown);
    
    UISwipeGestureRecognizer *one =
    [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(debug1)];
    [one setDirection:UISwipeGestureRecognizerDirectionDown];
    [one setNumberOfTouchesRequired:2];
    [[self view] addGestureRecognizer:one];
    [self debugEnabler];
    
}

-(void)debugEnabler{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults boolForKey:@"debugModeEnabled"]) {
        buildLabel.text = [NSString stringWithFormat:@"Debug Mode Enabled\nVersion: %@ Build: %@\n%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"], [defaults valueForKey:@"BuildTime"]];
        buildLabel.hidden = NO;
        but6.hidden = NO;
    }
    else {
        buildLabel.hidden = YES;
        but6.hidden = YES;
    }
}

-(void)debug1{
    UISwipeGestureRecognizer *two =
    [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(debug2)];
    [two setDirection:UISwipeGestureRecognizerDirectionUp];
    [two setNumberOfTouchesRequired:2];
    [[self view] addGestureRecognizer:two];
    NSLog(@"Step 1/2 Done");
}

-(void)debug2{
    NSLog(@"Step 2/2 Done");
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	HUD.square = YES;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:@"debugModeEnabled"]) {
        [defaults setBool:NO forKey:@"debugModeEnabled"];
        HUD.labelText = @"Debug Mode Off";
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        HUD.mode = MBProgressHUDModeCustomView;
        [HUD show:YES];
        [HUD hide:YES afterDelay:2];
        [defaults synchronize];
        [self debugEnabler];
    }
    else {
        [self performSegueWithIdentifier:@"dev" sender:self];
    }
}


-(void)transitionStart{
    [timer invalidate];
    
    [UIView beginAnimations:@"on" context:NULL];
    [UIView setAnimationDuration:3.5];
    
    but1.frame = CGRectOffset(but1.frame, 0, -pushUpDown);
    but2.frame = CGRectOffset(but2.frame, 0, -pushUpDown);
    but3.frame = CGRectOffset(but3.frame, 0, -pushUpDown);
    but4.frame = CGRectOffset(but4.frame, 0, -pushUpDown);
    but7.frame = CGRectOffset(but7.frame, 0, -pushUpDown);
    but5.frame = CGRectOffset(but5.frame, 0, pushUpDown);
    menuLabel.frame = CGRectOffset(menuLabel.frame, 0, -pushUpDown);
    pro.frame = CGRectOffset(pro.frame, 0, -pushUpDown);
    pro1.frame = CGRectOffset(pro1.frame, 0, -pushUpDown);
    pro2.frame = CGRectOffset(pro2.frame, 0, -pushUpDown);
    [UIView commitAnimations];
}

-(void)viewDidAppear:(BOOL)animated{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults integerForKey:@"InviteWaiting"] ==1) {
        [defaults setInteger:0 forKey:@"InviteWaiting"];
        [defaults synchronize];
        [self inviteReceived];
    }
    [self debugEnabler];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)challenge:(id)sender{
    
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"Game Center" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Achievements", @"Leaderboards", @"Challenges", nil];
    sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [sheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if  ([buttonTitle isEqualToString:@"Achievements"]) {
        GKAchievementViewController *vc = [[GKAchievementViewController alloc]init];
        vc.achievementDelegate = self;
        [self presentViewController:vc animated:YES completion:nil];
    }
    if ([buttonTitle isEqualToString:@"Leaderboards"]) {
        GKLeaderboardViewController *vc = [[GKLeaderboardViewController alloc]init];
        vc.leaderboardDelegate = self;
        [self presentViewController:vc animated:YES completion:nil];
    }
    if ([buttonTitle isEqualToString:@"Challenges"]) {
        if (isCompatible) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [[GCHelper sharedInstance] showFriendsPickerViewControllerForScore:[defaults integerForKey:@"bestTapsGame"]];
        }
        else {
            [self notCompatibleAlert];
        }
    }
}

-(void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}
-(void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)game:(id)sender{
    [self inviteReceived];
}
-(IBAction)email:(id)sender{
    UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:@[@"Tap:"] applicationActivities:nil];
    [self presentViewController:vc animated:YES completion:nil];
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
