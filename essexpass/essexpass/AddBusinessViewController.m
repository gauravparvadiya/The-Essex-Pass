//
//  AddBusinessViewController.m
//  The Essex Pass
//
//  Created by Paras Chodavadiya on 23/05/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import "AddBusinessViewController.h"
#import "Contant.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"

@interface AddBusinessViewController ()
{
    NSMutableDictionary *venusDetail;
}
@end

@implementation AddBusinessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    venusDetail =[[NSMutableDictionary alloc]init];
    venusDetail=[_businessDetail objectForKey:@"venue"];
    _txtPlaceName.text=[venusDetail objectForKey:@"name"];
    
    NSString *address=[[NSString alloc]init];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    dict=[venusDetail objectForKey:@"location"];
    
    for (int i=0; i<[[dict objectForKey:@"formattedAddress" ] count]; i++)
    {
        if (i == 0)
        {
            address=[NSString stringWithFormat:@"%@",[[dict objectForKey:@"formattedAddress"] objectAtIndex:i]];
        }
        else
        {
            address=[NSString stringWithFormat:@"%@, %@",address,[[dict objectForKey:@"formattedAddress"] objectAtIndex:i]];
        }
        
    }
    _txtLocation.text=address;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)btnAdd:(id)sender
{
    if([_txtPlaceName.text isEqual:@""] ||  [_txtLocation.text isEqual:@"" ] || [_txtAbout.text isEqual:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:  @"Please complete all fields." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert setTag:1];
        return;
    }
    
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Thank You" message: @"Thank you for taking the time to recommend a local business. We love supporting independent businesses and will now get in touch with them to see if we can get you a deal !"delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
//    [alert setTag:2];
//    [alert show];
//    [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:2];
//    
//    [self.navigationController popViewControllerAnimated:YES];
    
    
    
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"Loading...";
    
    NSMutableDictionary *userDetail=[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"];
    
    NSMutableDictionary *jsonData = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     _txtPlaceName.text,@"placeName",
                                     _txtLocation.text,@"location",
                                     _txtAbout.text,@"about",
                                     [userDetail objectForKey:@"userName"],@"userName",
                                     [userDetail objectForKey:@"email"],@"userEmail",
                                     nil];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:RECOMMENDEDBUSINESS]];
    
    AFHTTPRequestOperation *op = [manager POST:RECOMMENDEDBUSINESS parameters:jsonData constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    }
        success:^(AFHTTPRequestOperation *operation, id responseObject)
        {
            [hud hide:YES];
            //NSLog(@"%@",responseObject);
            if([[responseObject objectForKey:@"Result"]isEqualToString:@"True"])
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Thank You" message: @"Thank you for taking the time to recommend a local business. We love supporting independent businesses and will now get in touch with them to see if we can get you a deal !"delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert setTag:2];
                [alert show];
                [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:2];
            }
            else
            {
              UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Not properly recommend business." delegate:self cancelButtonTitle:@"Try again" otherButtonTitles:nil, nil];
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

-(void)dismissAlertView:(UIAlertView *)alertView
{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
