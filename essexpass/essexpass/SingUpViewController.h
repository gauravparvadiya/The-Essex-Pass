//
//  SingUpViewController.h
//  essexpass
//
//  Created by Paras Chodavadiya on 06/01/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingUpViewController : UIViewController<UITextFieldDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UITextField *txtFullName;

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;

@property (weak, nonatomic) IBOutlet UITextField *txtMobileNo;

@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

@property (weak, nonatomic) IBOutlet UITextField *txtConfimPassword;

@property (weak, nonatomic) IBOutlet UIButton *btnSingUp;

@property (weak, nonatomic) IBOutlet UILabel *lblHaveAccount;

@property (weak, nonatomic) IBOutlet UIButton *btnSingIn;

- (IBAction)btnSingUp:(id)sender;

- (IBAction)btnSingIn:(id)sender;


- (IBAction)btnBack:(id)sender;















@end
