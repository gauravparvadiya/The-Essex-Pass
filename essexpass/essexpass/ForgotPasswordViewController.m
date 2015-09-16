//
//  ForgotPasswordViewController.m
//  essexpass
//
//  Created by Paras Chodavadiya on 06/01/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "ServiceCall.h"
#import "Contant.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"

@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)btnSubmit:(id)sender {
    
    Boolean valid = [self validation];
    
    if(!valid)
    {
        return;
    }
    
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"Forgot Password...";
    
    NSMutableDictionary *jsonData =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    _txtEmail.text,@"email"
                                    ,nil];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:FORGOTPASSWORD]];
    
    AFHTTPRequestOperation *op = [manager POST:FORGOTPASSWORD parameters:jsonData constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    }
           success:^(AFHTTPRequestOperation *operation, id responseObject)
      {
          [hud hide:YES];
          //NSLog(@"%@",responseObject);
          if([[responseObject objectForKey:@"Result"]isEqualToString:@"True"])
          {
              UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Your password has been sent to your registered email address." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
              [alert show];
              [self.navigationController popViewControllerAnimated:YES];
          }
          else
          {
              UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Username Not Found." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
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
    
//    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText=@"Loading...";
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//
//        NSMutableDictionary *jsonDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                           _txtEmail.text,@"email",
//                                           nil];
//    
//        ServiceCall *sc=[[ServiceCall alloc]init];
//        NSMutableDictionary *response = [sc serviceCall:[NSString stringWithFormat:@"%@",FORGOTPASSWORD] :jsonDictionary];
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [hud hide:YES];
//            NSString *status = [response objectForKey:@"ResponseCode"];
//            if ([status isEqualToString:@"1"])
//            {
//                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Your Password Is Sent Your Register Email." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//                [alert show];
//                [self performSegueWithIdentifier:@"Submit" sender:self];
//            }
//            else
//            {
//                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Username Name Not Found." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//                [alert show];
//            }
//        });
//    });
}

- (IBAction)btnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void) displayMsg :(NSString *)msg :(NSString *)cancleButtonText
{
    UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"Oops!" message:msg  delegate:self cancelButtonTitle:cancleButtonText otherButtonTitles: nil];
    
    [av show];
    
}

-(Boolean)validation
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    if(![emailTest evaluateWithObject:_txtEmail.text])
    {
        [self displayMsg:@"Enter Proper Email Address." :@"Ok"];
        [_txtEmail becomeFirstResponder];
        return FALSE;
    }
    
    return TRUE;
}

@end
