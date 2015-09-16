//
//  LoginViewController.m
//  essexpass
//
//  Created by Paras Chodavadiya on 06/01/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import "LoginViewController.h"
#import "Contant.h"
#import "AFHTTPRequestOperationManager.h"
#import "ServiceCall.h"
#import "MBProgressHUD.h"

@interface LoginViewController ()
{
    NSMutableDictionary *response;
    NSString *typedAuthCode;
}
@end

@implementation LoginViewController



- (void)viewDidLoad {
    [super viewDidLoad];

    response=[[NSMutableDictionary alloc]init];
    
    //_txtEmail.text=@"pramodtapaniya.ibl@gmail.com";
    //_txtPassword.text=@"123";
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

-(void)hideKeyboard:(id)sender
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnSingIn:(id)sender {
    
    [_txtEmail resignFirstResponder];
    [_txtPassword resignFirstResponder];
    Boolean valid = [self validation];
    
    if(!valid)
    {
        return;
    }
    
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"Signing in...";
    
    NSMutableDictionary *jsonData =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    _txtEmail.text,@"email",
                                    _txtPassword.text,@"password",nil];    
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:LOGIN]];
    
    AFHTTPRequestOperation *op = [manager POST:LOGIN parameters:jsonData constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    }
           success:^(AFHTTPRequestOperation *operation, id responseObject)
      {
          [hud hide:YES];
          NSLog(@"%@",responseObject);
          if([[responseObject objectForKey:@"Result"]isEqualToString:@"True"])
          {
              response=responseObject;
              
              if ([[[[response objectForKey:@"userdetail"]objectAtIndex:0]objectForKey:@"isApproved"]isEqualToString:@"No"])
              {   
                  [self confirmAlertView];
                  return;
              }
              [self successfullyLogin];
          }
          else
          {
              UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Opps!" message:@"Your email or password is wrong. Please try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
              [alert show];
          }
      }
           failure:^(AFHTTPRequestOperation *operation, NSError *error)
      {
          if(error.code == -1004)
          {
              UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Could not connect to the server." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
              [alert show];
          }
          NSLog(@"Error : %@",error);
          [hud hide:YES];
      }
      ];
    [op start];
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
}

-(void)confirmAlertView
{
    UIAlertView *conformation=[[UIAlertView alloc]initWithTitle:@"Authenticate account" message:@"Enter authentication code, that is sent on your register email" delegate:self  cancelButtonTitle:nil otherButtonTitles:@"Ok",@"Resend email", nil];
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
    [self performSegueWithIdentifier:@"Sing In" sender:self];
}

-(void)authenticationAccount
{
    NSMutableDictionary *jsonData =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                _txtEmail.text,@"userEmail",
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
                                    _txtEmail.text,@"userEmail",nil];
    
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
          NSLog(@"Error : %@",error);
        }
        ];
    [op start];
}

-(void)dismissAlertView:(UIAlertView *)alertView{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}

-(Boolean)validation
{
    if([_txtEmail.text isEqual:@""] || [_txtPassword.text isEqual:@""])
    {
        [self displayMsg:@"Please enter your email address & password." :@"Ok"];
        return FALSE;
    }
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    if(![emailTest evaluateWithObject:_txtEmail.text])
    {
        [self displayMsg:@"Enter proper email address." :@"Ok"];
        [_txtEmail becomeFirstResponder];
        return FALSE;
    }
    
    return TRUE;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Sing In"])
    {
        //ViewController *vc= (ViewController *)segue.destinationViewController;
    }
}


- (IBAction)btnForgotPassword:(id)sender {
}

- (IBAction)btnSingUp:(id)sender {
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //[textField resignFirstResponder];
    if(textField == _txtEmail)
    {
        [_txtPassword becomeFirstResponder];
    }
    else if(textField == _txtPassword)
    {
        [textField resignFirstResponder];
        [self btnSingIn:self];
    }
    return YES;
}

-(void) displayMsg :(NSString *)msg :(NSString *)cancleButtonText
{
    UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"Oops!" message:msg  delegate:self cancelButtonTitle:cancleButtonText otherButtonTitles: nil];
    
    [av show];
    
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
    //NSLog(@"%@",jsonData);
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
