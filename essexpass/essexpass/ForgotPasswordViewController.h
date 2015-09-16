//
//  ForgotPasswordViewController.h
//  essexpass
//
//  Created by Paras Chodavadiya on 06/01/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPasswordViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;

@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;

- (IBAction)btnSubmit:(id)sender;


- (IBAction)btnBack:(id)sender;


@end
