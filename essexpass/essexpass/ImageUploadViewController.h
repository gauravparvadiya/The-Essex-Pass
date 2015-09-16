//
//  ImageUploadViewController.h
//  essexpass
//
//  Created by Paras Chodavadiya on 18/01/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageUploadViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *ivProfilePicture;

@property (strong, nonatomic)NSString *fullName, *email, *postCode, *mobileNo, *password;

@property(strong,nonatomic)NSData *image;

- (IBAction)btnChangeImage:(id)sender;

- (IBAction)btnBack:(id)sender;

- (IBAction)btnNext:(id)sender;
@end
