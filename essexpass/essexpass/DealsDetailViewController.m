//
//  DetailViewController.m
//  essexpass
//
//  Created by Paras Chodavadiya on 21/01/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import "DealsDetailViewController.h"
#import "Contant.h"
#import "ServiceCall.h"
#import "SubTabBarViewController.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"
#import "TasteCardViewController.h"
#import "EventBriteViewController.h"

@interface DealsDetailViewController ()
{
    NSMutableDictionary *userDetail;
    
    NSMutableArray *deal,*location;
    NSMutableDictionary *event_Detail;
    double latitude,longitude;
    NSString *dataAbout;
    CLLocationManager *locationManager;
}
@end

@implementation DealsDetailViewController
@synthesize eventId,eventbriteEventId;
@synthesize dealId,dealName,dealExpireDate,dealPlace,actualDeal;

- (void)viewDidLoad
{
    [super viewDidLoad];
//    SubTabBarViewController *tabBar = (SubTabBarViewController *)self.tabBarController;
//    
//    userDetail=[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"];
//    
//    locationManager = [[CLLocationManager alloc] init];
//    locationManager.delegate=self;
//    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    
//    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1)
//    {
//        // here you go with iOS 8
//        [locationManager requestAlwaysAuthorization];
//        [locationManager requestWhenInUseAuthorization];
//    }
//    
//    [locationManager startUpdatingLocation];
//    
//    
//    
//    if(tabBar.eventId > 0)
//    {
//        eventId=tabBar.eventId;
//        dataAbout=@"Event";
//        self.tabBarItem.image=[UIImage imageNamed:@"icon_event.png"];
//        self.tabBarItem.title=@"Event";
//        _lblTitle.text=@"Event";
//    }
//    else
//    {
//        dealId=tabBar.dealId;
//        dataAbout=@"Deal";
//        self.tabBarItem.image=[UIImage imageNamed:@"icon_deals.png"];
//        self.tabBarItem.title=@"Deals";
//        _lblTitle.text=@"Deals";
//        [_btnRegister setTitle:@"Use Pass" forState:UIControlStateNormal];
//    }
//    
//    //    if (ISIPHONE4) {
//    //        [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height+100)];
//    //        //_viewLocation.frame=CGRectMake(_viewLocation.frame.origin.x, _viewLocation.frame.origin.y, _viewLocation.frame.size.width, 198);
//    //    }
//    
//    [self retiriveData];
    
}

