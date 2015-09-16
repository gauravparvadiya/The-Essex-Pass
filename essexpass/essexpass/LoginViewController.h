//
//  LoginViewController.h
//  essexpass
//
//  Created by Paras Chodavadiya on 06/01/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;

@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

@property (weak, nonatomic) IBOutlet UIButton *btnSingIn;

@property (weak, nonatomic) IBOutlet UIButton *btnForgotPassword;

@property (weak, nonatomic) IBOutlet UILabel *lbldonthaveaccount;

@property (weak, nonatomic) IBOutlet UIButton *btnSingUp;

- (IBAction)btnSingIn:(id)sender;

- (IBAction)btnForgotPassword:(id)sender;

- (IBAction)btnSingUp:(id)sender;

@property (strong,nonatomic)NSMutableDictionary *responce;

@property (weak, nonatomic) IBOutlet UILabel *label;

@property (weak, nonatomic) IBOutlet UIImageView *img;


@end
