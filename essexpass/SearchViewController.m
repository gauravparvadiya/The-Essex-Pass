//
//  SearchViewController.m
//  essexpass
//
//  Created by Paras Chodavadiya on 27/01/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchFilterTableViewCell.h"
#import "SearchResultViewController.h"
#import "SubTabBarViewController.h"
#import "MBProgressHUD.h"
#import "ServiceCall.h"
#import "Contant.h"
#import <CoreLocation/CoreLocation.h>
#import "AFHTTPRequestOperationManager.h"

@interface SearchViewController ()
{
    NSString *latitude,*longitude,*type;
    int count;
    CLLocationManager *locationManager;
    NSMutableDictionary *eventDetail, *categoryDetail;
    NSMutableArray *data, *copyOfData, *categoryList;
    NSString *by,*filter;
    NSMutableArray *temp, *temp2, *temp3, *temp4;
    NSMutableArray *filterMainType, *category, *avilability, *offers, *restrictions, *price,*currentData;
    NSString *currentArrayName;
    int indexOfPrice,indexOfAvilability,indexOfOffers,indexOfRestrications,indexOfCategory;
    NSMutableArray *dateList;
    NSMutableDictionary *eventListDict;
    SubTabBarViewController *tabBar;
    BOOL isSerachClicked;
    MBProgressHUD *hud;
}

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    count=1;
    
    
    indexOfCategory=0;
    indexOfPrice=0;
    indexOfAvilability=0;
    indexOfOffers=0;
    indexOfRestrications=0;
    isSerachClicked=0;
    
    tabBar = (SubTabBarViewController *)self.tabBarController;
    
    data=[[NSMutableArray alloc]init];
    copyOfData=[[NSMutableArray alloc]init];
    categoryList=[[NSMutableArray alloc]init];
    
    _tvFilter.layer.cornerRadius=8.0f;
    _tvFilter.layer.borderWidth=2.0f;
    _tvFilter.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    by=@"1";
    filter=@"1";
    
    if([tabBar.eventDetail count] > 0)
    {
        type=@"event";
        [self fillArrayEvent];
    }
    else
    {
        type=@"deal";
        [self fillArrayDeal];
    }
    [self getCategory];
    
    currentArrayName=@"filterMainType";
    currentData=filterMainType;
    
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
    
    
    CLLocationCoordinate2D userLocation;
    userLocation.latitude = [latitude doubleValue];
    userLocation.longitude = [longitude doubleValue];
}

-(void)fillArrayEvent
{
    filterMainType=[[NSMutableArray alloc]initWithCapacity: 2];;
    category=[[NSMutableArray alloc]init];
    price=[[NSMutableArray alloc]init];
    
    [filterMainType insertObject:[NSMutableArray arrayWithObjects:@"Category",@"All",nil] atIndex:0];
    [filterMainType insertObject:[NSMutableArray arrayWithObjects:@"Price",@"All",nil] atIndex:1];
    
    [category addObject:@"All"];
    
    [price addObject:@"All"];
    [price addObject:@"Less Than £5"];
    [price addObject:@"£5 - £10"];
    [price addObject:@"More Than £10"];
    
}

