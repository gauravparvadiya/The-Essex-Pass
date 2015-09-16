//
//  ShippingAddressViewController.m
//  The Essex Pass
//
//  Created by Paras Chodavadiya on 05/08/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import "ShippingAddressViewController.h"
#import "Contant.h"

@interface ShippingAddressViewController ()

@end

@implementation ShippingAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_scrollView setContentSize:CGSizeMake(0.0, 390)];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

-(void)hideKeyboard:(id)sender
{
    [self.view endEditing:YES];
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Button
- (IBAction)btnSubmit:(id)sender
{
    if (![self validation]) {
        return;
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:@"submit" forKey:@"btnClicked"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    NSString *address=[NSString stringWithFormat:@"%@, %@, %@, %@, %@",_txtName.text,_txtAddressLine1.text,_txtAddressLine2.text,_txtTown.text,_txtPostCode.text];
    
    [[NSUserDefaults standardUserDefaults]setObject:address forKey:@"shippingAddress"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnCancel:(id)sender
{
    [[NSUserDefaults standardUserDefaults]setObject:@"cancel" forKey:@"btnClicked"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma TextField-TextView

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (ISIPHONE4)
    {
        if (textField == _txtTown) {
            [_scrollView setContentOffset:CGPointMake(0, 40)];
        }
        if (textField == _txtPostCode) {
            [_scrollView setContentOffset:CGPointMake(0, 90)];
        }
    }
    return true;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
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
    if([_txtName.text isEqual:@""] ||  [_txtAddressLine1.text isEqual:@"" ] || [_txtAddressLine2.text isEqual:@""] ||  [_txtPostCode.text isEqual:@"" ]||  [_txtTown.text isEqual:@"" ])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:  @"All fields Require" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert setTag:1];
        return false;
    }
    
    return true;
}
@end
