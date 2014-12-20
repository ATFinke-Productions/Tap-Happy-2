//
//  AboutViewController.h
//  tap
//
//  Created by Andrew on 2/23/13.
//  Copyright (c) 2013 Andrew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface AboutViewController : UIViewController <GCHelperDelegate>

-(IBAction)more:(id)sender;
-(IBAction)web:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *outerButtonView;
@property (weak, nonatomic) IBOutlet UIButton *ButtonView;
@property (weak, nonatomic) IBOutlet UIView *outerButtonView1;
@property (weak, nonatomic) IBOutlet UIButton *ButtonView1;

@end