-(void)fillArrayDeal
{
    filterMainType=[[NSMutableArray alloc]initWithCapacity: 2];;
    category=[[NSMutableArray alloc]init];
    avilability=[[NSMutableArray alloc]init];
    offers=[[NSMutableArray alloc]init];
    price=[[NSMutableArray alloc]init];
    restrictions=[[NSMutableArray alloc]init];
    
    [filterMainType insertObject:[NSMutableArray arrayWithObjects:@"Category",@"All",nil] atIndex:0];
    [filterMainType insertObject:[NSMutableArray arrayWithObjects:@"Availability",@"All",nil] atIndex:1];
    [filterMainType insertObject:[NSMutableArray arrayWithObjects:@"Offers",@"All",nil] atIndex:2];
    [filterMainType insertObject:[NSMutableArray arrayWithObjects:@"Restrictions",@"All",nil] atIndex:3];
    //[filterMainType insertObject:[NSMutableArray arrayWithObjects:@"Price",@"All",nil] atIndex:4];
    
    [category addObject:@"All"];
    
    [avilability addObject:@"All"];
//    [avilability addObject:@"Monday"];
//    [avilability addObject:@"Tuesday"];
//    [avilability addObject:@"Wednesday"];
//    [avilability addObject:@"Thursday"];
    [avilability addObject:@"Friday"];
    [avilability addObject:@"Saturday"];
//    [avilability addObject:@"Sunday"];
    [avilability addObject:@"December"];
    
    [price addObject:@"All"];
    [price addObject:@"Less Than $5"];
    [price addObject:@"$5 - $10"];
    [price addObject:@"More Than $10"];
    
    [offers addObject:@"All"];
    [offers addObject:@"Less Than 10% "];
    [offers addObject:@"10 - 50%"];
    [offers addObject:@"More Than 50%"];
    [offers addObject:@"2 For 1"];
    
    [restrictions addObject:@"All"];
    [restrictions addObject:@"2 people per pass"];
    [restrictions addObject:@"4 people per pass"];
    [restrictions addObject:@"6 people per pass"];

}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if(count == 1)
    {
        CLLocation *newLocation = [locations lastObject];
        
        latitude = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
        longitude = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
        
        //NSLog(@"Current latitude : %@  ,Current longitude : %@",latitude,longitude);
        // Turn off the location manager to save power.
    
    
        if([tabBar.eventDetail count] > 0)
        {
            [self retrivEventData];
        }
        else
        {
            [self retrivDealData];
        }
        
        count++;
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

//tableview

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [currentData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SimpleTableCell";
    
    SearchFilterTableViewCell *searchCell = (SearchFilterTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(searchCell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SearchFilterTableViewCell" owner:self options:nil];
        searchCell = [nib objectAtIndex:0];
    }    
    
    if([indexPath row ] % 2 != 0)
    {
        searchCell.backgroundColor=[UIColor colorWithRed:202.0/255.0 green:202.0/255.0 blue:205.0/255.0 alpha:1.0];
    }
    
    if([currentArrayName isEqual:@"filterMainType"])
    {
        searchCell.lblName.text=[[currentData objectAtIndex:indexPath.row]objectAtIndex:0];
        searchCell.lblSelectedName.text=[[currentData objectAtIndex:indexPath.row]objectAtIndex:1];
    }
    else
    {
        searchCell.lblName.text=[currentData objectAtIndex:indexPath.row];
    }
    return searchCell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tabBar.eventDetail count] > 0)
    {
        _lblFilterName.text=@"Filter...";
        if([currentArrayName isEqual: @"filterMainType"])
        {
            switch (indexPath.row) {
                case 0:
                    currentData=category;
                    currentArrayName=@"category";
                    _lblFilterName.text=@"Category...";
                    break;
                case 1:
                    currentData=price;
                    currentArrayName=@"price";
                    _lblFilterName.text=@"Price...";
                    break;
            }
        }
        else if([currentArrayName isEqual: @"category"])
        {
            currentData=filterMainType;
            currentArrayName=@"filterMainType";
            indexOfCategory=indexPath.row;
            [filterMainType replaceObjectAtIndex:0 withObject:[NSMutableArray arrayWithObjects:@"Category",[NSString stringWithFormat:@"%@",[category objectAtIndex:indexPath.row]],nil]];
        }
        else if([currentArrayName isEqual: @"price"])
        {
            currentData=filterMainType;
            currentArrayName=@"filterMainType";
            indexOfPrice=indexPath.row;
            [filterMainType replaceObjectAtIndex:1 withObject:[NSMutableArray arrayWithObjects:@"Price",[NSString stringWithFormat:@"%@",[price objectAtIndex:indexPath.row]],nil]];
        }
        [_tvFilter reloadData];
    }
    else
    {
    
     _lblFilterName.text=@"Filter...";
    if([currentArrayName isEqual: @"filterMainType"])
    {
        switch (indexPath.row) {
            case 0:
                currentData=category;
                currentArrayName=@"category";
                _lblFilterName.text=@"Category...";
                break;
            case 1:
                currentData=avilability;
                currentArrayName=@"avilability";
                _lblFilterName.text=@"Avilability...";
                break;
            case 2:
                currentData=offers;
                currentArrayName=@"offers";
                _lblFilterName.text=@"Offers...";
                break;
            case 3:
                currentData=restrictions;
                currentArrayName=@"restrictions";
                _lblFilterName.text=@"Restrictions...";
                break;
            case 4:
                currentData=price;
                currentArrayName=@"price";
                _lblFilterName.text=@"Price...";
                break;
        }
    }
    else if([currentArrayName isEqual: @"category"])
    {
        currentData=filterMainType;
        currentArrayName=@"filterMainType";
        indexOfCategory=indexPath.row;
        [filterMainType replaceObjectAtIndex:0 withObject:[NSMutableArray arrayWithObjects:@"Category",[NSString stringWithFormat:@"%@",[category objectAtIndex:indexPath.row]],nil]];
    }
    else if([currentArrayName isEqual: @"avilability"])
    {
        currentData=filterMainType;
        currentArrayName=@"filterMainType";
        indexOfAvilability=indexPath.row;
        [filterMainType replaceObjectAtIndex:1 withObject:[NSMutableArray arrayWithObjects:@"Availability",[NSString stringWithFormat:@"%@",[avilability objectAtIndex:indexPath.row]],nil]];
    }
    else if([currentArrayName isEqual: @"offers"])
    {
        currentData=filterMainType;
        currentArrayName=@"filterMainType";
        indexOfOffers=indexPath.row;
        [filterMainType replaceObjectAtIndex:2 withObject:[NSMutableArray arrayWithObjects:@"Offers",[NSString stringWithFormat:@"%@",[offers objectAtIndex:indexPath.row]],nil]];
    }
    else if([currentArrayName isEqual: @"restrictions"])
    {
        currentData=filterMainType;
        currentArrayName=@"filterMainType";
        indexOfRestrications=indexPath.row;
        [filterMainType replaceObjectAtIndex:3 withObject:[NSMutableArray arrayWithObjects:@"Restrication",[NSString stringWithFormat:@"%@",[restrictions objectAtIndex:indexPath.row]],nil]];
    }
    else if([currentArrayName isEqual: @"price"])
    {
        currentData=filterMainType;
        currentArrayName=@"filterMainType";
        indexOfPrice=indexPath.row;
        [filterMainType replaceObjectAtIndex:4 withObject:[NSMutableArray arrayWithObjects:@"Price",[NSString stringWithFormat:@"%@",[price objectAtIndex:indexPath.row]],nil]];
    }
    [_tvFilter reloadData];
    }
}

