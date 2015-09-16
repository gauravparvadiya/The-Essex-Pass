//
//  TasteCardViewController.m
//  essexpass
//
//  Created by Paras Chodavadiya on 18/01/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import "TasteCardViewController.h"
#import "AFHTTPRequestOperationManager.h"
//#import "MBProgressHUD.h"
#import "ServiceCall.h"
#import "Contant.h"
#import "LoyaltyCardViewController.h"

@interface TasteCardViewController ()
{
    NSMutableDictionary *userDetail;
    NSMutableDictionary *MemberDetail;
    NSString *No;
}
@end

@implementation TasteCardViewController
@synthesize dealId,dealName,dealCreateDate,dealPlace,actualDeal;
@synthesize loyalty;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    userDetail=[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"];
    
    [self setView];

};

-(void)viewWillAppear:(BOOL)animated
{
    No=@"";
    [self CheckMember];
    //[self getCountForLoyaltyCard];
    
}

-(void)setView
{
    //[_viewCard setCenter:self.view.center];
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
-(void)CheckMember
{
//    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText=@"Please Wait...";
    NSString *userEmail=[userDetail objectForKey:@"email"];
    
    NSMutableDictionary *jsonData =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    userEmail,@"userEmail", nil];
   
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:CHECKMEMBER]];
    
    AFHTTPRequestOperation *op = [manager POST:CHECKMEMBER parameters:jsonData constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {}
        success:^(AFHTTPRequestOperation *operation, id responseObject)
      {
          
          NSMutableArray *detail=[responseObject objectForKey:@"detail"];
          MemberDetail=[detail objectAtIndex:0];
          
          
          if([[responseObject objectForKey:@"Result"]isEqualToString:@"True"])
          {
              _viewMessage.hidden=true;
              _btnUpgrade.hidden=true;
          }
          else
          {
              if ([_discount integerValue] <= 10)
              {
                  //_btnUpgrade.hidden=false;
                  _viewMessage.hidden=true;
              }
              else
              {
                  _viewMessage.hidden=false;
                  _btnUpgrade.hidden=false;
                  No=@"Card is not valid";
              }
          }
          
          [self setDesignForHeader];
          [self generateCard];
          
      }
        failure:^(AFHTTPRequestOperation *operation, NSError *error)
      {
          //[hud hide:YES];
          NSLog(@"Error : %@",error);
      }
      ];
    [op start];
}

-(void)getCountForLoyaltyCard
{

    NSString *userEmail=[userDetail objectForKey:@"email"];
    
    NSMutableDictionary *jsonData =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    userEmail,@"userEmail",
                                    dealId,@"dealId",nil];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:CHECKSCHEME]];
    
    AFHTTPRequestOperation *op = [manager POST:CHECKSCHEME parameters:jsonData constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {}
        success:^(AFHTTPRequestOperation *operation, id responseObject)
        {
            if([[responseObject objectForKey:@"Result"]isEqualToString:@"True"])
            {
              //NSLog(@"%@",responseObject);
              //countForScanned=[[responseObject objectForKey:@"countScheme"]integerValue];
            }
//            
//            flagForBothService ++;
//            if (flagForBothService == 2)
//            {
                //[hud hide:YES];
                [self generateCard];
//            }
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
            //[hud hide:YES];
            NSLog(@"Error : %@",error);
        }
        ];
    [op start];
    
}

-(void)setDesignForHeader
{
    if ([loyalty count] == 0)
    {
        _btnHeart.hidden=true;
    }
    else
    {
        _btnHeart.hidden=false;
    }
    
    
    
    float widthOfMainView=self.view.frame.size.width;
    
    if (!_btnUpgrade.isHidden && !_btnHeart.isHidden)
    {
        _lblTitle.frame=CGRectMake(52.0, 31.0, 149.0, 21.0);
    }
    else if (!_btnUpgrade.isHidden && _btnHeart.isHidden)
    {
        
    }
    else if (_btnUpgrade.isHidden && !_btnHeart.isHidden)
    {
        _btnHeart.frame=CGRectMake(widthOfMainView-8-35, _btnHeart.frame.origin.y, _btnHeart.frame.size.width, _btnHeart.frame.size.height);
    }

}

-(void)generateCard
{
    
    if ([No isEqualToString:@"Card is not valid"])
    {
        
    }
    else
    {
        No = [NSString stringWithFormat:@"%@,%@,%@,%@,%@",[userDetail objectForKey:@"userName"],[userDetail objectForKey:@"email"],[MemberDetail objectForKey:@"id"],[MemberDetail objectForKey:@"endDate"],dealId];
    }
    
    _lblMembershipNumber.text=[MemberDetail objectForKey:@"id"];
    _lblMembershipName.text=[userDetail objectForKey:@"userName"];
    _lblDealSelected.text=actualDeal;
    _lblBussinessName.text=dealPlace;
    
    _lblBussinessName.lineBreakMode = NSLineBreakByWordWrapping;
    _lblBussinessName.numberOfLines = 0;
    [_lblBussinessName sizeToFit];
    
    if(_lblBussinessName.frame.size.width < _lblDealSelected.frame.size.width)
        _lblBussinessName.frame=CGRectMake(_lblBussinessName.frame.origin.x, _lblBussinessName.frame.origin.y, _lblDealSelected.frame.size.width, _lblBussinessName.frame.size.height);
    
    _lblExpiryDate.text=[MemberDetail objectForKey:@"endDate"];//expireDate;
    
    [self GenrateBarcode ];
}

#pragma mark Barcode
- (void)GenrateBarcode
{
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
   // NSLog(@"filterAttributes:%@", filter.attributes);
    
    [filter setDefaults];
    NSData *data = [No dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    
    CIImage *outputImage = [filter outputImage];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:outputImage
                                       fromRect:[outputImage extent]];
    
    UIImage *image = [UIImage imageWithCGImage:cgImage
                                         scale:1.
                                   orientation:UIImageOrientationUp];
    
    // Resize without interpolating
    UIImage *resized = [self resizeImage:image
                             withQuality:kCGInterpolationNone
                                    rate:15.0];
    
    _ivQRCode.image = resized;
    CGImageRelease(cgImage);
}

// =============================================================================
#pragma mark - Private

- (UIImage *)resizeImage:(UIImage *)image
             withQuality:(CGInterpolationQuality)quality
                    rate:(CGFloat)rate
{
    UIImage *resized = nil;
    CGFloat width = image.size.width * rate;
    CGFloat height = image.size.height * rate;
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, quality);
    [image drawInRect:CGRectMake(0, 0, width, height)];
    resized = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resized;
}


- (IBAction)btnBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnUpgrade:(id)sender {
}

- (IBAction)btnHeart:(id)sender
{
    [self performSegueWithIdentifier:@"Loyalty Card" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"Loyalty Card"])
    {
        LoyaltyCardViewController *lc = (LoyaltyCardViewController *)segue.destinationViewController;
        lc.dealId=dealId;
        lc.loyalty=loyalty;
        //lc.countForScanned=countForScanned;
//        lc.offerDescription=offerDescription;
//        lc.offerTime=offerTime;
    }
}


@end
