//
//  NearMeViewController.m
//  essexpass
//
//  Created by Paras Chodavadiya on 13/01/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import "NearMeViewController.h"
#import "NearMeEventTableViewCell.h"
#import "MBProgressHUD.h"
#import "ServiceCall.h"
#import "Contant.h"
#import <CoreLocation/CoreLocation.h>
#import "AFHTTPRequestOperationManager.h"
#import "SubTabBarViewController.h"
#import "LoadImage.h"
#import "FillRate.h"
#import "ConvertDate.h"

//qtree
#import "QTree.h"
#import "QCluster.h"
#import "ClusterAnnotationView.h"
#import "CustomAnnotation.h"

@interface NearMeViewController ()
{
     NSMutableDictionary *userDetail;
    
    CLLocationManager *locationManager;
    NSMutableArray *data;
    NSMutableDictionary *eventDetail,*eventListDict;
    NSString *latitude,*longitude,*distance,*type;
    NSMutableArray *dateList;
    int countForLocation;//for countForLocation how many time method is call
    SubTabBarViewController *tabBar;
    //int noOfDeals,round;
    
    LoadImage *image;
    FillRate *star;
    ConvertDate *dateConvert;
    
    BOOL useClustering,isClickRefresh;
    NSString *selectedId,*headerDate;
}
@end

@implementation NearMeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    data = [[NSMutableArray alloc]init];
    tabBar = (SubTabBarViewController *)self.tabBarController;
   //round=1;
    useClustering=1;
    
    image=[[LoadImage alloc]init];
    star=[[FillRate alloc]init];
    dateConvert=[[ConvertDate alloc]init];
    
    if([tabBar.eventDetail count] > 0)
    {
        type=@"event";
    }
    else
    {
        type=@"deal";
    }
    
    distance=@"8.04672";
    countForLocation=1;
    
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
}

-(void)viewWillAppear:(BOOL)animated
{
    [_tvEventList reloadData];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations lastObject];
    
    latitude = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
    longitude = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
    
    //NSLog(@"Current latitude : %@  ,Current longitude : %@",latitude,longitude);
    // Turn off the location manager to save power.
    
    if(countForLocation == 1)
    {
        if([tabBar.eventDetail count] > 0)
        {
            [self retrivEventData];
        }
        else
        {
            [self retriveDealData];
        }
        [self setCircleToUserLocation];
        countForLocation++;
    }
    [manager stopUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *alertOfLocation=[[UIAlertView alloc]
                                  initWithTitle:@"User Location Error"
                                  message:@"The Essex Pass can't find your location. Please enable user location and give permision to access your location. Do you want to go to setting manu?"
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  otherButtonTitles:@"Setting", nil];
    [alertOfLocation show];
    NSLog(@"locationManager:%@ didFailWithError:%@", manager, error);
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=General"]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

#pragma mark - retire Data from json
-(void) retrivEventData
{
    MBProgressHUD *hud;
    
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"Loading Events...";
    
    userDetail=[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"];
    NSString *email=[userDetail objectForKey:@"email"];
    
    NSMutableDictionary *jsonDictionary =[NSMutableDictionary dictionaryWithObjectsAndKeys:                                        latitude,@"latitude",                                          longitude,@"longitude",                                          email,@"userEmail",
        distance,@"distance",
        @"0",@"date",
        nil];
    
    AFHTTPRequestOperationManager *getFavDealManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:GETNEARBYEVENT]];
    
    AFHTTPRequestOperation *op = [getFavDealManager POST:GETNEARBYEVENT parameters:jsonDictionary constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    }
        success:^(AFHTTPRequestOperation *operation, id responseObject)
      {
          [hud hide:YES];
          self.tabBarController.tabBar.userInteractionEnabled=YES;
          //NSLog(@"%@",responseObject);
          if([[responseObject objectForKey:@"Result"]isEqualToString:@"True"])
          {
              //nearbyDataCopy=[responseObject objectForKey:@"event"];
              data=[responseObject objectForKey:@"event"];
              
          }
          [self loadData];
          [_tvEventList reloadData];
      }
        failure:^(AFHTTPRequestOperation *operation, NSError *error)
      {
          NSLog(@"Error : %@",error);
          [hud hide:YES];
          self.tabBarController.tabBar.userInteractionEnabled=YES;
      }
      ];
    [op start];
}

