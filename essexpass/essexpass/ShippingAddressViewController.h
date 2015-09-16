//
//  ShippingAddressViewController.h
//  The Essex Pass
//
//  Created by Paras Chodavadiya on 05/08/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShippingAddressViewController : UIViewController<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtAddressLine1;
@property (weak, nonatomic) IBOutlet UITextField *txtAddressLine2;
@property (weak, nonatomic) IBOutlet UITextField *txtTown;
@property (weak, nonatomic) IBOutlet UITextField *txtPostCode;

- (IBAction)btnSubmit:(id)sender;
- (IBAction)btnCancel:(id)sender;

@end