-(void)retiriveData
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"Loading...";
    NSString *ID =[[NSString alloc]init];
    
    if(eventId > 0)
    {
        ID=eventId;
    }
    else
    {
        ID=dealId;
    }
    
    NSString *email=[userDetail objectForKey:@"email"];
    
    NSMutableDictionary *jsonData =[NSMutableDictionary dictionaryWithObjectsAndKeys:ID,@"eventdealId",
                                    email,@"userEmail", nil];
    NSString *urlString = @"http://iblinfotechapn.com/essexpass/service/getdealbyid.php";
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    
    AFHTTPRequestOperation *op = [manager POST:urlString parameters:jsonData constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    }
                                       success:^(AFHTTPRequestOperation *operation, id responseObject)
                                  {
                                      [hud hide:YES];
                                      //NSLog(@"%@",responseObject);
                                      if([[responseObject objectForKey:@"Result"]isEqualToString:@"True"])
                                      {
                                          deal=[responseObject objectForKey:@"deal"];
                                          //NSLog(@"Deal....%@",deal);
                                          [self fillData];
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


//-(void)retiriveData
//{
//
//    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText=@"Loading...";
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSMutableDictionary *responce;
//        if(eventId > 0)
//        {
//            NSMutableDictionary *jsonDictionary =[NSMutableDictionary dictionaryWithObjectsAndKeys:eventId,@"eventdealId", nil];
//            ServiceCall *sc=[[ServiceCall alloc]init];
//            responce = [sc serviceCall:[NSString stringWithFormat:@"%@",GETEVENTBYID] :jsonDictionary];
//        }
//        else
//        {
//            NSMutableDictionary *jsonDictionary =[NSMutableDictionary dictionaryWithObjectsAndKeys:dealId,@"eventdealId", nil];
//            ServiceCall *sc=[[ServiceCall alloc]init];
//            responce = [sc serviceCall:[NSString stringWithFormat:@"%@",GETDEALBYID] :jsonDictionary];
//        }
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
    NSString *Isfavourite=[event_Detail objectForKey:@"Isfavourite"];
    _lblDiscount.text=[event_Detail objectForKey:@"discount"];
    _lblDescription1.text=[event_Detail objectForKey:@"description"];
    _lblDescription2.text=[event_Detail objectForKey:@"description2"];
    _lblStartDate.text=[event_Detail objectForKey:@"startDate"];
    _lblEndDate.text=[event_Detail objectForKey:@"endDate"];
    dealExpireDate=[event_Detail objectForKey:@"endDate"];
    _lblStartTime.text=[event_Detail objectForKey:@"startTime"];
    _lblEndTime.text=[event_Detail objectForKey:@"endTime"];
    _lblEventName.text=[event_Detail objectForKey:@"name"];
    dealName=[event_Detail objectForKey:@"name"];
    _lblOfferPrice.text=[event_Detail objectForKey:@"offerPrice"];
    _lblPrice.text=[event_Detail objectForKey:@"price"];
    _txtConditions.text=[event_Detail objectForKey:@"conditions"];
    NSString *address=[event_Detail objectForKey:@"address"];
    _lblAddress.text=address;
    _lblAddress.lineBreakMode = NSLineBreakByWordWrapping;
    _lblAddress.numberOfLines = 0;
    [_lblAddress sizeToFit];
    
    latitude=[[event_Detail objectForKey:@"latitude"]doubleValue];
    longitude=[[event_Detail objectForKey:@"longitude"]doubleValue];
    dealPlace=[event_Detail objectForKey:@"place"];
    eventbriteEventId=[event_Detail objectForKey:@"eventbriteEventId"];
    
    
#warning Changes
    NSString *temp=[event_Detail objectForKey:@"scheme"];
    NSArray *arrtemp=[temp componentsSeparatedByString:@"+"];
    NSString *person1=[arrtemp objectAtIndex:0];
    NSString *person2=[arrtemp objectAtIndex:1];
    
    actualDeal=[NSString stringWithFormat:@"%@for%@ or %@%% off",person1,person2,[event_Detail objectForKey:@"discount"]];
    
    //generate slash LABLE
    int noOfDigit=_lblPrice.text.length;
    _lblDesh.frame = CGRectMake(0, 0, 10*noOfDigit, 1);
    [_lblDesh setCenter:_lblPrice.center];
    
    //set start
    if([Isfavourite isEqual:@"1"])
    {
        [_btnStar setBackgroundImage:[UIImage imageNamed:@"icon_star_menu@2x.png"] forState:UIControlStateNormal];
    }
    
    NSString *basicurl = [event_Detail objectForKey:@"image"];
    
    NSString *url=[basicurl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, NSData *returnData)
     {
         [_indicator stopAnimating];
         //_ivEvent.image = [UIImage imageWithData:returnData];
         [UIView transitionWithView:_ivEvent
                           duration:0.5f
                            options:UIViewAnimationOptionTransitionCrossDissolve
                         animations:^{
                             _ivEvent.image = [UIImage imageWithData:returnData];
                         } completion:NULL];
         
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error.description);
     }];
    
    
    //set label of address
    float heightOfMap=(self.view.frame.size.height)-(_viewLocation.frame.origin.y+_lblAddress.frame.size.height+120);
    if (ISIPHONE4) {
        heightOfMap=130;
    }
    //NSLog(@"%f,%f,%f",self.view.frame.size.height,_viewLocation.frame.origin.y,_lblAddress.frame.size.height);
    _mvLocation.frame= CGRectMake(0, _lblAddress.frame.size.height+2, _mvLocation.frame.size.width,heightOfMap);
    _viewLocation.frame=CGRectMake(_viewLocation.frame.origin.x, _viewLocation.frame.origin.y, _viewLocation.frame.size.width, _lblAddress.frame.size.height+_mvLocation.frame.size.height);
    
    //    float heightOfScrollView=_viewLocation.frame.size.height+235;//235 for height of image and button
    //    _scrollView.frame=CGRectMake(_scrollView.frame.origin.x, _scrollView.frame.origin.y, _scrollView.frame.size.width, heightOfScrollView);
    
    float contentSize=_viewLocation.frame.origin.y+_viewLocation.frame.size.height;
    if (ISIPHONE4) {
        contentSize=contentSize+30;
    }
    [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, contentSize)];
    
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
    _btnDetails.backgroundColor=[UIColor lightGrayColor];
    _btnLocation.backgroundColor=[UIColor lightGrayColor];
    _btnContact.backgroundColor=[UIColor lightGrayColor];
    _btnConditions.backgroundColor=[UIColor lightGrayColor];
    
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


-(void)fav
{
    
    NSString *ID =[[NSString alloc]init];
    
    if(eventId > 0)
    {
        ID=eventId;
    }
    else
    {
        ID=dealId;
    }
    
    NSString *email=[userDetail objectForKey:@"email"];
    NSMutableDictionary *jsonData =[NSMutableDictionary dictionaryWithObjectsAndKeys:ID,@"eventdealId",
                                    email,@"userEmail", nil];
    NSString *urlString = @"http://iblinfotechapn.com/essexpass/service/addfavourite.php";
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    
    AFHTTPRequestOperation *op = [manager POST:urlString parameters:jsonData constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
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
    if(eventId > 0)
    {
        if ([eventbriteEventId isEqualToString:@"0"])
            [self performSegueWithIdentifier:@"Payment" sender:self];
        else
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
    }
    else if ([[segue identifier] isEqualToString:@"Payment"])
    {
        
    }
    else if ([[segue identifier] isEqualToString:@"EventBrite"])
    {
        EventbriteViewController *eventbrite=(EventbriteViewController *)segue.destinationViewController;
        eventbrite.eventbriteEventId=eventbriteEventId;
    }
}

@end
