//
//  WriteReviewViewController.m
//  The Essex Pass
//
//  Created by Paras Chodavadiya on 02/03/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import "WriteReviewViewController.h"
#import "Contant.h"
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"

@interface WriteReviewViewController ()
{
    int star;
}

@end

@implementation WriteReviewViewController
@synthesize Id,type,userReview;

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([userReview count] > 1) {
        _txtTitle.text=[userReview objectForKey:@"reviewTitle"];
        _txtDescription.text=[userReview objectForKey:@"reviewDescription"];
        star=[[userReview objectForKey:@"reviewRate"]integerValue];
        [self fillStar];
    }
    else
    {
        star=1;
    }
    
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == _txtTitle)
    {
        [_txtDescription becomeFirstResponder];
    }
    return true;
}


- (IBAction)btnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    //[[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnStar1:(id)sender {
    star=1;
    [self fillStar];
}

- (IBAction)btnStar2:(id)sender{
    star=2;
    [self fillStar];
}

- (IBAction)btnStar3:(id)sender{
    star=3;
    [self fillStar];
}

- (IBAction)btnStar4:(id)sender{
    star=4;
    [self fillStar];
}

- (IBAction)btnStar5:(id)sender{
    star=5;
    [self fillStar];
}

-(void)fillStar
{
    
    [_btnStar1 setImage:[UIImage imageNamed:@"icon_star_hover.png"] forState:UIControlStateNormal];
    [_btnStar2 setImage:[UIImage imageNamed:@"icon_star_hover.png"] forState:UIControlStateNormal];
    [_btnStar3 setImage:[UIImage imageNamed:@"icon_star_hover.png"] forState:UIControlStateNormal];
    [_btnStar4 setImage:[UIImage imageNamed:@"icon_star_hover.png"] forState:UIControlStateNormal];
    [_btnStar5 setImage:[UIImage imageNamed:@"icon_star_hover.png"] forState:UIControlStateNormal];
    
    switch (star) {
        case 1:
            [_btnStar1 setImage:[UIImage imageNamed:@"icon_star.png"] forState:UIControlStateNormal];
            break;
        case 2:
            [_btnStar1 setImage:[UIImage imageNamed:@"icon_star.png"] forState:UIControlStateNormal];
            [_btnStar2 setImage:[UIImage imageNamed:@"icon_star.png"] forState:UIControlStateNormal];
            break;
        case 3:
            [_btnStar1 setImage:[UIImage imageNamed:@"icon_star.png"] forState:UIControlStateNormal];
            [_btnStar2 setImage:[UIImage imageNamed:@"icon_star.png"] forState:UIControlStateNormal];
            [_btnStar3 setImage:[UIImage imageNamed:@"icon_star.png"] forState:UIControlStateNormal];
            break;
        case 4:
            [_btnStar1 setImage:[UIImage imageNamed:@"icon_star.png"] forState:UIControlStateNormal];
            [_btnStar2 setImage:[UIImage imageNamed:@"icon_star.png"] forState:UIControlStateNormal];
            [_btnStar3 setImage:[UIImage imageNamed:@"icon_star.png"] forState:UIControlStateNormal];
            [_btnStar4 setImage:[UIImage imageNamed:@"icon_star.png"] forState:UIControlStateNormal];
            break;
        case 5:
            [_btnStar1 setImage:[UIImage imageNamed:@"icon_star.png"] forState:UIControlStateNormal];
            [_btnStar2 setImage:[UIImage imageNamed:@"icon_star.png"] forState:UIControlStateNormal];
            [_btnStar3 setImage:[UIImage imageNamed:@"icon_star.png"] forState:UIControlStateNormal];
            [_btnStar4 setImage:[UIImage imageNamed:@"icon_star.png"] forState:UIControlStateNormal];
            [_btnStar5 setImage:[UIImage imageNamed:@"icon_star.png"] forState:UIControlStateNormal];
            break;
    }
}

- (IBAction)btnPost:(id)sender {
    
    NSString *url;
    NSMutableDictionary *userDetail=[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"];
    
    NSString *idName=[[NSString alloc]init];
    NSString *userEmail=[userDetail objectForKey:@"email"];
    
    if ([type isEqualToString:@"deal"])
    {
        url=WRITEREVIEWDEAL;
        idName=@"dealId";
    }
    else
    {
        idName=@"eventId";
        url=WRITEREVIEWEVENT;
    }    
    
    NSMutableDictionary *jsonData =[[NSMutableDictionary alloc]init];
                            
    [jsonData setObject:_txtTitle.text forKey:@"reviewTitle" ];
    [jsonData setObject:_txtDescription.text forKey:@"reviewDescription" ];
    [jsonData setObject:[NSString stringWithFormat:@"%d",star] forKey:@"reviewRate" ];
    [jsonData setObject:Id forKey:idName ];
    [jsonData setObject:userEmail forKey:@"userEmail" ];
    
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"Post Review...";
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:url]];
    
    AFHTTPRequestOperation *op = [manager POST:url parameters:jsonData constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    }
        success:^(AFHTTPRequestOperation *operation, id responseObject)
      {
          [hud hide:YES];
          //NSLog(@"%@",responseObject);
          if([[responseObject objectForKey:@"Result"]isEqualToString:@"True"])
          {
              UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Thank you for your review." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
              [alert show];
              
              [self.navigationController popViewControllerAnimated:YES];
          }
          else
          {
              UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Some Wrror Is Occure." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
              [alert show];
          }
          
      }
        failure:^(AFHTTPRequestOperation *operation, NSError *error)
      {
          [hud hide:YES];
          NSLog(@"%@",error);
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
