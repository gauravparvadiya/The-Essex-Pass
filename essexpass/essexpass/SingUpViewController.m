//
//  SingUpViewController.m
//  essexpass
//
//  Created by Paras Chodavadiya on 06/01/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import "SingUpViewController.h"
#import "TermsOfUseViewController.h"
#import "Contant.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"
#import "ServiceCall.h"
#import "ImageUploadViewController.h"

@interface SingUpViewController ()
{
    NSString *fullName,*email,*postCode,*mobileNo;
}
@end

@implementation SingUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(ISIPHONE4 || ISIPHONE5 )
        [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height+130)];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

//-(void)viewWillAppear:(BOOL)animated
//{
//    _txtFullName.text=fullName;
//    _txtEmail.text=email;
//    _txtMobileNo.text=mobileNo;
//    _txtPostCode.text=postCode;
//}

-(void)hideKeyboard:(id)sender
{
    //NSLog(@"hello...");
    [self.view endEditing:YES];
    
}
- (IBAction)btnSingIn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnSingUp:(id)sender {
    
    Boolean valid = [self validation];
    
    if(!valid)
    {
        return;
    }
    
    fullName=_txtFullName.text;
    email=_txtEmail.text;
    postCode=@"";
    mobileNo=_txtMobileNo.text;
    
    [self checkemail];
}

-(void)checkemail
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"Checking Email Address...";
    
    NSMutableDictionary *jsonData =[NSMutableDictionary dictionaryWithObjectsAndKeys:email,@"email", nil];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:CHECKEMAIL]];
    
        AFHTTPRequestOperation *op = [manager POST:CHECKEMAIL parameters:jsonData constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        }
        success:^(AFHTTPRequestOperation *operation, id responseObject)
            {
                [hud hide:YES];
                NSLog(@"%@",responseObject);
                if([[responseObject objectForKey:@"Result"]isEqualToString:@"True"])
                {
                    NSString *msg= [responseObject objectForKey:@"ResponseMsg"];
                    [self displayMsg:msg :@"Ok"];
                    [_txtEmail becomeFirstResponder];
                }
                else
                {
                    [self performSegueWithIdentifier:@"Sing Up" sender:self];
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


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == _txtFullName)
    {
        [_txtEmail becomeFirstResponder];
    }
    else if (textField == _txtEmail)
    {
        [_txtMobileNo becomeFirstResponder];
    }
    else if(textField == _txtMobileNo)
    {
        [_txtPassword becomeFirstResponder];
    }
    else if (textField == _txtPassword)
    {
        [_txtConfimPassword becomeFirstResponder];
    }
    else if (textField == _txtConfimPassword)
    {
        [textField resignFirstResponder];
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _txtConfimPassword)
    {
        if(ISIPHONE4)
        {
            [_scrollView setContentOffset:CGPointMake(0,65) animated:YES];
        }
        //        else if (ISIPHONE5)
        //        {
        //            [_scrollView setContentOffset:CGPointMake(0,_scrollView.frame.origin.y+30) animated:YES];
        //        }
    }
    if (textField == _txtPassword)
    {
        if(ISIPHONE4)
        {
            [_scrollView setContentOffset:CGPointMake(0,20) animated:YES];
        }
    }
    //    if (textField == _txtMobileNo)
    //    {
    //        if(ISIPHONE4)
    //        {
    //            [_scrollView setContentOffset:CGPointMake(0,_scrollView.frame.origin.y+30) animated:YES];
    //        }
    //    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Sing Up"])
    {
        ImageUploadViewController *iu = (ImageUploadViewController *)segue.destinationViewController;
        
        iu.fullName=fullName;
        iu.email=email;
        iu.postCode=postCode;
        iu.mobileNo=mobileNo;
        iu.password=_txtPassword.text;
    }
}

-(void) displayMsg :(NSString *)msg :(NSString *)cancleButtonText
{
    UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"Oops!" message:msg  delegate:self cancelButtonTitle:cancleButtonText otherButtonTitles: nil];
    
    [av show];
    
}

-(Boolean)validation
{
    if([_txtEmail.text isEqual:@""] || [_txtFullName.text isEqual:@""] || [_txtPassword.text isEqual:@""] || [_txtConfimPassword.text isEqual: @""] )
    {
        [self displayMsg:@"Please complete all fields." :@"Ok"];
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
    
//    NSString *passRegex = @"[A-Za-z]";
//    NSPredicate *passTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passRegex];
//    
//    if(![passTest evaluateWithObject:_txtPassword.text])
//    {
//        [self displayMsg:@"Enter proper pass address." :@"Opps"];
//        [_txtPassword becomeFirstResponder];
//        return FALSE;
//    }
    
    if(_txtPassword.text.length < 8 )
    {
        [self displayMsg:@"Your password must be at least 8 characters. one of them being a letter":@"Ok" ];
        [_txtPassword becomeFirstResponder];
        return FALSE;
    }
    
    BOOL isAnyCharacter=0;
    for (int i=0;i<[_txtPassword.text length] ; i++)
    {
        NSString *passRegex = @"[A-Za-z]";
        NSPredicate *passTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passRegex];
        
        if([passTest evaluateWithObject:[_txtPassword.text substringWithRange:NSMakeRange(i, 1)]])
        {
            isAnyCharacter=1;
            break;
        }
    }
    if (!isAnyCharacter)
    {
        [self displayMsg:@"In password one of them being a letter":@"Ok" ];
        [_txtPassword becomeFirstResponder];
        return FALSE;
    }

    if(![_txtPassword.text isEqual:_txtConfimPassword.text])
    {
        [self displayMsg:@"Confirm password is not match to password" :@"Ok" ];
        [_txtConfimPassword becomeFirstResponder];
        return FALSE;
    }
    
    
    return TRUE;
}

@end
