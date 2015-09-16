//
//  DetailViewController.m
//  essexpass
//
//  Created by Paras Chodavadiya on 21/01/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import "DetailViewController.h"
#import "Contant.h"
#import "ServiceCall.h"
#import "SubTabBarViewController.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"
#import "TasteCardViewController.h"
#import "EventBriteViewController.h"
#import "PaymentMethodViewController.h"
#import "WriteReviewViewController.h"
#import "ReviewTableViewCell.h"
#import "VideoViewController.h"
#import "LoadImage.h"
#import "FillRate.h"

@interface DetailViewController ()
{
    NSMutableDictionary *userDetail, *reviewDetail;
    
    NSMutableArray *deal,*location;
    NSMutableDictionary *event_Detail;
    double latitude,longitude;
    NSString *dataAbout;
    CLLocationManager *locationManager;
    NSString *mobileNo,*weburl,*email;
    SubTabBarViewController *tabBar;
    NSString *Id;
    NSMutableArray *review;
    NSMutableDictionary *userReview;
    float rate;
    NSString *videoLink;
    NSString *discount;
    LoadImage *image;
    FillRate *star;
}
@end

@implementation DetailViewController
@synthesize eventId,eventbriteEventId,eventDetail,headerDate;
@synthesize dealId,dealName,dealExpireDate,dealPlace,actualDeal,dealDetail;
@synthesize loyalty;

- (void)viewDidLoad
{
    [super viewDidLoad];
    tabBar = (SubTabBarViewController *)self.tabBarController;
    
    userDetail=[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"];
    
    review =[[NSMutableArray alloc]init];
    image=[[LoadImage alloc]init];
    star=[[FillRate alloc]init];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate=self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1)
    {
        // here you go with iOS 8
        [locationManager requestAlwaysAuthorization];
        [locationManager requestWhenInUseAuthorization];
    }
    
    [locationManager startUpdatingLocation];    
    
    
    if([tabBar.eventDetail count] > 0)
    {
        eventId=tabBar.eventId;
        eventDetail=tabBar.eventDetail;        
        headerDate=tabBar.headerDate;
        Id=[eventDetail objectForKey:@"eventId"];
        dataAbout=@"Event";
        self.tabBarItem.image=[UIImage imageNamed:@"icon_event.png"];
        self.tabBarItem.title=@"Event";
        _lblTitle.text=@"Event";
        [self fillEventData];
        [_viewDetailsDeal setHidden:true];
    }
    else
    {
        dealId=tabBar.dealId;
        dealDetail=tabBar.dealDetail;
        Id=[dealDetail objectForKey:@"dealId"];
        dataAbout=@"Deal";
        discount=@"100";
        self.tabBarItem.image=[UIImage imageNamed:@"icon_deals.png"];
        self.tabBarItem.title=@"Deals";
        _lblTitle.text=@"Deals";
        [self fillDealData];
        [_btnRegister setTitle:@"Use Pass" forState:UIControlStateNormal];
        [_viewDetails setHidden:true];
    }
    
//    if (ISIPHONE4) {
//        [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height+100)];
//        //_viewLocation.frame=CGRectMake(_viewLocation.frame.origin.x, _viewLocation.frame.origin.y, _viewLocation.frame.size.width, 198);
//    }
    
    _btnConditions.layer.borderColor=[UIColor grayColor].CGColor;
    _btnConditions.layer.borderWidth=1.0;
    _btnDetails.layer.borderColor=[UIColor grayColor].CGColor;
    _btnDetails.layer.borderWidth=1.0;
    _btnContact.layer.borderColor=[UIColor grayColor].CGColor;
    _btnContact.layer.borderWidth=1.0;
    _btnLocation.layer.borderColor=[UIColor grayColor].CGColor;
    _btnLocation.layer.borderWidth=1.0;
    
}

-(void)viewWillAppear:(BOOL)animated
{
//    if([tabBar.dealDetail count] > 0)
//    {
//        //[self fillDealData];
//        //[self checkMember];
//    }
//    else
//    {
//        //[self fillEventData];
//    }
    [self getReview];
}

