//
//  TermsOfUseViewController.h
//  essexpass
//
//  Created by Paras Chodavadiya on 06/01/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TermsOfUseViewController : UIViewController<UIAlertViewDelegate>

@property (strong, nonatomic)NSString *fullName, *email, *postCode, *mobileNo, *password;

@property(strong,nonatomic)NSData *image;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UITextView *lblText;
@property (weak, nonatomic) IBOutlet UIWebView *webView;


@property (weak, nonatomic) IBOutlet UIButton *btnAcceptTerms;

- (IBAction)btnAcceptTerms:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnCheckBox;
- (IBAction)btnCheckBox:(id)sender;

- (IBAction)btnBack:(id)sender;









@end
