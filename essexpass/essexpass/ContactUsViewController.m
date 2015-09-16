//
//  ContactUsViewController.m
//  The Essex Pass
//
//  Created by Paras Chodavadiya on 30/01/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import "ContactUsViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"
#import "ServiceCall.h"
#import "Contant.h"

@interface ContactUsViewController ()

@end

@implementation ContactUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

-(void)hideKeyboard:(id)sender
{
    [self.view endEditing:YES];
}

- (IBAction)btnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (_txtMobileNumber == textField) {
        [_txtMessage becomeFirstResponder];
        return NO;
    }
    
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        //[textField resignFirstResponder];
        [self hideKeyboard:self];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}



-(BOOL)validation
{
    if([_txtEmail.text isEqual:@""] ||  [_txtMobileNumber.text isEqual:@"" ] || [_txtname.text isEqual:@""] ||  [_txtMessage.text isEqual:@"" ])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:  @"all field Require" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert setTag:1];
        return false;
    }
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    if(![emailTest evaluateWithObject:_txtEmail.text])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:  @"Enter proper email address." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert setTag:1];
        [_txtEmail becomeFirstResponder];
        return FALSE;
    }
    
    return true;
}

- (IBAction)btnSend:(id)sender {
    
    if (![self validation]) {
        return;
    }
    
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"Sending Message...";
    
    NSMutableDictionary *jsonData = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      _txtEmail.text,@"email",
                                      _txtname.text,@"name",
                                      _txtMessage.text,@"message",
                                      _txtMobileNumber.text,@"mobileNo",
                                      nil];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:CONTACTUS]];
    
    AFHTTPRequestOperation *op = [manager POST:CONTACTUS parameters:jsonData constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    }
               success:^(AFHTTPRequestOperation *operation, id responseObject)
          {
              [hud hide:YES];
              //NSLog(@"%@",responseObject);
              if([[responseObject objectForKey:@"Result"]isEqualToString:@"True"])
              {
                  UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Sucessfully" message: @"Message has been sent."delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                  [alert setTag:2];
                  [alert show];
              }
              else
              {
                  UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Message could not be sent." delegate:self cancelButtonTitle:@"Try again" otherButtonTitles:nil, nil];
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
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSMutableDictionary *jsonDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                               _txtEmail.text,@"email",
//                                               _txtname.text,@"name",
//                                               _txtMessage.text,@"message",
//                                               _txtMobileNumber.text,@"mobileNo",
//                                               nil];
//        
//        ServiceCall *sc=[[ServiceCall alloc]init];
//        NSMutableDictionary *responce = [sc serviceCall:[NSString stringWithFormat:@"%@",ContactUs] :jsonDictionary];
//        
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [hud hide:YES];
//            NSString *status = [responce objectForKey:@"ResponseCode"];
//            if ([status isEqualToString:@"1"])
//            {
//                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message: @"Message has been sent."delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//                [alert setTag:2];
//                [alert show];
//                
//            }
//            else
//            {
//                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Message could not be sent." delegate:self cancelButtonTitle:@"Try again" otherButtonTitles:nil, nil];
//                [alert show];
//            }
//        });
//    });
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 2)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