-(void)fillDealData
{
    //[self checkMember];
    
    _lblBackOffer.layer.cornerRadius=30.0f;
    _lblBackOffer.layer.masksToBounds=YES;
    
    //NSLog(@"%@",dealDetail);
    
    //NSString *Isfavourite=[dealDetail objectForKey:@"Isfavourite"];
    Id=[dealDetail objectForKey:@"dealId"];
    _lblEventName.text=[dealDetail objectForKey:@"bussinessName"];
    dealPlace=[dealDetail objectForKey:@"bussinessName"];
    
    loyalty=[dealDetail objectForKey:@"loyalty"];
    
    _lblConditions.text=[dealDetail objectForKey:@"dealCondition"];
    _lblConditions.lineBreakMode = NSLineBreakByWordWrapping;
    _lblConditions.numberOfLines = 0;
    [_lblConditions sizeToFit];
  
    
    _lblBussinessDescription.text=[dealDetail objectForKey:@"bussinessDescription"];
    _lblBussinessDescription.lineBreakMode = NSLineBreakByWordWrapping;
    _lblBussinessDescription.numberOfLines = 0;
    [_lblBussinessDescription sizeToFit];
    
    //set start
    if([[dealDetail objectForKey:@"isFavourite"] isEqual:@"1"])
    {
        [_btnStar setBackgroundImage:[UIImage imageNamed:@"icon_star_menu@2x.png"] forState:UIControlStateNormal];
    }
    
    
    NSMutableArray *img = [[NSMutableArray alloc]init];
    
    if([[dealDetail objectForKey:@"isBooking"] isEqual:@"1"])
        [img addObject:@"call.png"];
    
    if([[dealDetail objectForKey:@"isFridayOff"] isEqual:@"1"])
        [img addObject:@"icon_fri_off.png"];
    
    if([[dealDetail objectForKey:@"isSaturdayOff"] isEqual:@"1"])
        [img addObject:@"icon_sat_off.png"];
    
    if([[dealDetail objectForKey:@"isDecemberOff"] isEqual:@"1"])
        [img addObject:@"icon_dec_off.png"];
    
    if([[dealDetail objectForKey:@"dealRestrictions"] isEqual:@"2"])
        [img addObject:@"icon_2.png"];
    else if([[dealDetail objectForKey:@"dealRestrictions"] isEqual:@"4"])
        [img addObject:@"icon_4.png"];
    else if([[dealDetail objectForKey:@"dealRestrictions"] isEqual:@"6"])
        [img addObject:@"icon_6.png"];
        if([[dealDetail objectForKey:@"deal"] containsString:@"2 for 1"])
    {
        [img addObject:@"241.png"];
        [_lblOffer setHidden:true];
        [_lblBackOffer setHidden:true];
        _lblDeal.text=[dealDetail objectForKey:@"deal"];
        actualDeal=@"2 for 1";
    }
    else if([[dealDetail objectForKey:@"deal"] containsString:@"50%"])
    {
        [img addObject:@"50percent.png"];
        [_lblOffer setHidden:true];
        [_lblBackOffer setHidden:true];
        _lblDeal.text=[dealDetail objectForKey:@"deal"];
        actualDeal=@"50% Off";
    }
    else if([[dealDetail objectForKey:@"deal"] containsString:@"%"])
    {
        NSArray *arrtemp=[[dealDetail objectForKey:@"deal"] componentsSeparatedByString:@"%"];
        
        
        if([[arrtemp objectAtIndex:0] length] == 1)
            discount=[[arrtemp objectAtIndex:0] substringFromIndex: [[arrtemp objectAtIndex:0] length] - 1];
        else
            discount=[[arrtemp objectAtIndex:0] substringFromIndex: [[arrtemp objectAtIndex:0] length] - 2];
        
        _lblOffer.text=[NSString stringWithFormat:@"%@%% Off",discount];
        actualDeal=[NSString stringWithFormat:@"%@%% Off",discount];
        
        [_lblOffer setHidden:false];
        [_lblBackOffer setHidden:false];
        _lblDeal.text=[dealDetail objectForKey:@"deal"];
    }

    else
    {
        _lblDeal.text=[dealDetail objectForKey:@"deal"];
        [_viewDeal setHidden:false];
        [_lblOffer setHidden:true];
        [_lblBackOffer setHidden:true];
    }
    
    for (int i=0;i<[img count];i++) {
        switch (i) {
            case 0:
                [_iv1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[img objectAtIndex:i]]]];
                break;
            case 1:
                [_iv2 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[img objectAtIndex:i]]]];
                break;
            case 2:
                [_iv3 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[img objectAtIndex:i]]]];
                break;
            case 3:
                [_iv4 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[img objectAtIndex:i]]]];
                break;
            case 4:
                [_iv5 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[img objectAtIndex:i]]]];
                break;
            case 5:
                [_iv6 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[img objectAtIndex:i]]]];
                break;
        }
    }
    
    //NSLog(@"%f",_viewBussinessDescription.frame.size.height+_viewDealConditions.frame.size.height);
    
    float height;
    if ([_viewDeal isHidden])
    {
        _viewDealConditions.frame=CGRectMake(_viewDealConditions.frame.origin.x,8, _viewDealConditions.frame.size.width,_viewDealConditions.frame.size.height+_lblConditions.frame.size.height);
        _viewBussinessDescription.frame=CGRectMake(_viewBussinessDescription.frame.origin.x, _viewDealConditions.frame.size.height+8, _viewBussinessDescription.frame.size.width, _lblBussinessDescription.frame.size.height+30);
        height=_viewBussinessDescription.frame.size.height+_viewDealConditions.frame.size.height;
    }
    else
    {
        
        //_viewDeal.frame=CGRectMake(8, 8, _viewDeal.frame.size.width,_viewDeal.frame.size.height);
        
        _viewDealConditions.frame=CGRectMake(_viewDealConditions.frame.origin.x, _viewDeal.frame.size.height+9, _viewDealConditions.frame.size.width,_viewDealConditions.frame.size.height+_lblConditions.frame.size.height);
        _viewBussinessDescription.frame=CGRectMake(_viewBussinessDescription.frame.origin.x, _viewDeal.frame.size.height+_viewDealConditions.frame.size.height+10, _viewBussinessDescription.frame.size.width, _lblBussinessDescription.frame.size.height+30);
        height=_viewDeal.frame.size.height+_viewBussinessDescription.frame.size.height+_viewDealConditions.frame.size.height+18;
    }
    
    if (height < self.view.frame.size.height-373) {
        height=self.view.frame.size.height-373;
    }
    _viewDetails.frame=CGRectMake(_viewDetails.frame.origin.x, _viewDetails.frame.origin.y, _viewDetails.frame.size.width, height);
    _viewConditions.frame=CGRectMake(_viewConditions.frame.origin.x, _viewConditions.frame.origin.y, _viewConditions.frame.size.width,height);
    _viewLocation.frame=CGRectMake(_viewLocation.frame.origin.x, _viewLocation.frame.origin.y, _viewLocation.frame.size.width, height);
    _viewContact.frame=CGRectMake(_viewContact.frame.origin.x, _viewContact.frame.origin.y, _viewContact.frame.size.width, height);
    
    [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, _viewDetails.frame.size.height+235)];
   
   
    dealExpireDate=[dealDetail objectForKey:@"createDate"];
    
    _lblAddress.text=[NSString stringWithFormat:@"%@, %@",[dealDetail objectForKey:@"street"],[dealDetail objectForKey:@"city"]];