//-(void) retrivEventData
//{

//    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText=@"Loading Events...";
//    
//    //    NSDate *date = [[NSDate alloc]init];
//    //    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//    //    [df setDateFormat:@"yyyy-MM-dd"];
//    //    NSString *selectedDate=[df stringFromDate:date];
//    
//    userDetail=[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"];
//    NSString *email=[userDetail objectForKey:@"email"];
//    NSMutableDictionary *jsonDictionary =[NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                          latitude,@"latitude",
//                                          longitude,@"longitude",
//                                          distance,@"distance",
//                                          email,@"userEmail",
//                                          nil];
//    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:GETEVENT]];
//    
//    AFHTTPRequestOperation *op = [manager POST:GETEVENT parameters:jsonDictionary constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//    }
//           success:^(AFHTTPRequestOperation *operation, id responseObject)
//      {
//          [hud hide:YES];
//          //NSLog(@"%@",responseObject);
//          if([[responseObject objectForKey:@"Result"]isEqualToString:@"True"])
//          {
//              eventListDict=[responseObject objectForKey:@"eventlist"];
//              if ([eventListDict count]>0) {
//                  dateList=[[[eventListDict allKeys]sortedArrayUsingSelector:@selector(compare:)]mutableCopy];
//                  [self retriveNearbyData];
//              }
//          }
//          else
//          {
//              
//          }
//          [self loadData];
//          [_tvEventList reloadData];
//          
//      }
//           failure:^(AFHTTPRequestOperation *operation, NSError *error)
//      {
//          NSLog(@"Error : %@",error);
//          [hud hide:YES];
//      }
//      ];
//    [op start];

//}

-(void) retriveNearbyData
{
    dateList=[[[eventListDict allKeys]sortedArrayUsingSelector:@selector(compare:)]mutableCopy];
    
    NSMutableArray *temp=[[NSMutableArray alloc]init];
    NSMutableArray *temp2=[[NSMutableArray alloc]init];
    for (int i=0; i<[eventListDict count]; i++)
    {
        temp2=[eventListDict objectForKey:[dateList objectAtIndex:i]];
        for (int j=0;j<[temp2 count];j++)
        {
            eventDetail=[temp2 objectAtIndex:j];
            //NSLog(@"Name : %@ Fav : %@",[event_Detail objectForKey:@"eventName"],[event_Detail objectForKey:@"isFavourite"]);
            if ([[eventDetail objectForKey:@"distance_in_km"]floatValue] <= [distance floatValue])
            {
                Boolean flag=1;
                for (int k=0; k<[temp count]; k++)
                {
                    NSMutableDictionary *tempDetail=[temp objectAtIndex:k];
                    if ([[tempDetail objectForKey:@"eventId"] isEqual: [eventDetail objectForKey:@"eventId"]])
                    {
                        flag=0;
                        break;
                    }
                }
                if (flag) {
                    [temp addObject:eventDetail];
                }
            }
            //NSLog(@"temp : %@",temp);
        }
    }
    data=temp;
    //[data setArray:[[NSSet setWithArray:temp] allObjects]];
    //[nearbyDataCopy setArray:[[NSSet setWithArray:temp] allObjects]];
    
    //NSLog(@"%@",nearbyData);
}


