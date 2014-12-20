//
//  DevViewController.m
//  tap
//
//  Created by Andrew on 2/24/13.
//  Copyright (c) 2013 Andrew. All rights reserved.
//

#import "DevViewController.h"

@interface DevViewController ()

@end

@implementation DevViewController

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
    wrong.hidden = YES;
	// Do any additional setup after loading the view.
}
-(IBAction)login:(id)sender{
    wrong.hidden = YES;
    [self checkUsername:username.text andPassword:password.text];
}

-(void)checkUsername:(NSString *)userName andPassword:(NSString *)passWord{
    if (![userName isEqual:@"nam"]) {
        wrong.hidden = NO;
        tries++;
        wrong.text = [NSString stringWithFormat:@"Incorrect Username / Password\nTries: %d",tries];
        return;
    }
    if (![passWord isEqual:@"pas"]) {
        wrong.hidden = NO;
        tries++;
        wrong.text = [NSString stringWithFormat:@"Incorrect Username / Password\nTries: %d",tries];
        return;
    }
        for (UITextView *textView in self.view.subviews) {
            if ([textView isFirstResponder]) {
                [textView resignFirstResponder];
            }
        }
[self enable];
}

-(IBAction)resetDef:(id)sender{
    NSDictionary *defaultsDictionary = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    for (NSString *key in [defaultsDictionary allKeys]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(IBAction)resetAch:(id)sender{
    [[GCHelper sharedInstance] resetAchievements];
}

-(void)enable{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	HUD.square = YES;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"debugModeEnabled"];
    HUD.labelText = @"Debug Mode On";
    [defaults synchronize];
    
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
	HUD.mode = MBProgressHUDModeCustomView;
    [HUD show:YES];
    [HUD hide:YES afterDelay:2];
    but1.hidden = NO;
    but2.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
