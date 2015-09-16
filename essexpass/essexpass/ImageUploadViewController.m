//
//  ImageUploadViewController.m
//  essexpass
//
//  Created by Paras Chodavadiya on 18/01/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import "ImageUploadViewController.h"
#import "MBProgressHUD.h"
#import "TermsOfUseViewController.h"

@interface ImageUploadViewController ()

@end

@implementation ImageUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _ivProfilePicture.layer.cornerRadius = 10;
    _ivProfilePicture.layer.masksToBounds = YES;
    _ivProfilePicture.layer.borderWidth = 0;
}
- (IBAction)btnChangeImage:(id)sender {
    
    UIActionSheet *actionsheet=[[UIActionSheet alloc]
                                initWithTitle:@"Select Photo"
                                delegate:self
                                cancelButtonTitle:@"Cancle"
                                destructiveButtonTitle:nil
                                otherButtonTitles:@"Choose From Gallery",@"Take Photo From Camera", nil];
    [actionsheet showInView:self.view];
}

- (IBAction)btnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    if(buttonIndex == 0)//gallery
    {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else if(buttonIndex == 1)//camera
    {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        else
        {
            UIAlertView *av =[[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Device has no camera" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [av show];
            return;
        }
    }
    else
    {
        return;
    }
    [self presentViewController:picker animated:YES completion:NULL];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image= info[UIImagePickerControllerEditedImage];
    _ivProfilePicture.image = image;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Next"])
    {
        TermsOfUseViewController *tou = (TermsOfUseViewController *)segue.destinationViewController;
        
        tou.fullName=_fullName;
        tou.email=_email;
        tou.postCode=_postCode;
        tou.mobileNo=_mobileNo;
        tou.password=_password;
        tou.image=_image;
    }
}

- (IBAction)btnNext:(id)sender
{
    _image=UIImageJPEGRepresentation(_ivProfilePicture.image, 0.1);
    [self performSegueWithIdentifier:@"Next" sender:self];
}

@end