-(void) retriveDealData
{
    
    MBProgressHUD *hud;
//    if(round == 1)
//    {
        hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText=@"Loading Deals...";
//    }
//    else
//    {
//        [_indicator setHidden:false];
//    }
    
//    NSDate *date = [[NSDate alloc]init];
//    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//    [df setDateFormat:@"yyyy-MM-dd"];
//    NSString *selectedDate=[df stringFromDate:date];
    
    userDetail=[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"];
    NSString *email=[userDetail objectForKey:@"email"];
    NSMutableDictionary *jsonDictionary =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                          latitude,@"latitude",
                                          longitude,@"longitude",
                                          distance,@"distance",
                                          @"0",@"date",
                                          email,@"userEmail",
                                          nil];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:GETDEALS]];
    
    AFHTTPRequestOperation *op = [manager POST:GETDEALS parameters:jsonDictionary constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    }
                                       success:^(AFHTTPRequestOperation *operation, id responseObject)
                                  {
                                      [hud hide:YES];
                                      [_indicator setHidden:YES];
                                      //noOfDeals=ceil([[responseObject objectForKey:@"TotalDeal"]floatValue]/20);
                                      
                                      //NSLog(@"%@",responseObject);
                                      if([[responseObject objectForKey:@"Result"]isEqualToString:@"True"])
                                      {
                                          data=[responseObject objectForKey:@"deals"];
                                          //[self fillData];
                                          
                                          //ann
//                                          self.coordinateQuadTree = [[TBCoordinateQuadTree alloc] init];
//                                          self.coordinateQuadTree.mapView = self.mvEvent;
//                                          [self.coordinateQuadTree ListOfData:data];
//                                          [self.coordinateQuadTree buildTree];
                                          
                                          
                                          //qtree
                                          
                                      }
                                      else
                                      {
                                          
                                      }
                                      [self loadData];
                                      [_tvEventList reloadData];
                                      
                                  }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error)
                                  {
                                      NSLog(@"Error : %@",error);
                                      [hud hide:YES];
                                      [_indicator setHidden:YES];
                                  }
                                  ];
    [op start];
    
    
    
//    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText=@"Loading...";
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//        NSDate *selectedDate = [[NSDate alloc]init];
//        NSDateFormatter *df = [[NSDateFormatter alloc] init];
//        [df setDateFormat:@"yyyy-MM-dd"];
//        NSString *date=[df stringFromDate:selectedDate];
//        
//        NSMutableDictionary *jsonDictionary =[NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                        latitude,@"latitude",
//                                        longitude,@"longitude",
//                                        distance,@"distance",
//                                        date,@"date",
//                                        type,@"type",
//                                        nil];
//        
//        ServiceCall *sc=[[ServiceCall alloc]init];
//        NSMutableDictionary *response = [sc serviceCall:[NSString stringWithFormat:@"%@",GETLOCATION]:jsonDictionary];
//        //NSLog(@"Response : %@",response);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [hud hide:YES];
//            NSString *status = [response objectForKey:@"ResponseCode"];
//            
//            if ([status isEqualToString:@"1"])
//            {
//                data=[response objectForKey:@"data"];
//                NSLog(@"Data : %@",data);
//            }
//            else
//            {
//                
//            }
//            [_tvEventList reloadData];
//            [self fillData];
//        });
//    });
}