//button Click
- (IBAction)btnSearchByLocation:(id)sender {
    [self btnRadioButton2:sender];
    by=@"1";
}

- (IBAction)btnSearchByName:(id)sender {
    [self btnRadioButton2:sender];
    by=@"2";
}
- (IBAction)btnNearest:(id)sender {
    [self btnRadioButton3:sender];
    filter=@"1";
}

- (IBAction)btnAlphabetical:(id)sender {
    [self btnRadioButton3:sender];
    filter=@"2";
}

- (IBAction)btnRating:(id)sender {

    [self btnRadioButton3:sender];
    filter=@"3";
}
- (IBAction)btnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnRadioButton2:(id)sender
{
    [_btnSearchByLocation setImage:[UIImage imageNamed:@"radio_btn_unfill.png"] forState:UIControlStateNormal];
    [_btnSearchByName setImage:[UIImage imageNamed:@"radio_btn_unfill.png"] forState:UIControlStateNormal];
    
    [sender setImage:[UIImage imageNamed:@"radio_btn_fill.png"] forState:UIControlStateNormal];
}

-(IBAction)btnRadioButton3:(id)sender
{
    [_btnAlphabetical setImage:[UIImage imageNamed:@"radio_btn_unfill.png"] forState:UIControlStateNormal];
    [_btnNearest setImage:[UIImage imageNamed:@"radio_btn_unfill.png"] forState:UIControlStateNormal];
    [_btnRating setImage:[UIImage imageNamed:@"radio_btn_unfill.png"] forState:UIControlStateNormal];
    
    [sender setImage:[UIImage imageNamed:@"radio_btn_fill.png"] forState:UIControlStateNormal];
}

