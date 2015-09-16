//
//  MyAccountViewController.h
//  The Essex Pass
//
//  Created by Paras Chodavadiya on 03/02/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MyAccountViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIImageView *ivProfilePic;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorImage;
@property (weak, nonatomic) IBOutlet UIButton *btnUploadImage;
- (IBAction)btnUploadImage:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *txtFullName;
@property (weak, nonatomic) IBOutlet UITextField *txtMobileNo;

@property (weak, nonatomic) IBOutlet UITextField *txtOldPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtConfimPassword;
@property (weak, nonatomic) IBOutlet UIView *viewtemp;

@property (weak, nonatomic) IBOutlet UIView *viewChangePassword;

- (IBAction)btnUpdateProfile:(id)sender;

- (IBAction)btnUpdatePassword:(id)sender;




@end
