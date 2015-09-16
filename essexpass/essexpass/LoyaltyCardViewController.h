//
//  LoyaltyCardViewController.h
//  The Essex Pass
//
//  Created by Paras Chodavadiya on 26/05/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoyaltyCardViewController : UIViewController

@property int countForScanned;
@property (weak, nonatomic) NSString *dealId;
@property (strong,nonatomic)NSMutableArray *loyalty;

- (IBAction)btnBack:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (weak, nonatomic) IBOutlet UIView *viewMessage;

@property (weak, nonatomic) IBOutlet UIView *viewAllCircle;


@property (weak, nonatomic) IBOutlet UIView *view1to5;
@property (weak, nonatomic) IBOutlet UIView *view6to10;


@property (weak, nonatomic) IBOutlet UIView *viewCard;

@property (weak, nonatomic) IBOutlet UIImageView *iv1;
@property (weak, nonatomic) IBOutlet UIImageView *iv2;
@property (weak, nonatomic) IBOutlet UIImageView *iv3;
@property (weak, nonatomic) IBOutlet UIImageView *iv4;
@property (weak, nonatomic) IBOutlet UIImageView *iv5;
@property (weak, nonatomic) IBOutlet UIImageView *iv6;
@property (weak, nonatomic) IBOutlet UIImageView *iv7;
@property (weak, nonatomic) IBOutlet UIImageView *iv8;
@property (weak, nonatomic) IBOutlet UIImageView *iv9;
@property (weak, nonatomic) IBOutlet UIImageView *iv10;


@end
