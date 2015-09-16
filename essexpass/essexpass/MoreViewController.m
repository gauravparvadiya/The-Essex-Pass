//
//  MoreViewController.m
//  essexpass
//
//  Created by Paras Chodavadiya on 29/01/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import "MoreViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "Contant.h"

@interface MoreViewController ()

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)btnLogout:(id)sender {

    UIAlertView *logoutAlert=[[UIAlertView alloc]initWithTitle:nil message:@"Are you sure want to logout ? " delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Logout", nil];
    
    [logoutAlert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [self registerDevice];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userDetail"];
        //[self.navigationController popToRootViewControllerAnimated:YES];
        [self performSegueWithIdentifier:@"Logout" sender:self];
    }
}

#pragma mark RegisterDevice
-(void)registerDevice
{
    NSMutableDictionary *userDetail=[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"];
    
    NSMutableDictionary *jsonData =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    @"123",@"deviceUdid",
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