//    _lblAddress.lineBreakMode = UILineBreakModeWordWrap;
//    _lblAddress.numberOfLines = 0;
//    [_lblAddress sizeToFit];
    
    latitude=[[dealDetail objectForKey:@"latitude"]doubleValue];
    longitude=[[dealDetail objectForKey:@"longitude"]doubleValue];
    
   
   
    NSString *basicurl = [dealDetail objectForKey:@"image"];
    [image loadImage:basicurl ImageView:_ivEvent ActivityIndicator:nil];
   
    
    //Contact Detail
    _lblContactName.hidden=true;
    _btnContactName.hidden=true;
    mobileNo=[dealDetail objectForKey:@"mobileNo"];
    _lblPhoneNumber.text=mobileNo;
    email=[dealDetail objectForKey:@"email"];
    _lblEmail.text=email;
    weburl=[dealDetail objectForKey:@"website"];
    _lblWebsite.text=weburl;
    
    _lblWebsite.lineBreakMode = NSLineBreakByWordWrapping;
    _lblWebsite.numberOfLines = 0;
    [_lblWebsite sizeToFit];
    
    if (_lblWebsite.frame.size.height < 35 ) {
        _lblWebsite.frame=CGRectMake(_lblWebsite.frame.origin.x, _lblWebsite.frame.origin.y, _lblWebsite.frame.size.width, 35);
    }
    
    //drop pin
    MKPointAnnotation *eventAnnotation = [[MKPointAnnotation alloc]init];
    
    CLLocationCoordinate2D pinCoordinate;
    pinCoordinate.latitude = latitude;
    pinCoordinate.longitude = longitude;
    
    MKCoordinateSpan span = {.latitudeDelta =  0.01, .longitudeDelta =  0.01};
    MKCoordinateRegion region = {pinCoordinate, span};
    
    eventAnnotation.coordinate = pinCoordinate;
    
    [_mvLocation setRegion:region];
    [_mvLocation addAnnotation:eventAnnotation];
    
    
    //fill rate
    rate=[[dealDetail objectForKey:@"rate"]integerValue];
    //[self fillStar];

}