-(void)fillData
{
    int noOfEvent=[data count];
    for(int i=0;i<noOfEvent;i++)
    {
        eventDetail=[data objectAtIndex:i];
        MKPointAnnotation *eventAnnotation = [[MKPointAnnotation alloc]init];
        
        CLLocationCoordinate2D pinCoordinate;
        pinCoordinate.latitude = [[eventDetail objectForKey:@"latitude"]doubleValue];//latitude;
        pinCoordinate.longitude = [[eventDetail objectForKey:@"longitude"]doubleValue];//longitude;
       
        eventAnnotation.coordinate = pinCoordinate;
        eventAnnotation.title=[eventDetail objectForKey:@"bussinessName"];
        
        [_mvEvent addAnnotation:eventAnnotation];
        
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [data count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SimpleTableCell";
    
    NearMeEventTableViewCell *eventCell = (NearMeEventTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(eventCell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NearMeEventTableViewCell" owner:self options:nil];
        eventCell = [nib objectAtIndex:0];
    }
    
    eventDetail=[data objectAtIndex:indexPath.row];
    
    float finaldistance=[[eventDetail objectForKey:@"distance_in_km"]floatValue]*0.621371 ;
    eventCell.lblDistance.text=[NSString stringWithFormat:@"%.2f",finaldistance];
    eventCell.lblMeasure.text=@"Miles";
    
    if([tabBar.eventDetail count] > 0)
    {
        eventCell.lblEventname.text=[eventDetail objectForKey:@"eventName"];
    }
    else
    {
//        if (indexPath.row == ([data count]-2) && round <= noOfDeals) {
//            round++;
//            [self retriveDealData];
//        }
        
        eventCell.lblEventname.text=[eventDetail objectForKey:@"bussinessName"];
    }
    
    eventCell.lblLocation.text=[eventDetail objectForKey:@"city"];
 
    
    NSMutableArray *img = [[NSMutableArray alloc]init];
    
    if([[eventDetail objectForKey:@"isBooking"] isEqual:@"1"])
        [img addObject:@"call.png"];
    
    if([[eventDetail objectForKey:@"isFridayOff"] isEqual:@"1"])
        [img addObject:@"icon_fri_off.png"];
    
    if([[eventDetail objectForKey:@"isSaturdayOff"] isEqual:@"1"])
        [img addObject:@"icon_sat_off.png"];
    
    if([[eventDetail objectForKey:@"isDecemberOff"] isEqual:@"1"])
        [img addObject:@"icon_dec_off.png"];
    
    if([[eventDetail objectForKey:@"dealRestrictions"] isEqual:@"2"])
        [img addObject:@"icon_2.png"];
    else if([[eventDetail objectForKey:@"dealRestrictions"] isEqual:@"4"])
        [img addObject:@"icon_4.png"];
    else if([[eventDetail objectForKey:@"dealRestrictions"] isEqual:@"6"])
        [img addObject:@"icon_6.png"];
    
    
    NSString *labelString;
    
    if([[eventDetail objectForKey:@"deal"] containsString:@"2 for 1"])
    {
        [img addObject:@"241.png"];
        labelString=@"241";
    }
    else if([[eventDetail objectForKey:@"deal"] containsString:@"50%"])
    {
        [img addObject:@"50percent.png"];
        labelString=@"50% Off";
    }
    else if([[eventDetail objectForKey:@"deal"] containsString:@"%"])
    {
        NSArray *arrtemp=[[eventDetail objectForKey:@"deal"] componentsSeparatedByString:@"%"];
        
        NSString *discount;
        if([[arrtemp objectAtIndex:0] length] == 1)
        {
            discount=[[arrtemp objectAtIndex:0] substringFromIndex: [[arrtemp objectAtIndex:0] length] - 1];
        }
        else
        {
            discount=[[arrtemp objectAtIndex:0] substringFromIndex: [[arrtemp objectAtIndex:0] length] - 2];
        }
        labelString=[NSString stringWithFormat:@"%@%% Off",discount];
    }
    else
    {
        labelString=@"Other Deal";
    }
    
    eventCell.lblDiscount.text=labelString;
    [eventCell.lblDiscount setHidden:false];
    [eventCell.ivBackground setHidden:false];
    
    for (int i=0;i<[img count];i++) {
        switch (i) {
            case 0:
                [eventCell.iv1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[img objectAtIndex:i]]]];
                break;
            case 1:
                [eventCell.iv2 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[img objectAtIndex:i]]]];
                break;
            case 3:
                [eventCell.iv3 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[img objectAtIndex:i]]]];
                break;
            case 4:
                [eventCell.iv4 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[img objectAtIndex:i]]]];
                break;
            case 5:
                [eventCell.iv5 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[img objectAtIndex:i]]]];
                break;
            case 6:
                [eventCell.iv6 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[img objectAtIndex:i]]]];
                break;
        }
    }
   
    //for display image
    NSString *basicurl = [eventDetail objectForKey:@"image"];
    [image loadImage:basicurl ImageView:eventCell.ivEvent ActivityIndicator:nil];
    
    //for rate
    float rate=[[eventDetail objectForKey:@"rate"]floatValue];
    [star FillRate:rate FirstImageView:eventCell.ivFirstStar SecondImageView:eventCell.ivSecondStar ThirdImageView:eventCell.ivThirdStar FourthImageView:eventCell.ivFourthStar FifthImageView:eventCell.ivFifthStar];
    
    
    return eventCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    eventDetail=[data objectAtIndex:indexPath.row];
    if([tabBar.eventDetail count] > 0)
    {
        selectedId=[eventDetail objectForKey:@"eventId"];
        headerDate=[dateConvert convertDate:[eventDetail objectForKey:@"startDate"] Enddate:[eventDetail objectForKey:@"endDate"] StartTime:[eventDetail objectForKey:@"startTime"] EndTime:[eventDetail objectForKey:@"endTime"]];
    }
    else
    {
        selectedId=[eventDetail objectForKey:@"dealId"];
    }
    [self performSegueWithIdentifier:@"Detail" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Detail"])
    {
        SubTabBarViewController *st = (SubTabBarViewController *)segue.destinationViewController;
        if([tabBar.eventDetail count] > 0)
        {
            st.eventId=selectedId;
            st.eventDetail=eventDetail;            
            st.headerDate=headerDate;
            st.dealId=0;
        }
        else
        {
            st.dealId=selectedId;
            st.dealDetail=eventDetail;
            st.eventId=0;
        }
        
        //NSLog(@"%@",st.dealDetail);
    }
}