#pragma mark - retire Data from json

-(void) retrivEventData
{
    NSMutableDictionary *userDetail=[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"];
    NSString *email=[userDetail objectForKey:@"email"];
    
    NSMutableDictionary *jsonDictionary =[NSMutableDictionary dictionaryWithObjectsAndKeys:                                        latitude,@"latitude",                                          longitude,@"longitude",                                          email,@"userEmail",
        @"0",@"distance",
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
              copyOfData=data;
              if (isSerachClicked)
              {
                  [self searching];
              }
          }
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
//    NSMutableDictionary *userDetail=[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"];
//    NSString *email=[userDetail objectForKey:@"email"];
//    NSMutableDictionary *jsonDictionary =[NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                          latitude,@"latitude",
//                                          longitude,@"longitude",
//                                          @"0",@"distance",
//                                          email,@"userEmail",
//                                          nil];
//    
//    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:GETEVENT]];
//    
//    AFHTTPRequestOperation *op = [manager POST:GETEVENT parameters:jsonDictionary constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//    }
//                                       success:^(AFHTTPRequestOperation *operation, id responseObject)
//                                  {
//                                      [hud hide:YES];
//                                      //NSLog(@"%@",responseObject);
//                                      if([[responseObject objectForKey:@"Result"]isEqualToString:@"True"])
//                                      {
//                                          eventListDict=[responseObject objectForKey:@"eventlist"];
//                                          dateList=[[[eventListDict allKeys]sortedArrayUsingSelector:@selector(compare:)]mutableCopy];
//                                          
//                                          categoryList=[responseObject objectForKey:@"category"];
//                                          for (int i=0; i<[categoryList count]; i++)
//                                          {
//                                              categoryDetail=[categoryList objectAtIndex:i];
//                                              [category addObject:[categoryDetail objectForKey:@"categoryName"]];
//                                          }
//                                          
//                                          [self convertInSimpleArray];
//                                      }
//                                      else
//                                      {
//                                          
//                                      }
//                                  }
//                                       failure:^(AFHTTPRequestOperation *operation, NSError *error)
//                                  {
//                                      NSLog(@"Error : %@",error);
//                                      [hud hide:YES];
//                                  }
//                                  ];
//    [op start];
//    
//}

-(void) convertInSimpleArray
{
    dateList=[[[eventListDict allKeys]sortedArrayUsingSelector:@selector(compare:)]mutableCopy];
    
    NSMutableArray *temp6=[[NSMutableArray alloc]init];
    NSMutableArray *temp5=[[NSMutableArray alloc]init];
    for (int i=0; i<[eventListDict count]; i++)
    {
        temp5=[eventListDict objectForKey:[dateList objectAtIndex:i]];
        for (int j=0;j<[temp5 count];j++)
        {
            Boolean flag=1;
            eventDetail=[temp5 objectAtIndex:j];
            for (int k=0; k<[temp6 count]; k++)
            {
                NSMutableDictionary *tempDetail=[temp6 objectAtIndex:k];
                if ([[tempDetail objectForKey:@"eventId"] isEqual: [eventDetail objectForKey:@"eventId"]])
                {
                    flag=0;
                    break;
                }
            }
            if (flag) {
                [temp6 addObject:eventDetail];
            }
        }
    }
    
    data=temp6;
    //[data setArray:[[NSSet setWithArray:temp6] allObjects]];
    copyOfData=data;
}

-(void) retrivDealData
{
    
//    NSDate *date = [[NSDate alloc]init];
//    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//    [df setDateFormat:@"yyyy-MM-dd"];
//    NSString *selectedDate=[df stringFromDate:date];
    
    NSMutableDictionary *userDetail=[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"];
    NSString *email=[userDetail objectForKey:@"email"];
    NSMutableDictionary *jsonDictionary =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                          latitude,@"latitude",
                                          longitude,@"longitude",
                                          @"0",@"distance",
                                          @"0",@"date",
                                          email,@"userEmail",
                                          nil];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:GETDEALS]];
    
    AFHTTPRequestOperation *op = [manager POST:GETDEALS parameters:jsonDictionary constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    }
           success:^(AFHTTPRequestOperation *operation, id responseObject)
      {
          [hud hide:YES];
          //NSLog(@"%@",responseObject);
          if([[responseObject objectForKey:@"Result"]isEqualToString:@"True"])
          {
              
              data=[responseObject objectForKey:@"deals"];
              //NSLog(@"%lu",(unsigned long)[data count]);
              copyOfData=[responseObject objectForKey:@"deals"];
              [self searching];
              //NSLog(@"Data : %@",data);
              
//              categoryList=[responseObject objectForKey:@"category"];
//              for (int i=0; i<[categoryList count]; i++)
//              {
//                  categoryDetail=[categoryList objectAtIndex:i];
//                  [category addObject:[categoryDetail objectForKey:@"categoryName"]];
//              }
          }
          else
          {
              
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

-(void)getCategory
{
    NSMutableDictionary *jsonDictionary;
    
    if([tabBar.eventDetail count] > 0)
    {
        jsonDictionary=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                        @"event",@"type",
                        nil];
    }
    else
    {
        jsonDictionary=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                        @"deal",@"type",
                        nil];
    }
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:GETCATEGORY]];
    
    AFHTTPRequestOperation *op = [manager POST:GETCATEGORY parameters:jsonDictionary constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    }
           success:^(AFHTTPRequestOperation *operation, id responseObject)
      {
          [hud hide:YES];
          //NSLog(@"%@",responseObject);
          if([[responseObject objectForKey:@"Result"]isEqualToString:@"True"])
          {
              
              categoryList=[responseObject objectForKey:@"category"];
              for (int i=0; i<[categoryList count]; i++)
              {
                  categoryDetail=[categoryList objectAtIndex:i];
                  [category addObject:[categoryDetail objectForKey:@"categoryName"]];
              }
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
//                                              latitude,@"latitude",
//                                              longitude,@"longitude",
//                                              @"0",@"distance",
//                                              date,@"date",
//                                              type,@"type",
//                                              nil];
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
//                //NSLog(@"%lu",(unsigned long)[data count]);
//                copyOfData=[response objectForKey:@"data"];
//                [self searching];
//                //NSLog(@"Data : %@",data);
//                
//                categoryList=[response objectForKey:@"category"];
//                for (int i=0; i<[categoryList count]; i++) {
//                    categoryDetail=[categoryList objectAtIndex:i];
//                    [category addObject:[categoryDetail objectForKey:@"categoryName"]];
//                }
//            }
//            else
//            {
//                
//            }
//            [_tvFilter reloadData];
//        });
//    });
//}

//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    [self searching];
//    return true;
//}

-(IBAction)txtSearch:(id)sender
{
    //[self searching];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    //[self searching];
    return true;
}

- (void)DoShortByDistance{
    
    NSArray *sortedObjs = [temp3 sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        float fval = [[(NSMutableDictionary *)a objectForKey:@"distance_in_km"] floatValue];
        float sval = [[(NSMutableDictionary *)b objectForKey:@"distance_in_km"] floatValue];
        
        if(fval>sval)
            return 1;
        else
            return 0;
    }];
    temp2= [NSMutableArray arrayWithArray:sortedObjs];
}

- (void)DoShortByRate{
    
    NSArray *sortedObjs = [temp3 sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        float fval = [[(NSMutableDictionary *)a objectForKey:@"rate"] floatValue];
        float sval = [[(NSMutableDictionary *)b objectForKey:@"rate"] floatValue];
        
        if(fval<sval)
            return 1;
        else
            return 0;
        
    }];
    temp2= [NSMutableArray arrayWithArray:sortedObjs];
}
- (void)DoShortByAlpha{
    
    NSArray *sortedObjs = [temp3 sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *fval = (NSString *) [(NSMutableDictionary *)a objectForKey:@"bussinessName"];
        NSString *sval = (NSString *) [(NSMutableDictionary *)b objectForKey:@"bussinessName"];
        
        return [sval compare:fval];
    }];
    temp2= [NSMutableArray arrayWithArray:sortedObjs];
}
-(void)searching
{
    temp = [[NSMutableArray alloc]init];
    if(_txtSearch.text.length == 0)
    {
        temp=copyOfData;
    }
    //NSLog(@"Text : %@",_txtSearch.text);
    //NSLog(@"count : %lu",(unsigned long)[data count]);
    if([by isEqual:@"1"])
    {
        int j=1;
        for (int i=0; i<[copyOfData count]; i++)
        {
            eventDetail=[copyOfData objectAtIndex:i];
            if ([[NSString stringWithFormat:@"%@",[eventDetail objectForKey:@"city" ]] rangeOfString:_txtSearch.text options:NSCaseInsensitiveSearch].location == NSNotFound)
            {
            }
            else
            {
                [temp addObject:eventDetail];
                j++;
            }
        }
    }
    else
    {
        int j=1;
        for (int i=0; i<[copyOfData count]; i++)
        {
            eventDetail=[copyOfData objectAtIndex:i];
            if([tabBar.eventDetail count] > 0)
            {
                if ([[NSString stringWithFormat:@"%@",[eventDetail objectForKey:@"eventName" ]] rangeOfString:_txtSearch.text options:NSCaseInsensitiveSearch].location == NSNotFound)
                {
                }
                else
                {
                    [temp addObject:eventDetail];
                    j++;
                }
            }
            else
            {
                if ([[NSString stringWithFormat:@"%@",[eventDetail objectForKey:@"bussinessName" ]] rangeOfString:_txtSearch.text options:NSCaseInsensitiveSearch].location == NSNotFound)
                {
                }
                else
                {
                    [temp addObject:eventDetail];
                    j++;
                }
            }
        }
    }
    
    [self filterByAttribute];
    
    //NSLog(@"%@",temp);
    temp2 = [[NSMutableArray alloc]init];

    if([filter isEqual:@"1"])
    {
        [self DoShortByDistance];
    }
    else if([filter isEqual:@"2"])
    {
        [self DoShortByAlpha];
    }
    else
    {
        [self DoShortByRate];
    }
    temp=temp2;
    data=temp;
    
    if (isSerachClicked)
    {
        [self performSegueWithIdentifier:@"Search" sender:self];
    }
}

