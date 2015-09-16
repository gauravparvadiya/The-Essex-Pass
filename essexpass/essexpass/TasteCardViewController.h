//
//  TasteCardViewController.h
//  essexpass
//
//  Created by Paras Chodavadiya on 18/01/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TasteCardViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *ivQRCode;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UIView *viewCard;

@property (weak, nonatomic) IBOutlet UILabel *lblUrl;

@property (weak, nonatomic) IBOutlet UILabel *lblDealSelected;

@property (weak, nonatomic) IBOutlet UILabel *lblMembershipName;

@property (weak, nonatomic) IBOutlet UILabel *lblMembershipNumber;

@property (weak, nonatomic) IBOutlet UILabel *lblExpiryDate;

@property (weak, nonatomic) IBOutlet UILabel *lblBussinessName;

@property (weak, nonatomic) IBOutlet UIButton *btnBack;

@property(strong ,nonatomic) NSString *dealId, *dealName, *dealCreateDate, *dealPlace, *actualDeal,*discount,*displayCard;
@property (strong,nonatomic)NSMutableArray *loyalty;

- (IBAction)btnBack:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewMessage;

@property (weak, nonatomic) IBOutlet UILabel *lblMessage;

@property (weak, nonatomic) IBOutlet UIButton *btnUpgrade;

- (IBAction)btnUpgrade:(id)sender;
- (IBAction)btnHeart:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnHeart;

@end
