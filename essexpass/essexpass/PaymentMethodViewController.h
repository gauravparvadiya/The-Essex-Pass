//
//  PaymentMethodViewController.h
//  essexpass
//
//  Created by Paras Chodavadiya on 20/01/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayPalMobile.h"
#import "Stripe.h"

@protocol STPBackendCharging <NSObject>

- (void)createBackendChargeWithToken:(STPToken *)token completion:(STPTokenSubmissionHandler)completion;

@end

@interface PaymentMethodViewController : UIViewController<PayPalPaymentDelegate,STPBackendCharging>

@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
@property(nonatomic, strong, readwrite) NSString *resultText;

@property (weak, nonatomic) IBOutlet UIButton *btnStripe;
- (IBAction)btnStripe:(id)sender;

- (IBAction)btnPaypal:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *successView;

- (IBAction)btnBack:(id)sender;

@property(nonatomic,strong)NSString *dealId;




@end