-(void)filterByAttribute
{
    temp3 = [[NSMutableArray alloc]init];
    temp4 = [[NSMutableArray alloc]init];
    //price
    switch (indexOfPrice) {
        case 0:
            temp3=temp;
            break;
        case 1:
            for(int i=0;i<[temp count];i++)
            {
                eventDetail=[temp objectAtIndex:i];
                if([[eventDetail objectForKey:@"price" ]integerValue]<5)
                {
                    [temp3 addObject:eventDetail];
                }
            }
            break;
        case 2:
            for(int i=0;i<[temp count];i++)
            {
                eventDetail=[temp objectAtIndex:i];
                if([[eventDetail objectForKey:@"price" ]integerValue]>5 && [[eventDetail objectForKey:@"price" ]integerValue]<10)
                {
                    [temp3 addObject:eventDetail];
                }
            }
            break;
        case 3:
            for(int i=0;i<[temp count];i++)
            {
                eventDetail=[temp objectAtIndex:i];
                if([[eventDetail objectForKey:@"price" ]integerValue]>10)
                {
                    [temp3 addObject:eventDetail];
                }
            }
            break;
    }
    
    //Avibility
    switch (indexOfAvilability) {
        case 0:
            
            break;
        
        case 1:
            
            for(int i=0;i<[temp3 count];i++)
            {
                eventDetail=[temp3 objectAtIndex:i];
          
                if([[eventDetail objectForKey:@"isFridayOff" ] isEqualToString:@"0"])
                {
                    [temp4 addObject:eventDetail];
                }
            }
            temp3=temp4;
            break;
        case 2:
            for(int i=0;i<[temp3 count];i++)
            {
                eventDetail=[temp3 objectAtIndex:i];
                if([[eventDetail objectForKey:@"isSaturdayOff" ] isEqualToString:@"0"])
                {
                    [temp4 addObject:eventDetail];
                }
            }
            temp3=temp4;
            break;
        case 3:
            for(int i=0;i<[temp3 count];i++)
            {
                eventDetail=[temp3 objectAtIndex:i];
                if([[eventDetail objectForKey:@"isDecemberOff" ] isEqualToString:@"0"])
                {
                    [temp4 addObject:eventDetail];
                }
            }
            temp3=temp4;
            break;
    }
    
    //Offers
    temp4=[[NSMutableArray alloc]init];
    
    switch (indexOfOffers) {
        case 0:
            break;
            
        case 1:
            
            for(int i=0;i<[temp3 count];i++)
            {
                eventDetail=[temp3 objectAtIndex:i];
                
                NSString *actualDeal;
                
                if([[eventDetail objectForKey:@"deal"] containsString:@"2 for 1"])
                {
                    actualDeal=@"241";
                }
                else if([[eventDetail objectForKey:@"deal"] containsString:@"50%"])
                {
                    actualDeal=@"50";
                }
                else if([[eventDetail objectForKey:@"deal"] containsString:@"%"])
                {
                    NSArray *arrtemp=[[eventDetail objectForKey:@"deal"] componentsSeparatedByString:@"%"];
                    
                    NSString *discount;
                    if([[arrtemp objectAtIndex:0] length] == 1)
                        discount=[[arrtemp objectAtIndex:0] substringFromIndex: [[arrtemp objectAtIndex:0] length] - 1];
                    else
                        discount=[[arrtemp objectAtIndex:0] substringFromIndex: [[arrtemp objectAtIndex:0] length] - 2];
                    actualDeal=discount;
                }
                
                if([actualDeal integerValue] <=10)
                {
                    [temp4 addObject:eventDetail];
                }
            }
            temp3=temp4;
            break;
        case 2:
            for(int i=0;i<[temp3 count];i++)
            {
                eventDetail=[temp3 objectAtIndex:i];
                
                NSString *actualDeal;
                
                if([[eventDetail objectForKey:@"deal"] containsString:@"2 for 1"])
                {
                    actualDeal=@"241";
                }
                else if([[eventDetail objectForKey:@"deal"] containsString:@"50%"])
                {
                    actualDeal=@"50";
                }
                else if([[eventDetail objectForKey:@"deal"] containsString:@"%"])
                {
                    NSArray *arrtemp=[[eventDetail objectForKey:@"deal"] componentsSeparatedByString:@"%"];
                    
                    NSString *discount;
                    if([[arrtemp objectAtIndex:0] length] == 1)
                        discount=[[arrtemp objectAtIndex:0] substringFromIndex: [[arrtemp objectAtIndex:0] length] - 1];
                    else
                        discount=[[arrtemp objectAtIndex:0] substringFromIndex: [[arrtemp objectAtIndex:0] length] - 2];
                    actualDeal=discount;
                }
                
                if([actualDeal integerValue] >=10 && [actualDeal integerValue] <=50)
                {
                    [temp4 addObject:eventDetail];
                }
            }
            temp3=temp4;
            break;
        case 3:
            
            for(int i=0;i<[temp3 count];i++)
            {
                eventDetail=[temp3 objectAtIndex:i];
                
                NSString *actualDeal;
                
                if([[eventDetail objectForKey:@"deal"] containsString:@"2 for 1"])
                {
                    actualDeal=@"241";
                }
                else if([[eventDetail objectForKey:@"deal"] containsString:@"50%"])
                {
                    actualDeal=@"50";
                }
                else if([[eventDetail objectForKey:@"deal"] containsString:@"%"])
                {
                    NSArray *arrtemp=[[eventDetail objectForKey:@"deal"] componentsSeparatedByString:@"%"];
                    
                    NSString *discount;
                    if([[arrtemp objectAtIndex:0] length] == 1)
                        discount=[[arrtemp objectAtIndex:0] substringFromIndex: [[arrtemp objectAtIndex:0] length] - 1];
                    else
                        discount=[[arrtemp objectAtIndex:0] substringFromIndex: [[arrtemp objectAtIndex:0] length] - 2];
                    actualDeal=discount;
                }
                
                if([actualDeal integerValue] >=50 && [actualDeal integerValue] <=100)
                {
                    [temp4 addObject:eventDetail];
                }
            }
            temp3=temp4;
            break;
        case 4:
            
            for(int i=0;i<[temp3 count];i++)
            {
                eventDetail=[temp3 objectAtIndex:i];
                
                NSString *actualDeal;
                
                if([[eventDetail objectForKey:@"deal"] containsString:@"2 for 1"])
                {
                    actualDeal=@"241";
                }
                else if([[eventDetail objectForKey:@"deal"] containsString:@"50%"])
                {
                    actualDeal=@"50";
                }
                else if([[eventDetail objectForKey:@"deal"] containsString:@"%"])
                {
                    NSArray *arrtemp=[[eventDetail objectForKey:@"deal"] componentsSeparatedByString:@"%"];
                    
                    NSString *discount;
                    if([[arrtemp objectAtIndex:0] length] == 1)
                        discount=[[arrtemp objectAtIndex:0] substringFromIndex: [[arrtemp objectAtIndex:0] length] - 1];
                    else
                        discount=[[arrtemp objectAtIndex:0] substringFromIndex: [[arrtemp objectAtIndex:0] length] - 2];
                    actualDeal=discount;
                }
                
                if([actualDeal integerValue] ==241)
                {
                    [temp4 addObject:eventDetail];
                }
            }
            temp3=temp4;
            break;
    }
    
    //Restriction
    temp4=[[NSMutableArray alloc]init];
    switch (indexOfRestrications) {
        case 0:
            break;
            
        case 1:
            
            for(int i=0;i<[temp3 count];i++)
            {
                eventDetail=[temp3 objectAtIndex:i];
                if([[eventDetail objectForKey:@"dealRestrictions" ]isEqualToString:@"2"])
                {
                    [temp4 addObject:eventDetail];
                }
            }
            temp3=temp4;
            break;
        case 2:
            for(int i=0;i<[temp3 count];i++)
            {
                eventDetail=[temp3 objectAtIndex:i];
                if([[eventDetail objectForKey:@"dealRestrictions" ]isEqualToString:@"4"])
                {
                    [temp4 addObject:eventDetail];
                }
            }
            temp3=temp4;
            break;
        case 3:
            for(int i=0;i<[temp3 count];i++)
            {
                eventDetail=[temp3 objectAtIndex:i];
                if([[eventDetail objectForKey:@"dealRestrictions" ]isEqualToString:@"6"])
                {
                    [temp4 addObject:eventDetail];
                }
            }
            temp3=temp4;
            break;
    }
    
    //Category
    temp4=[[NSMutableArray alloc]init];
    if(indexOfCategory > 0)
    {
        for(int i=0;i<[temp3 count];i++)
        {
//            for (int j=0;j<[categoryList count]; j++) {
//                
//            }
            categoryDetail=[categoryList objectAtIndex:indexOfCategory-1];
            eventDetail=[temp3 objectAtIndex:i];
            
            if([[eventDetail objectForKey:@"categoryId"]isEqualToString:[categoryDetail objectForKey:@"categoryId"]])
            {
                [temp4 addObject:eventDetail];
            }
        }
        temp3=temp4;
    }
    
}

- (IBAction)btnSearch:(id)sender
{
    isSerachClicked=1;
    if ([copyOfData count]==0)
    {
        hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText=@"Searching...";
    }
    else
    {
        [self searching];
        
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Search"])
    {
        SearchResultViewController *sr =(SearchResultViewController *)segue.destinationViewController;
        sr.data=data;
        if([tabBar.eventDetail count] > 0)
        {
            sr.type=@"event";
        }
        else
        {
            sr.type=@"deal";
        }
        self.hidesBottomBarWhenPushed = NO;
    }
}
@end