-(IBAction)btnCall:(UIButton*)sender
{
    eventDetail=[data objectAtIndex:sender.tag];
    NSString *mobileNo=[eventDetail objectForKey:@"mobileNo"];
    
    NSURL* callUrl=[NSURL URLWithString:[NSString   stringWithFormat:@"tel:%@",mobileNo]];
    
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

- (IBAction)btnBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)btnMap:(id)sender {
    
    if(_viewList.hidden == true)
    {
        _viewList.hidden=false;
        _viewMap.hidden=true;
        [_btnMap setBackgroundImage:[UIImage imageNamed:@"btn_map.png"] forState:UIControlStateNormal];
    }
    else
    {
        _viewList.hidden=true;
        _viewMap.hidden=false;
        [_btnMap setBackgroundImage:[UIImage imageNamed:@"btn_map_list.png"] forState:UIControlStateNormal];
    }
    
}

- (IBAction)btnFilter:(id)sender {
}

- (IBAction)btnRefresh:(id)sender
{
    countForLocation=1;
    isClickRefresh=1;
    [locationManager startUpdatingLocation];
}

#pragma mark MKMapViewDelegate
//Qtree

-(void)loadData
{
    self.qTree = [QTree new];
    for( NSUInteger i = 0; i < [data count]; ++i )
    {
        CustomAnnotation* object = [CustomAnnotation new];
        eventDetail=[data objectAtIndex:i];
        object.coordinate = CLLocationCoordinate2DMake([[eventDetail objectForKey:@"latitude"]doubleValue],[[eventDetail objectForKey:@"longitude"]doubleValue]);
        
        if([tabBar.eventDetail count] > 0)
            object.titleOfAnnotation=[eventDetail objectForKey:@"eventName"];
        else
            object.titleOfAnnotation=[eventDetail objectForKey:@"bussinessName"];
        object.tag=[NSString stringWithFormat:@"%lu",(unsigned long)i ];
        [self.qTree insertObject:object];
    }
    [self reloadAnnotations];
}
-(void)reloadAnnotations
{
    if( !self.isViewLoaded ) {
        return;
    }
    
    const MKCoordinateRegion mapRegion = self.mvEvent.region;
    //BOOL useClustering = 1;
    const CLLocationDegrees minNonClusteredSpan = useClustering ? MIN(mapRegion.span.latitudeDelta, mapRegion.span.longitudeDelta) / 5
    : 0;
    NSArray* objects = [self.qTree getObjectsInRegion:mapRegion minNonClusteredSpan:minNonClusteredSpan];
    
    NSMutableArray* annotationsToRemove = [self.mvEvent.annotations mutableCopy];
    [annotationsToRemove removeObject:self.mvEvent.userLocation];
    [annotationsToRemove removeObjectsInArray:objects];
    [self.mvEvent removeAnnotations:annotationsToRemove];
    
    NSMutableArray* annotationsToAdd = [objects mutableCopy];
    [annotationsToAdd removeObjectsInArray:self.mvEvent.annotations];
    
    [self.mvEvent addAnnotations:annotationsToAdd];
}

-(IBAction)segmentChanged:(id)sender
{
    [self reloadAnnotations];
}

