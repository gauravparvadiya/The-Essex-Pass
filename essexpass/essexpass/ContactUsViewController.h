//
//  ContactUsViewController.h
//  The Essex Pass
//
//  Created by Paras Chodavadiya on 30/01/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactUsViewController : UIViewController<UIAlertViewDelegate,UITextFieldDelegate>

- (IBAction)btnBack:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtname;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtMobileNumber;
@property (weak, nonatomic) IBOutlet UITextView *txtMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnSend;
- (IBAction)btnSend:(id)sender;

@end
