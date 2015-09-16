//
//  MyAccountViewController.m
//  The Essex Pass
//
//  Created by Paras Chodavadiya on 03/02/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import "MyAccountViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "Contant.h"
#import "MBProgressHUD.h"

@interface MyAccountViewController ()
{
    CLLocationManager *locationManager;
    float latitude,longitude;
    
    NSString *flag;
    
    NSMutableDictionary *userDetail;
    NSString *email, *oldPassword, *image;
    UITextField *txtOld,*txtNew,*txtConfim;
}
@end

@implementation MyAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    userDetail=[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"];
    [self loadData];
    
    flag=@"1";
    
    if(ISIPHONE4)
        [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height+50)];
    
    //    locationManager = [[CLLocationManager alloc] init];
    //    locationManager.delegate=self;
    //    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //
    //    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1)
    //    {
    //        // here you go with iOS 8
    //        [locationManager requestAlwaysAuthorization];
    //        [locationManager requestWhenInUseAuthorization];
    //    }
    //    [locationManager startUpdatingLocation];
    
}

//-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
//{
//
//    CLLocation *newLocation = [locations lastObject];
//
//    latitude = newLocation.coordinate.latitude;
//    longitude = newLocation.coordinate.longitude;
//
//    NSLog(@"lat : %f",latitude);
//    NSLog(@"long : %f",longitude);
//
//    [manager stopUpdatingLocation];
//}
//
//-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
//{
//    NSLog(@"locationManager:%@ didFailWithError:%@", manager, error);
//}


-(void)hideKeyboard:(id)sender
{
    [self.view endEditing:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    //    [[[UIAlertView alloc] initWithTitle:@"Alert #1" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    //    [[[UIAlertView alloc] initWithTitle:@"Alert #2" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

-(void)loadData
{
    _txtFullName.text=[userDetail objectForKey:@"userName"];
    _txtMobileNo.text=[userDetail objectForKey:@"mobileNo"];
    //_txtPostCode.text=[userDetail objectForKey:@"postcode"];
    email=[userDetail objectForKey:@"email"];
    oldPassword=[userDetail objectForKey:@"password"];
    image=[userDetail objectForKey:@"image"];
    
    _ivProfilePic.layer.cornerRadius=5.0f;
    _ivProfilePic.layer.masksToBounds=YES;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:image parameters:nil
         success:^(AFHTTPRequestOperation *operation, NSData *returnData)
     {
         [_indicatorImage stopAnimating];
         //_ivProfilePic.image = [UIImage imageWithData:returnData];
         [UIView transitionWithView:_ivProfilePic
                           duration:0.5f
                            options:UIViewAnimationOptionTransitionCrossDissolve
                         animations:^{
                             _ivProfilePic.image = [UIImage imageWithData:returnData];
                         } completion:NULL];
         
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error.description);
     }];
}

