//
//  TermsOfUseViewController.m
//  essexpass
//
//  Created by Paras Chodavadiya on 06/01/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import "TermsOfUseViewController.h"
#import "Contant.h"
#import "AFHTTPRequestOperationManager.h"
#import "ServiceCall.h"
#import "MBProgressHUD.h"

@interface TermsOfUseViewController ()
{
    BOOL isChecked;
    NSMutableDictionary *response;
    NSString *typedAuthCode;
}
@end

@implementation TermsOfUseViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    isChecked=0;
    response=[[NSMutableDictionary alloc]init];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:TERMSANDCONDITION]]];
}

- (IBAction)btnAcceptTerms:(id)sender {
    
    [self InsertRecordOfUser];
}

- (IBAction)btnCheckBox:(id)sender {

    if (isChecked)
    {
        [_btnCheckBox setImage:[UIImage imageNamed:@"chk_uncheck.png"] forState:UIControlStateNormal];
        _btnAcceptTerms.hidden=true;
    }
    else
    {
        [_btnCheckBox setImage:[UIImage imageNamed:@"chk_check.png"] forState:UIControlStateNormal];
        _btnAcceptTerms.hidden=false;
    }
    
    isChecked=!isChecked;
}

- (IBAction)btnBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 5)
    {
        if (buttonIndex == 0)
        {
            typedAuthCode=[alertView textFieldAtIndex:0].text;
            [self authenticationAccount];
            
            if([typedAuthCode isEqualToString:[[[response objectForKey:@"userdetail"]objectAtIndex:0]objectForKey:@"authCode"]])
            {
                [self successfullyLogin];
            }
            else
            {
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Wrong authentication code." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                alert.tag=10;
                [alert show];
                
            }
        }
        else if(buttonIndex == 1)
        {
            [self resendAuthenticationCode];
        }
    }
    else if(alertView.tag == 10)
    {
        [self confirmAlertView];
    }
    else if(alertView.tag == 555)
    {
        [self confirmAlertView];
    }
}


-(void)InsertRecordOfUser
{
    if ([response count]!=0)
    {
        [self confirmAlertView];
        return;
    }
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"Sign Up...";

    NSMutableDictionary *jsonData = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                            _fullName,@"userName",
                                           _email,@"email",
                                           _postCode,@"postcode",
                                           _mobileNo,@"mobileNo",
                                           _password,@"password",
                                           nil];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:REGISTER]];
    
    AFHTTPRequestOperation *op = [manager POST:REGISTER parameters:jsonData constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
    {
        [formData appendPartWithFileData:_image name:@"uploaded_file" fileName:@"profilePic.jpeg" mimeType:@"image/jpeg"];
    }
    success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        [hud hide:YES];
        //NSLog(@"%@",responseObject);
        if([[responseObject objectForKey:@"Result"]isEqualToString:@"True"])
        {
            response=responseObject;
            
            if ([[[[response objectForKey:@"userdetail"]objectAtIndex:0]objectForKey:@"isApproved"]isEqualToString:@"No"])
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Registration Successful!"
                                                    message:@"Please now check the inbox of your registered email address for the authentication code. You may also need to check your junk folder."
                                                    delegate:self
                                                    cancelButtonTitle:@"Ok"
                                                    otherButtonTitles:nil];
                alert.tag=555;
                [alert show];
                
                return;
            }
            [self successfullyLogin];
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Registration Failed" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
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
//that is sent on your register email.
-(void)confirmAlertView
{
    UIAlertView *conformation=[[UIAlertView alloc]initWithTitle:@"Authenticate account" message:@"Enter authentication code." delegate:self  cancelButtonTitle:nil otherButtonTitles:@"Ok",@"Resend email", nil];
    conformation.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    conformation.tag=5;
    [conformation show];
}

-(void)successfullyLogin
{

    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Welcome to The Essex Pass." delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    
    [alert show];
    
    [[NSUserDefaults standardUserDefaults]setObject:[[response objectForKey:@"userdetail"]objectAtIndex:0] forKey:@"userDetail"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [[NSUserDefaults standardUserDefaults]setObject:[response objectForKey:@"ServerTime"]forKey:@"ServerTimeZone"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    //NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"ServerTimeZone"]);
    //NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"]);
    
    [self registerDevice];
    
    [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:2];
    [self performSegueWithIdentifier:@"Accept Terms" sender:self];
}

-(void)authenticationAccount
{
    NSMutableDictionary *jsonData =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    _email,@"userEmail",
                                    typedAuthCode,@"authCode",nil];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:APPROVEDUSER]];
    
    AFHTTPRequestOperation *op = [manager POST:APPROVEDUSER parameters:jsonData constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    }
        success:^(AFHTTPRequestOperation *operation, id responseObject)
        {
            NSLog(@"%@",responseObject);
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
            NSLog(@"Error : %@",error);
        }
        ];
    [op start];
}

-(void)resendAuthenticationCode
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"Sending authentication code...";
    
    NSMutableDictionary *jsonData =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    _email,@"userEmail",nil];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:RESENDAUTHCODE]];
    
    AFHTTPRequestOperation *op = [manager POST:RESENDAUTHCODE parameters:jsonData constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    }
        success:^(AFHTTPRequestOperation *operation, id responseObject)
        {
            [hud hide:YES];
            NSLog(@"%@",responseObject);
            response=responseObject;

            [self confirmAlertView];
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
            [hud hide:YES];
            NSLog(@"Error : %@",error);
        }
    ];
    [op start];
}

-(void)dismissAlertView:(UIAlertView *)alertView{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark RegisterDevice
-(void)registerDevice
{
    NSMutableDictionary *userDetail=[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"];
    
    NSMutableDictionary *jsonData =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [[NSUserDefaults standardUserDefaults]objectForKey:@"deviceToken"],@"deviceUdid",
                                    @"iPhone",@"deviceType",
                                    [userDetail objectForKey:@"email"],@"email"
                                    ,nil];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:REGISTERDEVICE]];
    
    [manager POST:REGISTERDEVICE parameters:jsonData constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    }
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"%@",responseObject);
         if([[responseObject objectForKey:@"Result"]isEqualToString:@"True"])
         {
             
         }
         
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error : %@",error);
     }
     ];
}
@end