-(void)fillEventData
{
    //NSLog(@"%@",eventDetail);
    Id=[eventDetail objectForKey:@"eventId"];
    NSString *Isfavourite=[eventDetail objectForKey:@"isFavourite"];
    _lblDiscount.text=[eventDetail objectForKey:@"discount"];
    //_txtDescription.text=[eventDetail objectForKey:@"eventDescription"];
    
    _lblDescription.text=[eventDetail objectForKey:@"eventDescription"];
    _lblDescription.lineBreakMode = NSLineBreakByWordWrapping;
    _lblDescription.numberOfLines = 0;
    [_lblDescription sizeToFit];    
    
    //Time
    
    _lblStartDate.text=headerDate;
    
    dealExpireDate=[eventDetail objectForKey:@"endDate"];
    _lblEventName.text=[eventDetail objectForKey:@"eventName"];
    dealName=[eventDetail objectForKey:@"eventName"];
    _lblOfferPrice.text=[eventDetail objectForKey:@"offerPrice"];
    
    if([[eventDetail objectForKey:@"price"] isEqualToString:@"0"] || [[eventDetail objectForKey:@"price"] isEqualToString:@""])
    {
        _lblPrice.text=[NSString stringWithFormat:@"FREE" ];
    }
    else
    {
        _lblPrice.text=[NSString stringWithFormat:@"£%@",[eventDetail objectForKey:@"price"]];
    }
    
    _lblCapacity.text=[NSString stringWithFormat:@"Capacity : %@",[eventDetail objectForKey:@"capacity"]];
    
    _lblPrice.adjustsFontSizeToFitWidth = YES;
    
    //set start
    if([[eventDetail objectForKey:@"isFavourite"] isEqual:@"1"])
    {
        [_btnStar setBackgroundImage:[UIImage imageNamed:@"icon_star_menu@2x.png"] forState:UIControlStateNormal];
    }
    
    //video
    videoLink=[eventDetail objectForKey:@"videoLink"];
    if ([videoLink length]> 0) {
        _viewVideo.hidden=false;
    }
    
    _lblAddress.text=[NSString stringWithFormat:@"%@, %@",[eventDetail objectForKey:@"street"],[eventDetail objectForKey:@"city"]];
//    _lblAddress.lineBreakMode = UILineBreakModeWordWrap;
//    _lblAddress.numberOfLines = 0;
//    [_lblAddress sizeToFit];
    
    latitude=[[eventDetail objectForKey:@"latitude"]doubleValue];
    longitude=[[eventDetail objectForKey:@"longitude"]doubleValue];
    
    eventbriteEventId=[eventDetail objectForKey:@"eventbriteId"];
    
//    if ([eventbriteEventId isEqualToString:@"0"] || [eventbriteEventId isEqualToString:@""])
//        [_btnRegister setHidden:true];
    
    //generate slash LABLE
    int noOfDigit=_lblPrice.text.length;
    _lblDesh.frame = CGRectMake(0, 0, 10*noOfDigit, 1);
    [_lblDesh setCenter:_lblPrice.center];
    
    //set start
    if([Isfavourite isEqual:@"1"])
    {
        [_btnStar setBackgroundImage:[UIImage imageNamed:@"icon_star_menu@2x.png"] forState:UIControlStateNormal];
    }
    
    NSString *basicurl = [eventDetail objectForKey:@"image"];
    [image loadImage:basicurl ImageView:_ivEvent ActivityIndicator:nil];
    
    
    //set size
    float height;
    _viewDescription.frame=CGRectMake(_viewDescription.frame.origin.x, _viewDescription.frame.origin.y, _viewDescription.frame.size.width, _lblDescription.frame.size.height+30);
    if ([eventbriteEventId isEqualToString:@"0"] || [eventbriteEventId isEqualToString:@""])
    {
        [_btnRegister setHidden:true];
        //height=_viewDescription.frame.size.height+_viewDescription.frame.origin.y+39;
        _scrollView.frame=CGRectMake(0, 60, _scrollView.frame.size.width, _scrollView.frame.size.height+29);
        _viewDescription.frame=CGRectMake(_viewDescription.frame.origin.x, _viewDescription.frame.origin.y, _viewDescription.frame.size.width, _lblDescription.frame.size.height+30+29);
        height=29+_viewDescription.frame.size.height+_viewDescription.frame.origin.y+10;
        if (height < self.view.frame.size.height-344) {
            height=self.view.frame.size.height-344;
        }
    }
    else
    {
        _viewDescription.frame=CGRectMake(_viewDescription.frame.origin.x, _viewDescription.frame.origin.y, _viewDescription.frame.size.width, _lblDescription.frame.size.height+30);
        height=_viewDescription.frame.size.height+_viewDescription.frame.origin.y+10;
        if (height < self.view.frame.size.height-373) {
            height=self.view.frame.size.height-373;
        }
    }
    //height=height+_viewDescription.frame.size.height+_viewDescription.frame.origin.y+10;
    
//    if (height < self.view.frame.size.height-373) {
//        height=self.view.frame.size.height-373;
//    }
    
    _viewDetails.frame=CGRectMake(_viewDetails.frame.origin.x, _viewDetails.frame.origin.y, _viewDetails.frame.size.width, height);
    _viewConditions.frame=CGRectMake(_viewConditions.frame.origin.x, _viewConditions.frame.origin.y, _viewConditions.frame.size.width,height);
    _viewLocation.frame=CGRectMake(_viewLocation.frame.origin.x, _viewLocation.frame.origin.y, _viewLocation.frame.size.width, height);
    _viewContact.frame=CGRectMake(_viewContact.frame.origin.x, _viewContact.frame.origin.y, _viewContact.frame.size.width, height);
    
    [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, _viewDetails.frame.size.height+235)];
    
    
    //Contact Detail
    _lblContactName.text=[eventDetail objectForKey:@"contactName"];
    mobileNo=[eventDetail objectForKey:@"mobileNo"];
    _lblPhoneNumber.text=mobileNo;
    email=[eventDetail objectForKey:@"email"];
    _lblEmail.text=email;
    weburl=[eventDetail objectForKey:@"website"];
    _lblWebsite.text=weburl;
    
    _lblWebsite.lineBreakMode = NSLineBreakByWordWrapping;
    _lblWebsite.numberOfLines = 0;
    [_lblWebsite sizeToFit];
    
    if (_lblWebsite.frame.size.height < 35 ) {
        _lblWebsite.frame=CGRectMake(_lblWebsite.frame.origin.x, _lblWebsite.frame.origin.y, _lblWebsite.frame.size.width, 35);
    }
    
    //drop pin
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


