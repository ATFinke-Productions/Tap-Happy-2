//
//  AboutViewController.m
//  tap
//
//  Created by Andrew on 2/23/13.
//  Copyright (c) 2013 Andrew. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

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
    
    GCHelper *gameKitHelper = [GCHelper sharedInstance];
    gameKitHelper.delegate = self;
    
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
	// Do any additional setup after loading the view.
}

-(void)inviteReceived{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)more:(id)sender{
    //[ATFinke show];
}
-(IBAction)web:(id)sender{
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"http://www.atfinkeproductions.com"]];
}

@end