-(void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    if (isClickRefresh) {
        useClustering=1;
        isClickRefresh=0;
        return;
    }
    float currentZoomScale = mapView.bounds.size.width / mapView.visibleMapRect.size.width;
    if (currentZoomScale >= 0.072726)
    {
        useClustering=0;
    }
    else
    {
        useClustering=1;
    }
}

-(void)mapView:(MKMapView*)mapView regionDidChangeAnimated:(BOOL)animated
{
    [self reloadAnnotations];
}

-(MKAnnotationView*)mapView:(MKMapView*)mapView viewForAnnotation:(CustomAnnotation *)annotation
{
    if( [annotation isKindOfClass:[QCluster class]] ) {
        ClusterAnnotationView* annotationView = (ClusterAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:[ClusterAnnotationView reuseId]];
        if( !annotationView ) {
            annotationView = [[ClusterAnnotationView alloc] initWithCluster:(QCluster*)annotation];
        }
        annotationView.cluster = (QCluster*)annotation;
        return annotationView;
    }
    else if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    else
    {
        MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"loc"];
        UIButton *btnInfo = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        [btnInfo addTarget:self action:@selector(pinButton:) forControlEvents:UIControlEventTouchUpInside];
        //NSLog(@"%ld",(long)[annotation.tag integerValue]);
        btnInfo.tag=[annotation.tag integerValue];
        
        annotationView.rightCalloutAccessoryView = btnInfo;
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        
        return annotationView;
    }
}

-(IBAction)pinButton:(UIButton*)sender
{
    eventDetail=[data objectAtIndex:sender.tag];
    if([tabBar.eventDetail count] > 0)
    {
        selectedId=[eventDetail objectForKey:@"eventId"];
        headerDate=[dateConvert convertDate:[eventDetail objectForKey:@"startDate"] Enddate:[eventDetail objectForKey:@"endDate"] StartTime:[eventDetail objectForKey:@"startTime"] EndTime:[eventDetail objectForKey:@"endTime"]];
    }
    else
    {
        selectedId=[eventDetail objectForKey:@"dealId"];
    }
    [self performSegueWithIdentifier:@"Detail" sender:self];
}

-(void)mapView:(MKMapView*)mapView didSelectAnnotationView:(MKAnnotationView*)view
{
    id<MKAnnotation> annotation = view.annotation;
    if( [annotation isKindOfClass:[QCluster class]] )
    {
        useClustering=1;
        QCluster* cluster = (QCluster*)annotation;
        [mapView setRegion:MKCoordinateRegionMake(cluster.coordinate, MKCoordinateSpanMake(3.50 * cluster.radius, 3.50 * cluster.radius))
                  animated:YES];
        
        float currentZoomScale = mapView.bounds.size.width / mapView.visibleMapRect.size.width;
        //NSLog(@"%f",currentZoomScale);
        
        if (currentZoomScale >= 0.072726)
        {
            useClustering=0;
        }
        //[self reloadAnnotations];
    }
    //    else
    //    {
    //        //[self.qTree removeObject:(id<QTreeInsertable>)annotation];
    //        [self reloadAnnotations];
    //    }
}

//draw 1000 meter circle ro user location
-(void)setCircleToUserLocation
{
    MKPointAnnotation *userLocationAnnotation = [[MKPointAnnotation alloc]init];
    
    CLLocationCoordinate2D userLocation;
    userLocation.latitude = [latitude doubleValue];
    userLocation.longitude = [longitude doubleValue];
    
    userLocationAnnotation.coordinate =  userLocation;
    MKCoordinateSpan span = {.latitudeDelta =  0.2, .longitudeDelta =  0.2};
    MKCoordinateRegion region = {userLocation, span};
    
    [_mvEvent setRegion:region animated:YES];
    
    NSArray *pointsArray = [_mvEvent overlays];
    [_mvEvent removeOverlays:pointsArray];
    
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:userLocationAnnotation.coordinate radius:8046.72];
    [_mvEvent addOverlay:circle];
    
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    MKCircleView *circleView = [[MKCircleView alloc] initWithOverlay:overlay];
    [circleView setFillColor:[UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:0.5]];
    [circleView setStrokeColor:[UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0]];
    [circleView setLineWidth:5.0];
    [circleView setAlpha:0.3];
    
    return circleView;
}

@end