-(void)fillStar
{
    _ivStar1.image=[UIImage imageNamed:@"icon_star_hover@2x.png"];
    _ivStar2.image=[UIImage imageNamed:@"icon_star_hover@2x.png"];
    _ivStar3.image=[UIImage imageNamed:@"icon_star_hover@2x.png"];
    _ivStar4.image=[UIImage imageNamed:@"icon_star_hover@2x.png"];
    _ivStar5.image=[UIImage imageNamed:@"icon_star_hover@2x.png"];
    
    [star FillRate:rate FirstImageView:_ivStar1 SecondImageView:_ivStar2 ThirdImageView:_ivStar3 FourthImageView:_ivStar4 FifthImageView:_ivStar5];
}

//-(void)fillData
//{
//    event_Detail=[deal objectAtIndex:0];
//    //NSLog(@"%@",event_Detail);
//    NSString *Isfavourite=[event_Detail objectForKey:@"Isfavourite"];
//    _lblDiscount.text=[event_Detail objectForKey:@"discount"];
//    _lblDescription1.text=[event_Detail objectForKey:@"description"];
//    _lblDescription2.text=[event_Detail objectForKey:@"description2"];
//    _lblStartDate.text=[event_Detail objectForKey:@"startDate"];
//    _lblEndDate.text=[event_Detail objectForKey:@"endDate"];
//    dealExpireDate=[event_Detail objectForKey:@"endDate"];
//    _lblStartTime.text=[event_Detail objectForKey:@"startTime"];
//    _lblEndTime.text=[event_Detail objectForKey:@"endTime"];
//    _lblEventName.text=[event_Detail objectForKey:@"name"];
//    dealName=[event_Detail objectForKey:@"name"];
//    _lblOfferPrice.text=[event_Detail objectForKey:@"offerPrice"];
//    _lblPrice.text=[event_Detail objectForKey:@"price"];
//    _txtConditions.text=[event_Detail objectForKey:@"conditions"];
//    NSString *address=[event_Detail objectForKey:@"address"];
//    _lblAddress.text=address;
//    _lblAddress.lineBreakMode = UILineBreakModeWordWrap;
//    _lblAddress.numberOfLines = 0;
//    [_lblAddress sizeToFit];
//    
//    latitude=[[event_Detail objectForKey:@"latitude"]doubleValue];
//    longitude=[[event_Detail objectForKey:@"longitude"]doubleValue];
//    dealPlace=[event_Detail objectForKey:@"place"];
//        
//    eventbriteEventId=[event_Detail objectForKey:@"eventbriteEventId"];
//    
//    if ([eventbriteEventId isEqualToString:@"0"])
//        [_btnRegister setHidden:true];
//    
//    
//#warning Changes
//    NSString *temp=[event_Detail objectForKey:@"scheme"];
//    NSArray *arrtemp=[temp componentsSeparatedByString:@"+"];
//    NSString *person1=[arrtemp objectAtIndex:0];
//    NSString *person2=[arrtemp objectAtIndex:1];
//    
//    actualDeal=[NSString stringWithFormat:@"%@for%@ or %@%% off",person1,person2,[event_Detail objectForKey:@"discount"]];
//    
//    //generate slash LABLE
//    int noOfDigit=_lblPrice.text.length;
//    _lblDesh.frame = CGRectMake(0, 0, 10*noOfDigit, 1);
//    [_lblDesh setCenter:_lblPrice.center];
//    
//    //set start
//    if([Isfavourite isEqual:@"1"])
//    {
//        [_btnStar setBackgroundImage:[UIImage imageNamed:@"icon_star_menu@2x.png"] forState:UIControlStateNormal];
//    }
//    
//    NSString *basicurl = [event_Detail objectForKey:@"image"];
//    NSString *url=[basicurl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, NSData *returnData)
//     {
//         [_indicator stopAnimating];
//         _ivEvent.image = [UIImage imageWithData:returnData];
//
//     }
//         failure:^(AFHTTPRequestOperation *operation, NSError *error)
//     {
//         NSLog(@"Error: %@", error.description);
//     }];
//
//    
//    //set label of address
//    float heightOfMap=(self.view.frame.size.height)-(_viewLocation.frame.origin.y+_lblAddress.frame.size.height+120);
//    if (ISIPHONE4) {
//        heightOfMap=130;
//    }
//    //NSLog(@"%f,%f,%f",self.view.frame.size.height,_viewLocation.frame.origin.y,_lblAddress.frame.size.height);
//    _mvLocation.frame= CGRectMake(0, _lblAddress.frame.size.height+2, _mvLocation.frame.size.width,heightOfMap);
//    _viewLocation.frame=CGRectMake(_viewLocation.frame.origin.x, _viewLocation.frame.origin.y, _viewLocation.frame.size.width, _lblAddress.frame.size.height+_mvLocation.frame.size.height);
//    _viewDetails.frame=CGRectMake(_viewLocation.frame.origin.x, _viewLocation.frame.origin.y, _viewLocation.frame.size.width, _lblAddress.frame.size.height+_mvLocation.frame.size.height);
//    
//    
////    float heightOfScrollView=_viewLocation.frame.size.height+235;//235 for height of image and button
////    _scrollView.frame=CGRectMake(_scrollView.frame.origin.x, _scrollView.frame.origin.y, _scrollView.frame.size.width, heightOfScrollView);
//    
//    float contentSize=_viewLocation.frame.origin.y+_viewLocation.frame.size.height;
//    if (ISIPHONE4) {
//        contentSize=contentSize+30;
//    }
//    [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, contentSize)];
//    
//    //drop pin
//    MKPointAnnotation *eventAnnotation = [[MKPointAnnotation alloc]init];
//    
//    CLLocationCoordinate2D pinCoordinate;
//    pinCoordinate.latitude = latitude;
//    pinCoordinate.longitude = longitude;
//    
//    MKCoordinateSpan span = {.latitudeDelta =  0.01, .longitudeDelta =  0.01};
//    MKCoordinateRegion region = {pinCoordinate, span};
//    
//    eventAnnotation.coordinate = pinCoordinate;
//    
//    [_mvLocation setRegion:region];
//    [_mvLocation addAnnotation:eventAnnotation];
//}

