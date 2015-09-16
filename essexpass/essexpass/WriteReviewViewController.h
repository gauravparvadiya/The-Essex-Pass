//
//  WriteReviewViewController.h
//  The Essex Pass
//
//  Created by Paras Chodavadiya on 02/03/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WriteReviewViewController : UIViewController <UITextFieldDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnBack;

- (IBAction)btnBack:(id)sender;

- (IBAction)btnStar1:(id)sender;

- (IBAction)btnStar2:(id)sender;

- (IBAction)btnStar3:(id)sender;

- (IBAction)btnStar4:(id)sender;

- (IBAction)btnStar5:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnStar1;
@property (weak, nonatomic) IBOutlet UIButton *btnStar2;
@property (weak, nonatomic) IBOutlet UIButton *btnStar3;
@property (weak, nonatomic) IBOutlet UIButton *btnStar4;
@property (weak, nonatomic) IBOutlet UIButton *btnStar5;

@property (strong,nonatomic) NSString *type;
@property (strong,nonatomic) NSString *Id;
@property (strong,nonatomic) NSMutableDictionary *userReview;

@property (weak, nonatomic) IBOutlet UITextField *txtTitle;

@property (weak, nonatomic) IBOutlet UITextView *txtDescription;

- (IBAction)btnPost:(id)sender;

@end
