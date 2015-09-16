//
//  LoyaltyCardViewController.m
//  The Essex Pass
//
//  Created by Paras Chodavadiya on 26/05/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import "LoyaltyCardViewController.h"
#import "AFHTTPRequestOperationManager.h"
//#import "MBProgressHUD.h"
#import "Contant.h"

@interface LoyaltyCardViewController ()
{
    
}
@end

@implementation LoyaltyCardViewController
@synthesize countForScanned,loyalty;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setLayout];
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setLayout
{
//    if ([offerTime isEqualToString:@"5"])
//    {
//        _view1to5.frame=CGRectMake(0.0, 34.0, _view1to5.frame.size.width, _view1to5.frame.size.height);
//        _view6to10.hidden=true;
//    }
    
    [_viewCard setTransform:CGAffineTransformMakeRotation(M_PI_2)];
    int h=self.view.frame.size.height;
    h=h+60;
    int centerY=h/2;
    int centerOfCard=_viewCard.frame.size.height/2;
    _viewCard.frame=CGRectMake(_viewCard.frame.origin.x,centerY-centerOfCard , _viewCard.frame.size.width, _viewCard.frame.size.height);
    
    _viewMessage.layer.cornerRadius=8.0f;
    _viewMessage.layer.borderColor=[UIColor whiteColor].CGColor;
    _viewMessage.layer.borderWidth=1.0f;
}

#pragma mark GetData
-(void)getData
{
//    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText=@"Please Wait...";
    
    NSMutableDictionary *userDetail=[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"];
    NSString *userEmail=[userDetail objectForKey:@"email"];
    
    NSMutableDictionary *jsonData =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    userEmail,@"userEmail",
                                    _dealId,@"dealId",nil];
    
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:CHECKSCHEME]];
    
    AFHTTPRequestOperation *op = [manager POST:CHECKSCHEME parameters:jsonData constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {}
        success:^(AFHTTPRequestOperation *operation, id responseObject)
        {
           //[hud hide:YES];

            if([[responseObject objectForKey:@"Result"]isEqualToString:@"True"])
            {
                NSLog(@"%@",responseObject);
                countForScanned=[[responseObject objectForKey:@"countScheme"]integerValue];
                [self fillData];
            }
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
              //[hud hide:YES];
              NSLog(@"Error : %@",error);
        }
    ];
    [op start];

}

-(void)fillData
{
    for (int i=0; i<[loyalty count]; i++)
    {
        NSMutableDictionary *loyaltyDetail=[loyalty objectAtIndex:i];
        
        if (i == 0)
        {
            _lblMessage.text=[NSString stringWithFormat:@"%@ Stamps: %@",[loyaltyDetail objectForKey:@"offerTime"],[loyaltyDetail objectForKey:@"offerDescription"]];
        }
        else
        {
            _lblMessage.text=[NSString stringWithFormat:@"%@\n%@ Stamps: %@",_lblMessage.text,[loyaltyDetail objectForKey:@"offerTime"],[loyaltyDetail objectForKey:@"offerDescription"]];
        }
    }
    
    switch (countForScanned)
    {
        case 1:
            _iv1.image=[UIImage imageNamed:@"round_fill.png"];
            break;
        case 2:
            _iv1.image=[UIImage imageNamed:@"round_fill.png"];
            _iv2.image=[UIImage imageNamed:@"round_fill.png"];
            break;
        case 3:
            _iv1.image=[UIImage imageNamed:@"round_fill.png"];
            _iv2.image=[UIImage imageNamed:@"round_fill.png"];
            _iv3.image=[UIImage imageNamed:@"round_fill.png"];
            break;
        case 4:
            _iv1.image=[UIImage imageNamed:@"round_fill.png"];
            _iv2.image=[UIImage imageNamed:@"round_fill.png"];
            _iv3.image=[UIImage imageNamed:@"round_fill.png"];
            _iv4.image=[UIImage imageNamed:@"round_fill.png"];
            break;
        case 5:
            _iv1.image=[UIImage imageNamed:@"round_fill.png"];
            _iv2.image=[UIImage imageNamed:@"round_fill.png"];
            _iv3.image=[UIImage imageNamed:@"round_fill.png"];
            _iv4.image=[UIImage imageNamed:@"round_fill.png"];
            _iv5.image=[UIImage imageNamed:@"round_fill.png"];
            break;
        case 6:
            _iv1.image=[UIImage imageNamed:@"round_fill.png"];
            _iv2.image=[UIImage imageNamed:@"round_fill.png"];
            _iv3.image=[UIImage imageNamed:@"round_fill.png"];
            _iv4.image=[UIImage imageNamed:@"round_fill.png"];
            _iv5.image=[UIImage imageNamed:@"round_fill.png"];
            _iv6.image=[UIImage imageNamed:@"round_fill.png"];
            break;
        case 7:
            _iv1.image=[UIImage imageNamed:@"round_fill.png"];
            _iv2.image=[UIImage imageNamed:@"round_fill.png"];
            _iv3.image=[UIImage imageNamed:@"round_fill.png"];
            _iv4.image=[UIImage imageNamed:@"round_fill.png"];
            _iv5.image=[UIImage imageNamed:@"round_fill.png"];
            _iv6.image=[UIImage imageNamed:@"round_fill.png"];
            _iv7.image=[UIImage imageNamed:@"round_fill.png"];
            break;
        case 8:
            _iv1.image=[UIImage imageNamed:@"round_fill.png"];
            _iv2.image=[UIImage imageNamed:@"round_fill.png"];
            _iv3.image=[UIImage imageNamed:@"round_fill.png"];
            _iv4.image=[UIImage imageNamed:@"round_fill.png"];
            _iv5.image=[UIImage imageNamed:@"round_fill.png"];
            _iv6.image=[UIImage imageNamed:@"round_fill.png"];
            _iv7.image=[UIImage imageNamed:@"round_fill.png"];
            _iv8.image=[UIImage imageNamed:@"round_fill.png"];
            break;
        case 9:
            _iv1.image=[UIImage imageNamed:@"round_fill.png"];
            _iv2.image=[UIImage imageNamed:@"round_fill.png"];
            _iv3.image=[UIImage imageNamed:@"round_fill.png"];
            _iv4.image=[UIImage imageNamed:@"round_fill.png"];
            _iv5.image=[UIImage imageNamed:@"round_fill.png"];
            _iv6.image=[UIImage imageNamed:@"round_fill.png"];
            _iv7.image=[UIImage imageNamed:@"round_fill.png"];
            _iv8.image=[UIImage imageNamed:@"round_fill.png"];
            _iv9.image=[UIImage imageNamed:@"round_fill.png"];
            break;
        case 10:
            _iv1.image=[UIImage imageNamed:@"round_fill.png"];
            _iv2.image=[UIImage imageNamed:@"round_fill.png"];
            _iv3.image=[UIImage imageNamed:@"round_fill.png"];
            _iv4.image=[UIImage imageNamed:@"round_fill.png"];
            _iv5.image=[UIImage imageNamed:@"round_fill.png"];
            _iv6.image=[UIImage imageNamed:@"round_fill.png"];
            _iv7.image=[UIImage imageNamed:@"round_fill.png"];
            _iv8.image=[UIImage imageNamed:@"round_fill.png"];
            _iv9.image=[UIImage imageNamed:@"round_fill.png"];
            _iv10.image=[UIImage imageNamed:@"round_fill.png"];
            break;
            
        default:
            break;
    }
}

- (IBAction)btnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:true];
}
@end