- (IBAction)btnUpdateProfile:(id)sender {
    
    Boolean valid = [self validation];
    
    if(!valid)
    {
        return;
    }
    
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"Updating Your Profile...";
    
    NSMutableDictionary *jsonData = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     _txtFullName.text,@"userName",
                                     email,@"email",
                                     @"",@"postcode",
                                     _txtMobileNo.text,@"mobileNo",
                                     flag,@"flag",
                                     nil];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:EDITPROFILE]];
    
    AFHTTPRequestOperation *op = [manager POST:EDITPROFILE parameters:jsonData constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        if([flag isEqualToString:@"2"])
        {
            NSData *imageData=UIImageJPEGRepresentation(_ivProfilePic.image, 0.1);
            [formData appendPartWithFileData:imageData name:@"uploaded_file" fileName:@"profilePic.jpeg" mimeType:@"image/jpeg"];
        }
    }
                                       success:^(AFHTTPRequestOperation *operation, id responseObject)
                                  {
                                      [hud hide:YES];
                                      //NSLog(@"%@",responseObject);
                                      if([[responseObject objectForKey:@"Result"]isEqualToString:@"True"])
                                      {
                                          UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Your profile has been updated." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                          
                                          [[NSUserDefaults standardUserDefaults]setObject:[[responseObject objectForKey:@"userdetail"]objectAtIndex:0] forKey:@"userDetail"];
                                          [[NSUserDefaults standardUserDefaults]synchronize];
                                          
                                          //[self loadData];
                                          NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"]) ;
                                          [alert show];
                                      }
                                      else
                                      {
                                          NSString *msg= [responseObject objectForKey:@"ResponseMsg"];
                                          UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                          [alert show];
                                      }
                                  }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error)
                                  {
                                      NSLog(@"Error : %@",error);
                                      [hud hide:YES];
                                  }
                                  ];
    [op start];
    
    
}
- (IBAction)btnUploadImage:(id)sender {
    
    UIActionSheet *actionsheet=[[UIActionSheet alloc]
                                initWithTitle:@"Select Photo"
                                delegate:self
                                cancelButtonTitle:@"Cancle"
                                destructiveButtonTitle:nil
                                otherButtonTitles:@"Choose From Gallery",@"Take Photo From Camera", nil];
    [actionsheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = (id)self;
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
    [_indicatorImage stopAnimating];
    UIImage *profilePic= info[UIImagePickerControllerEditedImage];
    _ivProfilePic.image = profilePic;
    flag=@"2";
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == _txtFullName)
    {
        [_txtMobileNo becomeFirstResponder];
    }
    //    else if (textField == _txtPostCode)
    //    {
    //        [_txtMobileNo becomeFirstResponder];
    //    }
    else if(textField == _txtMobileNo)
    {
        [textField resignFirstResponder];
    }
    else if (textField == txtOld)
    {
        [txtNew becomeFirstResponder];
    }
    else if (textField == txtNew)
    {
        [txtConfim becomeFirstResponder];
    }
    else if (textField == txtConfim)
    {
        [textField resignFirstResponder];
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (ISIPHONE4)
    {
        [_scrollView setContentOffset:CGPointMake(0,_scrollView.frame.origin.y+30) animated:YES];
    }
}

-(Boolean)validation
{
    if( [_txtFullName.text isEqual:@""] )
    {
        [self displayMsg:@"Please Enter Full Name." :@"Ok"];
        return FALSE;
    }
    
    return TRUE;
}

-(void) displayMsg :(NSString *)msg :(NSString *)cancleButtonText
{
    UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"Oops!" message:msg  delegate:self cancelButtonTitle:cancleButtonText otherButtonTitles: nil];
    
    [av show];
    
}
- (IBAction)btnUpdatePassword:(id)sender {
    
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cahnge Password"
    //                                                    message:nil
    //                                                   delegate:self
    //                                          cancelButtonTitle:@"Cancle"
    //                                          otherButtonTitles:@"Ok", nil];
    //    _viewtemp.frame=CGRectMake(0, 0, 50, 50);
    //    [alert setValue:_viewtemp forKey:@"accessoryView"];
    //    [alert show];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Change Password" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 146)];
    
    txtOld=[[UITextField alloc]init];
    txtOld.frame=CGRectMake(12, 0, 238, 30);
    txtOld.tag=1;
    txtOld.secureTextEntry = YES;
    txtOld.placeholder=@"Old Password";
    [txtOld setBorderStyle:UITextBorderStyleBezel];
    [txtOld setDelegate:self];
    txtOld.font = [UIFont systemFontOfSize:14];
    [v addSubview:txtOld];
    
    txtNew=[[UITextField alloc]init];
    txtNew.frame=CGRectMake(12, 35, 238, 30);
    txtNew.tag=2;
    txtNew.secureTextEntry = YES;
    txtNew.placeholder=@"New Password";
    [txtNew setBorderStyle:UITextBorderStyleBezel];
    [txtNew setDelegate:self];
    txtNew.font = [UIFont systemFontOfSize:14];
    [v addSubview:txtNew];
    
    txtConfim=[[UITextField alloc]init];
    txtConfim.frame=CGRectMake(12, 70, 238, 30);
    txtConfim.tag=3;
    txtConfim.secureTextEntry = YES;
    txtConfim.placeholder=@"Confim Password";
    [txtConfim setBorderStyle:UITextBorderStyleBezel];
    txtConfim.font = [UIFont systemFontOfSize:14];
    [txtConfim setDelegate:self];
    [v addSubview:txtConfim];
    
    [av setValue:v forKey:@"accessoryView"];
    [av setTag:5];
    [av show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag ==5)
    {
        if (buttonIndex == 1)
        {
            Boolean valid = [self validationForPassword];
            
            if(!valid)
            {
                return;
            }
            
            MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText=@"Updating Your Password...";
            
            NSMutableDictionary *jsonData = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                             email,@"email",
                                             txtNew.text,@"password",
                                             nil];
            AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:CHANGEPASSWORD]];
            
            AFHTTPRequestOperation *op = [manager POST:CHANGEPASSWORD parameters:jsonData constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                
            }
                                               success:^(AFHTTPRequestOperation *operation, id responseObject)
                                          {
                                              [hud hide:YES];
                                              NSLog(@"%@",responseObject);
                                              if([[responseObject objectForKey:@"Result"]isEqualToString:@"True"])
                                              {
                                                  UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Your Password is update successfully." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                                  
                                                  [[NSUserDefaults standardUserDefaults]setObject:[[responseObject objectForKey:@"userdetail"]objectAtIndex:0] forKey:@"userDetail"];
                                                  [[NSUserDefaults standardUserDefaults]synchronize];
                                                  
                                                  //[self loadData];
                                                  
                                                  [alert show];
                                              }
                                              else
                                              {
                                                  NSString *msg= [responseObject objectForKey:@"ResponseMsg"];
                                                  UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                                  [alert show];
                                              }
                                          }
                                               failure:^(AFHTTPRequestOperation *operation, NSError *error)
                                          {
                                              NSLog(@"Error : %@",error);
                                              [hud hide:YES];
                                          }
                                          ];
            [op start];
            
        }
    }
}

-(Boolean)validationForPassword
{
    if( [txtOld.text isEqual:@""]|| [txtNew.text isEqual:@""] || [txtConfim.text isEqual: @""] )
    {
        [self displayMsg:@"All Filled Is Require." :@"Ok"];
        return FALSE;
    }
    
    userDetail=[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"];
    oldPassword=[userDetail objectForKey:@"password"];
    
    if(![oldPassword isEqual:txtOld.text])
    {
        [self displayMsg:@"Enter Correct Old Password." :@"Ok" ];
        [_txtOldPassword becomeFirstResponder];
        return FALSE;
    }
    
    if(![txtNew.text isEqual:txtConfim.text])
    {
        [self displayMsg:@"Confirm Password Is Not Match To Password" :@"Ok" ];
        [_txtConfimPassword becomeFirstResponder];
        return FALSE;
    }
    
    return TRUE;
}

@end