//Convert address to latitude and longitude
- (CLLocationCoordinate2D) geoCodeUsingAddress:(NSString *)address
{
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\":" intoString:nil] && [scanner scanString:@"\"lat\":" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\":" intoString:nil] && [scanner scanString:@"\"lng\":" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    CLLocationCoordinate2D center;
    center.latitude = latitude;
    center.longitude = longitude;
    return center;
}


-(void)buttonEffect:(id)sender
{
    _btnDetails.backgroundColor=[UIColor colorWithRed:197.0/255.0 green:197.0/255.0 blue:197.0/255.0 alpha:1.0];
    _btnLocation.backgroundColor=[UIColor colorWithRed:197.0/255.0 green:197.0/255.0 blue:197.0/255.0 alpha:1.0];
    _btnContact.backgroundColor=[UIColor colorWithRed:197.0/255.0 green:197.0/255.0 blue:197.0/255.0 alpha:1.0];
    _btnConditions.backgroundColor=[UIColor colorWithRed:197.0/255.0 green:197.0/255.0 blue:197.0/255.0 alpha:1.0];
    
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
    _viewDetailsDeal.hidden=true;
    _viewLocation.hidden=true;
    _viewContact.hidden=true;
    _viewConditions.hidden=true;
}
- (IBAction)btnDetails:(id)sender {
    [self buttonEffect:sender];
    [self displayView];
    if ([eventDetail count] > 0) {
        _viewDetails.hidden=false;
    }
    else
    {
        _viewDetailsDeal.hidden=false;
    }
    
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
- (IBAction)btnStar:(id)sender {
    
    UIImage *imageFill= _btnStar.currentBackgroundImage;;
    UIImage *imageForCheck=[UIImage imageNamed: @"icon_star_menu@2x.png"];
    
    NSData *data1 = UIImagePNGRepresentation(imageFill);
    NSData *data2 = UIImagePNGRepresentation(imageForCheck);
    
    if([data1 isEqual:data2])
    {
        [_btnStar setBackgroundImage:[UIImage imageNamed:@"icon_star_hover_menu@2x"] forState:UIControlStateNormal];
    }
    else
    {
        [_btnStar setBackgroundImage:[UIImage imageNamed:@"icon_star_menu@2x.png"] forState:UIControlStateNormal];
    }
    [self fav];
}


- (IBAction)btnShare:(id)sender
{
    UIImage *img=_ivEvent.image;
    NSString *title = @"The Essex Pass";
    NSString *shareBody =[NSString stringWithFormat:@"Deal Name: %@\nDeal: %@\nAddress: %@",_lblEventName.text,_lblDeal.text,_lblAddress.text];
    
    // NSLog(@"%@",shareBody);
    NSArray *postItems = @[title,shareBody,img];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]
                                            initWithActivityItems:postItems
                                            applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePrint,UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll,UIActivityTypeAddToReadingList,UIActivityTypeAirDrop];

    
    [self presentViewController:activityVC animated:YES completion:nil];
}

-(void)fav
{
   
    NSString *ID =[[NSString alloc]init];
    NSString *type =[[NSString alloc]init];
    
    if([tabBar.eventDetail count] > 0)
    {
        ID=[eventDetail objectForKey:@"eventId"];
        type=@"event";
    }
    else
    {
        ID=[dealDetail objectForKey:@"dealId"];
        type=@"deal";
    }
    
    NSString *userEmail=[userDetail objectForKey:@"email"];
    
    NSMutableDictionary *jsonData =[NSMutableDictionary dictionaryWithObjectsAndKeys:ID,@"eventdealId",
                                    userEmail,@"userEmail",
                                    type,@"type",
                                    nil];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:ADDFAVOURITE]];
    
    AFHTTPRequestOperation *op = [manager POST:ADDFAVOURITE parameters:jsonData constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    }
                                       success:^(AFHTTPRequestOperation *operation, id responseObject)
                                  {
                                      //NSLog(@"%@",responseObject);
                                      if([[responseObject objectForKey:@"Result"]isEqualToString:@"True"])
                                      {
//                                          deal=[responseObject objectForKey:@"deal"];
//                                          NSLog(@"Deal....%@",deal);
//                                          [self fillData];
                                      }
                                      
                                  }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error)
                                  {
                                      NSLog(@"Error : %@",error);
                                  }
                                  ];
    [op start];
}


