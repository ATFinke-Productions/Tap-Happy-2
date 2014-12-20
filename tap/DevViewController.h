//
//  DevViewController.h
//  tap
//
//  Created by Andrew on 2/24/13.
//  Copyright (c) 2013 Andrew. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DevViewController : UIViewController {
    MBProgressHUD *HUD;
    IBOutlet UITextField *username;
    IBOutlet UITextField *password;
    IBOutlet UILabel *wrong;
    int tries;
    
    IBOutlet UIButton *but1;
    IBOutlet UIButton *but2;
}

-(IBAction)login:(id)sender;
-(IBAction)resetDef:(id)sender;
-(IBAction)resetAch:(id)sender;

@end
