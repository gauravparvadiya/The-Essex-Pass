//
//  SubDealsViewController.m
//  essexpass
//
//  Created by Paras Chodavadiya on 10/01/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import "SubDealsViewController.h"
#import "Contant.h"
#import "ServiceCall.h"
#import "SubTabBarViewController.h"
#import "MBProgressHUD.h"

@interface SubDealsViewController ()
{
    NSMutableArray *deal,*location;
    NSMutableDictionary *event_Detail;
    double latitude,longitude;
}
@end

@implementation SubDealsViewController
@synthesize eventId;

- (void)viewDidLoad
{
    [super viewDidLoad];
    SubTabBarViewController *tabBar = (SubTabBarViewController *)self.tabBarController;
    eventId=tabBar.eventId;
    //NSLog(@"Selected EventId : %@",eventId);
    //[self retiriveData];
    
}

//-(void)retiriveData
//{
//    
//    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText=@"Loading...";
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//
//        NSMutableDictionary *jsonDictionary =[NSMutableDictionary dictionaryWithObjectsAndKeys:eventId,@"eventId", nil];
//        
//        ServiceCall *sc=[[ServiceCall alloc]init];
//        NSMutableDictionary *responce = [sc serviceCall:[NSString stringWithFormat:@"%@",GETEVENTBYID] :jsonDictionary];
//        //NSLog(@"Responce : %@",responce);
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [hud hide:YES];
//            NSString *status = [responce objectForKey:@"ResponseCode"];
//            
//            if ([status isEqualToString:@"1"])
//            {
//                deal=[responce objectForKey:@"deal"];
//                //NSLog(@"Deal....%@",deal);
//                location=[responce objectForKey:@"location"];
//                [self fillData];
//            }
//            else
//            {
//                
//            }
//        });
//
//    });
//    
//}

-(void)fillData
{
    event_Detail=[deal objectAtIndex:0];
    //NSLog(@"%@",event_Detail);
    
    _lblDiscount.text=[event_Detail objectForKey:@"discount"];
    _lblDescription1.text=[event_Detail objectForKey:@"eventDescription"];
    _lblDescription2.text=[event_Detail objectForKey:@"eventDescription2"];
    _lblTime.text=[event_Detail objectForKey:@"eventExpireTime"];
    _lblEventName.text=[event_Detail objectForKey:@"eventName"];
    _lblOfferPrice.text=[event_Detail objectForKey:@"offerPrice"];
    _lblPrice.text=[event_Detail objectForKey:@"price"];
    _txtConditions.text=[event_Detail objectForKey:@"condition"];
    //_txtAddress.text=@"fdjopifdsjopiiodsjf oij oijtorijoirjoigjoifgdj oijoitrjoijoigjoidfsjoidfsjoifgj\nhuidfshuihfdsuihdfsuihuidfshuihuiwr\naiuhuifhudfsi\nuhidfsuihdf";

    //generate slash LABLE
    int noOfDigit=_lblPrice.text.length;
    int lableLength=13*noOfDigit;
    int lableYPosition=_lblDesh.frame.origin.y;
    int lableXPosition=_lblPrice.frame.origin.x+(_lblPrice.frame.size.width/2)-(lableLength/2);    
    _lblDesh.frame=CGRectMake(lableXPosition, lableYPosition, lableLength, 1.0);
    
    
    NSString *basicurl = [event_Detail objectForKey:@"image"];
    NSString *url=[basicurl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    //NSLog(@"Image : %@",url);
    NSURL *imageURL = [NSURL URLWithString:url];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_indicator stopAnimating];
            _ivEvent.image = [UIImage imageWithData:imageData];
        });
    });
    
    event_Detail=[location objectAtIndex:0];
    latitude=[[event_Detail objectForKey:@"latitude"]doubleValue];
    longitude=[[event_Detail objectForKey:@"longitude"]doubleValue];

//    CLLocationCoordinate2D coord = {.latitude =  latitude, .longitude =  longitude};
//    MKCoordinateSpan span = {.latitudeDelta =  0.008, .longitudeDelta =  0.008};
//    MKCoordinateRegion region = {coord, span};
//    
//    [_mvLocation setRegion:region];
//    
//    MKCoordinateRegion adjustedRegion;
//    
//    adjustedRegion.span.latitudeDelta = 0.05;
//    adjustedRegion.span.longitudeDelta = 0.05;
//    adjustedRegion.center = _mvLocation.userLocation.coordinate;
    
    
    
    MKPointAnnotation *eventAnnotation = [[MKPointAnnotation alloc]init];
    
    CLLocationCoordinate2D pinCoordinate;
    pinCoordinate.latitude = latitude;
    pinCoordinate.longitude = longitude;
    
    MKCoordinateSpan span = {.latitudeDelta =  0.01, .longitudeDelta =  0.01};
    MKCoordinateRegion region = {pinCoordinate, span};
    
    eventAnnotation.coordinate = pinCoordinate;
    
    [_mvLocation setRegion:region];
    [_mvLocation addAnnotation:eventAnnotation];
}

-(void)buttonEffect:(id)sender
{
    _btnDetails.backgroundColor=[UIColor colorWithWhite:0.0/255.0 alpha:0.0];
    _btnLocation.backgroundColor=[UIColor colorWithWhite:0.0/255.0 alpha:0.0];
    _btnContact.backgroundColor=[UIColor colorWithWhite:0.0/255.0 alpha:0.0];
    _btnConditions.backgroundColor=[UIColor colorWithWhite:0.0/255.0 alpha:0.0];
    
    [_btnDetails setTitleColor:[UIColor colorWithRed:24.0/255.0 green:40.0/255.0 blue:83.0/255.0 alpha:1.0]forState:UIControlStateNormal];
    [_btnLocation setTitleColor:[UIColor colorWithRed:24.0/255.0 green:40.0/255.0 blue:83.0/255.0 alpha:1.0]forState:UIControlStateNormal];
    [_btnContact setTitleColor:[UIColor colorWithRed:24.0/255.0 green:40.0/255.0 blue:83.0/255.0 alpha:1.0]forState:UIControlStateNormal];
    [_btnConditions setTitleColor:[UIColor colorWithRed:24.0/255.0 green:40.0/255.0 blue:83.0/255.0 alpha:1.0]forState:UIControlStateNormal];
    
    
    [sender setBackgroundColor:[UIColor colorWithRed:24.0/255.0 green:40.0/255.0 blue:83.0/255.0 alpha:1.0]];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

-(void)displayView
{
    _viewDetails.hidden=true;
    _viewLocation.hidden=true;
    _viewContact.hidden=true;
    _viewConditions.hidden=true;
}
- (IBAction)btnDetails:(id)sender {
    [self buttonEffect:sender];
    [self displayView];
    _viewDetails.hidden=false;
}
- (IBAction)btnLocation:(id)sender {
    [self buttonEffect:sender];
    [self displayView];
    
    _viewLocation.hidden=false;
}
- (IBAction)btnContact:(id)sender {
    [self buttonEffect:sender];
    [self displayView];
    _viewContact.hidden=false;
}
- (IBAction)btnConditions:(id)sender {
    [self buttonEffect:sender];
    [self displayView];
    _viewConditions.hidden=false;
}
- (IBAction)btnBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