- (IBAction)btnRegister:(id)sender {
    if([eventDetail count] > 0)
    {
//        if ([eventbriteEventId isEqualToString:@"0"] )
//            [self performSegueWithIdentifier:@"Payment" sender:self];
//        else
            [self performSegueWithIdentifier:@"EventBrite" sender:self];
    }
    else
    {
        [self performSegueWithIdentifier:@"Card" sender:self];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Card"])
    {
        TasteCardViewController *tc = (TasteCardViewController *)segue.destinationViewController;
        tc.dealId=dealId;
        tc.dealName=dealName;
        tc.dealCreateDate=dealExpireDate;
        tc.dealPlace=dealPlace;
        tc.actualDeal=actualDeal;
        tc.discount=discount;
        tc.loyalty=loyalty;
        
    }
    else if ([[segue identifier] isEqualToString:@"Payment"])
    {
        PaymentMethodViewController *pay = (PaymentMethodViewController *)segue.destinationViewController;
        pay.dealId=dealId;
    }
    else if ([[segue identifier] isEqualToString:@"EventBrite"])
    {
        EventbriteViewController *eventbrite=(EventbriteViewController *)segue.destinationViewController;
        eventbrite.eventbriteEventId=eventbriteEventId;
    }
    else if ([[segue identifier] isEqualToString:@"WriteReview"])
    {
        WriteReviewViewController *wrvc=(WriteReviewViewController *)segue.destinationViewController;
        
        if([tabBar.eventDetail count] > 0)
        {
            wrvc.type=@"event";
        }
        else
        {
            wrvc.type=@"deal";
        }
        
        wrvc.Id=Id;
        wrvc.userReview=userReview;
        //[self presentViewController:wrvc animated:YES completion:nil];
    }
    else if([[segue identifier] isEqualToString:@"PlayVideo"])
    {
        VideoViewController *vvc=(VideoViewController *)segue.destinationViewController;
        vvc.videoLink=videoLink;
    }
}

- (IBAction)btnCall:(id)sender {

    NSString *phoneNo =[[NSString  stringWithFormat:@"tel:%@",mobileNo] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSURL* callUrl=[NSURL URLWithString:phoneNo];
    
    //check  Call Function available only in iphone
    if([[UIApplication sharedApplication] canOpenURL:callUrl])
    {
        [[UIApplication sharedApplication] openURL:callUrl];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"ALERT" message:@"This function is only available on the iPhone"  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
}
- (IBAction)btnWeb:(id)sender {
    NSURL *url = [NSURL URLWithString:weburl];
    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark Mail
- (IBAction)btnEmail:(id)sender
{   
   
   if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setSubject:@"The Essex Pass"];
        [mail setMessageBody:@"Hello, The Essex Pass" isHTML:NO];
        [mail setToRecipients:@[email]];
        
        [self presentViewController:mail animated:YES completion:NULL];
    }
    else
    {
        NSLog(@"This device cannot send email");
    }
}
    
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            //NSLog(@"You sent the email.");
            [self alert:@"Sent email successfully..."];
            break;
        case MFMailComposeResultSaved:
            //NSLog(@"You saved a draft of this email");
            [self alert:@"Saved a draft of mail successfully..."];
            break;
        case MFMailComposeResultCancelled:
            //NSLog(@"You cancelled sending this email.");
            [self alert:@"Cancelled sending email..."];
            break;
        case MFMailComposeResultFailed:
            //NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            [self alert:@"An error occurred when trying to compose mail..."];
            break;
        default:
            //NSLog(@"An error occurred when trying to compose this email");
            [self alert:@"An error occurred when trying to compose mail..."];
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)alert :(NSString *)message
{
    UIAlertView *alert =[[UIAlertView alloc]
                         initWithTitle:nil message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];
    [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:2];
}

-(void)dismissAlertView:(UIAlertView *)alertView{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}

-(void) getReview
{
    NSString *url;
    NSString *idName=[[NSString alloc]init];
    NSString *userEmail=[userDetail objectForKey:@"email"];
    
    if([tabBar.dealDetail count] > 0)
    {
        url=REVIEWDEAL;
        idName=@"dealId";
    }
    else
    {
        idName=@"eventId";
        url=REVIEWEVENT;
    }
    
    _viewIndicator.hidden=false;
    
    NSMutableDictionary *jsonData =[[NSMutableDictionary alloc]init];
    [jsonData setObject:Id forKey:idName ];
    [jsonData setObject:userEmail forKey:@"userEmail"];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:url]];
    
    AFHTTPRequestOperation *op = [manager POST:url parameters:jsonData constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    }
           success:^(AFHTTPRequestOperation *operation, id responseObject)
      {
          _viewIndicator.hidden=true;
          if([[responseObject objectForKey:@"Result"]isEqualToString:@"True"])
          {
              review=[responseObject objectForKey:@"reviewDetail"];
              rate=[[responseObject objectForKey:@"avrage"]floatValue];
              [self fillStar];
              
              if ([[responseObject objectForKey:@"userReview"] count] > 0 )
              {
                  userReview=[[responseObject objectForKey:@"userReview"] objectAtIndex:0];
                  
                  [_btnWriteReview setTitle:@"Update Review" forState:UIControlStateNormal];
              }
              [_tvReview reloadData];
          }
          else
          {
              
          }
          
      }
           failure:^(AFHTTPRequestOperation *operation, NSError *error)
      {
          NSLog(@"%@",error);
          _viewIndicator.hidden=true;
      }
      ];
    [op start];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if ([review count] > 5) {
//        return 5;
//    }
//    else
//    {
        return [review count];
//    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SimpleTableCell";
    
    ReviewTableViewCell *reviewCell = (ReviewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(reviewCell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ReviewTableViewCell" owner:self options:nil];
        reviewCell = [nib objectAtIndex:0];
    }
    
    reviewDetail=[review objectAtIndex:indexPath.row];
    
    reviewCell.lblUserName.text=[reviewDetail objectForKey:@"userName"];
    
    reviewCell.lblDate.text=[self convertTimeIntoLocal:[reviewDetail objectForKey:@"reviewDate"]];
    reviewCell.lblTitle.text=[reviewDetail objectForKey:@"reviewTitle"];
    reviewCell.lblDescription.text=[reviewDetail objectForKey:@"reviewDescription"];
    
    //for rate
    NSInteger rate=[[reviewDetail objectForKey:@"reviewRate"]integerValue];
    switch (rate) {
        case 1:
            reviewCell.ivStar1.image=[UIImage imageNamed:@"icon_star@2x.png"];
            break;
        case 2:
            reviewCell.ivStar1.image=[UIImage imageNamed:@"icon_star@2x.png"];
            reviewCell.ivStar2.image=[UIImage imageNamed:@"icon_star@2x.png"];
            break;
        case 3:
            reviewCell.ivStar1.image=[UIImage imageNamed:@"icon_star@2x.png"];
            reviewCell.ivStar2.image=[UIImage imageNamed:@"icon_star@2x.png"];
            reviewCell.ivStar3.image=[UIImage imageNamed:@"icon_star@2x.png"];
            break;
        case 4:
            reviewCell.ivStar1.image=[UIImage imageNamed:@"icon_star@2x.png"];
            reviewCell.ivStar2.image=[UIImage imageNamed:@"icon_star@2x.png"];
            reviewCell.ivStar3.image=[UIImage imageNamed:@"icon_star@2x.png"];
            reviewCell.ivStar4.image=[UIImage imageNamed:@"icon_star@2x.png"];
            break;
        case 5:
            reviewCell.ivStar1.image=[UIImage imageNamed:@"icon_star@2x.png"];
            reviewCell.ivStar2.image=[UIImage imageNamed:@"icon_star@2x.png"];
            reviewCell.ivStar3.image=[UIImage imageNamed:@"icon_star@2x.png"];
            reviewCell.ivStar4.image=[UIImage imageNamed:@"icon_star@2x.png"];
            reviewCell.ivStar5.image=[UIImage imageNamed:@"icon_star@2x.png"];
            break;
    }

    
    return reviewCell;
}

-(NSString *) countElapsedTime:(NSString*) oldTime
{
    NSDateFormatter *date1=[[NSDateFormatter alloc]init];
    [date1 setDateFormat:@"z"];
    NSDate *date2=[date1 dateFromString:oldTime];
    NSLog(@"%@",date2);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss "];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    //dateFromString = [[NSDate alloc] init];
    NSDate * dateFromString = [dateFormatter dateFromString:oldTime];
    
//    NSTimeZone *inputTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
//    NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
//    [inputDateFormatter setTimeZone:inputTimeZone];
//    [inputDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSTimeZone *outputTimeZone = [NSTimeZone localTimeZone];
    NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
    [outputDateFormatter setTimeZone:outputTimeZone];
    [outputDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *outputString = [outputDateFormatter stringFromDate:dateFromString];
    
//    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
//    [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
//    NSDate *newFinalDate = [dateFormatter2 dateFromString:outputString];
//    
//    NSString *finalDate=[NSString stringWithFormat:@"%@",newFinalDate];
    return outputString;
}

-(NSString *) convertTimeIntoLocal:(NSString *)defaultTime
{
    
    NSString *TimeZone=[[NSUserDefaults standardUserDefaults]objectForKey:@"ServerTimeZone"];
    
    NSDateFormatter *serverFormatter = [[NSDateFormatter alloc] init];
    [serverFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:TimeZone]];
    [serverFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *theDate = [serverFormatter dateFromString:defaultTime];
    
    NSDateFormatter *userFormatter = [[NSDateFormatter alloc] init];
    [userFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [userFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    NSString *dateConverted = [userFormatter stringFromDate:theDate];
    
    //NSLog(@"Local Time : %@",dateConverted);
    
    return dateConverted;
}


- (IBAction)btnWriteReview:(id)sender {
    
    [self performSegueWithIdentifier:@"WriteReview" sender:self];
}

@end
