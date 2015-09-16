//
//  EventViewController.m
//  essexpass
//
//  Created by Paras Chodavadiya on 08/01/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import "EventViewController.h"
#import "ServiceCall.h"
#import "Contant.h"
#import "EventTableViewCell.h"
#import "MenuTableViewCell.h"
#import "MBProgressHUD.h"
#import "SubDealsViewController.h"
#import "SubTabBarViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "NearMeEventTableViewCell.h"
#import <CoreLocation/CoreLocation.h>
#import "LoadImage.h"
#import "FillRate.h"
#import "ConvertDate.h"

//qtree
#import "QTree.h"
#import "QCluster.h"
#import "ClusterAnnotationView.h"
#import "CustomAnnotation.h"

@interface EventViewController ()
{
    int count;
    CLLocationManager *locationManager;
    NSMutableArray *category;
    NSMutableArray *popular_event;
    
    NSMutableDictionary *userDetail;
    
    NSMutableArray *EventList,*EventListCopy;
    NSMutableDictionary *eventListDict;
    NSMutableArray *dateList;
    NSMutableArray *nearbyData,*nearbyDataCopy;
    NSMutableArray *dateListForCalendar;
    
    NSMutableDictionary *event_Detail;
    NSMutableDictionary *popular_Event_Detail;
    NSMutableDictionary *category_Detail;
    
    NSMutableArray *selectedCategory;
    NSMutableArray *selectedCategoryId;
    NSString *selectedCategoryString;

    NSString *selectedEventId, *headerDate;
   
    NSString *latitude,*longitude,*distance;
    
    NSMutableDictionary *nearbyDetail;
    NSDate *selectedDate;    
    LoadImage *image;
    FillRate *star;
    ConvertDate *dateConvert;
    BOOL useClustering,isLoadOrAppear,isDisplayMBhud,isDataByDate;
    NSDate *rangeDate,*lastDate;
    int round;
    
    BOOL isFirstTimeAll,isFirstTimeFav,isFirstTimeNearBy;
    
    NSMutableDictionary *eventListDictCopy,*eventListDictFavCopy,*eventListDictNearCopy,*eventListDictDateCopy;
    NSMutableArray *dateListCopy,*dateListFavCopy,*dateListDateCopy;
    NSString *selectedDateForFav,*selectedDateForNearBy;
    int countForNoOfRecord;
    AFHTTPRequestOperationManager *managerForRetraiveData;
}
@end

@implementation EventViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    userDetail=[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"];
    
    countForNoOfRecord=0;
    
    image=[[LoadImage alloc]init];
    star=[[FillRate alloc]init];
    dateConvert=[[ConvertDate alloc]init];
    
    nearbyData = [[NSMutableArray alloc]init];
    dateListForCalendar=[[NSMutableArray alloc]init];
    
    eventListDictFavCopy=[[NSMutableDictionary alloc]init];
    eventListDictNearCopy=[[NSMutableDictionary alloc]init];
    dateListFavCopy=[[NSMutableArray alloc]init];
    
    selectedDateForFav=@"0";
    selectedDateForNearBy=@"0";
    
    //pullToRefreshManager_ = [[MNMBottomPullToRefreshManager alloc] initWithPullToRefreshViewHeight:45.0f tableView:_tveventlist withClient:self];
    
    _menuView.layer.borderColor=[UIColor colorWithRed:24.0/255.0 green:40.0/255.0 blue:83.0/255.0 alpha:1.0].CGColor;
    _menuView.layer.borderWidth=1.0;
    
    useClustering=1;
    isLoadOrAppear=1;
    isFirstTimeAll=1;
    isFirstTimeFav=1;
    isFirstTimeNearBy=1;
    isDisplayMBhud=0;
    isDataByDate=0;
    round=1;
    count=1;
    
    rangeDate=[[NSDate alloc]init];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *strRangedate = [dateFormat stringFromDate:rangeDate];
    rangeDate=[dateFormat dateFromString:strRangedate];
    
    distance=@"8.04672";
    
    [self.tabBarController.tabBar setHidden:NO];
    
    selectedCategory =[[NSMutableArray alloc]init];
    selectedCategoryId=[[NSMutableArray alloc]init];
    selectedCategoryString=[[NSString alloc]init];
    
    [self retriveDateList];
    
    managerForRetraiveData = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:GETEVENT]];
    
    //Location
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
    
    //Calendar
    [self calendarinit];
    _viewClassicCalendar.layer.borderWidth=1.5f;
    _viewClassicCalendar.layer.borderColor=[UIColor colorWithRed:24.0/255.0 green:40.0/255.0 blue:83.0/255.0 alpha:1.0].CGColor;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    //[pullToRefreshManager_ relocatePullToRefreshView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:NO];
    
    [_viewClassicCalendar setHidden:true];
    [_btnCalendar setBackgroundImage:[UIImage imageNamed:@"btn_calendar.png"] forState:UIControlStateNormal];
    [_menuView setHidden:true];
    
    if(latitude != nil && longitude != nil)
        [self retriveData];
    //displayData=@"EventList";
    //    if(_btnPage.selectedSegmentIndex == 0)
    //        [self retriveData];
    //    else if(_btnPage.selectedSegmentIndex == 1)
    //        [self getFavEvent];
    //    else if(_btnPage.selectedSegmentIndex == 2)
    //        [self retriveNearbyData:@""];
    
}

//-(void) retriveNearbyData
//{
//    dateList=[self getDateList:eventListDictCopy];
//    NSMutableArray *temp=[[NSMutableArray alloc]init];
//    NSMutableArray *temp2=[[NSMutableArray alloc]init];
//    for (int i=0; i<[eventListDictCopy count]; i++)
//    {
//        temp2=[eventListDictCopy objectForKey:[dateList objectAtIndex:i]];
//        for (int j=0;j<[temp2 count];j++)
//        {
//            event_Detail=[temp2 objectAtIndex:j];
//            //NSLog(@"Name : %@ Fav : %@",[event_Detail objectForKey:@"eventName"],[event_Detail objectForKey:@"isFavourite"]);
//            if ([[event_Detail objectForKey:@"distance_in_km"]floatValue] <= 8.04672f)
//            {
//                Boolean flag=1;
//                for (int k=0; k<[temp count]; k++)
//                {
//                    NSMutableDictionary *tempDetail=[temp objectAtIndex:k];
//                    if ([[tempDetail objectForKey:@"eventId"] isEqual: [event_Detail objectForKey:@"eventId"]])
//                    {
//                        flag=0;
//                        break;
//                    }
//                }
//                if (flag) {
//                    [temp addObject:event_Detail];
//                }
//            }
//        }
//    }
//    
//    
//    nearbyData=[self DoShortByDistance:temp];
////    nearbyDataCopy=temp;
//    
//    //NSLog(@"%@",nearbyData);
//    
//    [_tvNearby reloadData];
//    [self loadData];   
//
//}

- (NSMutableArray *)DoShortByDistance :(NSMutableArray *)unsortArray
{
    
    NSArray *sortedObjs = [unsortArray sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        float fval = [[(NSMutableDictionary *)a objectForKey:@"distance_in_km"] floatValue];
        float sval = [[(NSMutableDictionary *)b objectForKey:@"distance_in_km"] floatValue];
        
        if(fval>sval)
            return 1;
        else
            return 0;
    }];
    return [NSMutableArray arrayWithArray:sortedObjs];
}

-(void)fillData
{
    int noOfEvent=[nearbyData count];
    for(int i=0;i<noOfEvent;i++)
    {
        nearbyDetail=[nearbyData objectAtIndex:i];
        MKPointAnnotation *eventAnnotation = [[MKPointAnnotation alloc]init];
        
        CLLocationCoordinate2D pinCoordinate;
        pinCoordinate.latitude = [[nearbyDetail objectForKey:@"latitude"]doubleValue];//latitude;
        pinCoordinate.longitude = [[nearbyDetail objectForKey:@"longitude"]doubleValue];//longitude;
        
        eventAnnotation.coordinate = pinCoordinate;
        eventAnnotation.title=[nearbyDetail objectForKey:@"name"];
        
        [_mvNearby addAnnotation:eventAnnotation];
    }
}

#pragma mark Calendar
-(void)calendarinit{
    self.calendar = [JTCalendar new];
    
    // All modifications on calendarAppearance have to be done before setMenuMonthsView and setContentView
    // Or you will have to call reloadAppearance
    {
        self.calendar.calendarAppearance.calendar.firstWeekday = 2; // Sunday == 1, Saturday == 7
        self.calendar.calendarAppearance.dayCircleRatio = 1.;
        self.calendar.calendarAppearance.ratioContentMenu = 1.;
    }
    [self.calendar.calendarAppearance setWeekDayTextColor:[UIColor blackColor]];
    [self.calendar.calendarAppearance setDayTextColor:[UIColor blackColor]];
    [self.calendar.calendarAppearance setDayTextColorToday:[UIColor whiteColor]];
    [self.calendar.calendarAppearance setMenuMonthTextColor:[UIColor blackColor]];
    
    //[self.calendar calendarAppearance ];
    [self.calendar.calendarAppearance setDayDotColorForAll:[UIColor colorWithRed:234.0/255.0 green:147.0/255.0 blue:0.0/255.0 alpha:1.0]];
    [self.calendar.calendarAppearance setDayCircleColorToday:[UIColor colorWithRed:24.0/255.0 green:40.0/255.0 blue:83.0/255.0 alpha:1.0]];
    
//    self.calendar.calendarAppearance.dayDotRatio=1.0f;
    
    [self.calendar.calendarAppearance setWeekDayFormat:JTCalendarWeekDayFormatSingle];
    
    [self.calendar setMenuMonthsView:self.CalMenuView];
    [self.calendar setContentView:self.calView];
    [self.calendar setDataSource:self];
    [self.calendar setCurrentDate:[NSDate date]];
    //[self.calendar setDayDotColorForAll:[UIColor redColor]];
    
//    - (void)setDayDotColorForAll:(UIColor *)dotColor
    //self.calView.frame = CGRectMake(self.calView.frame.origin.x, self.calView.frame.origin.y, self.calView.frame.size.width-100, self.calView.frame.size.height);
}


- (IBAction)didGoEventListTouch
{
    [self.calendar setCurrentDate:[NSDate date]];
}

- (BOOL)calendarHaveEvent:(JTCalendar *)calendar date:(NSDate *)date
{
    selectedDate = date;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *date1=[df stringFromDate:selectedDate];
    
    NSDate *today=[[NSDate alloc]init];
    NSString *today1=[df stringFromDate:today];
    
    for (int i=0; i<[dateListForCalendar count];i++)
    {
        if([date1 isEqualToString:[dateListForCalendar objectAtIndex:i]])
        {
            if([today1 isEqualToString:date1])
            {
                return NO;
            }
            return YES;
        }
    }
    return  NO;
}

- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date
{
    //NSDate *selectedDate = date;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *date1=[df stringFromDate:date];
    
    selectedCategory =[[NSMutableArray alloc]init];
    for (int i=0;i<[category count]; i++) {
        [selectedCategory addObject:[NSString stringWithFormat:@"%d",i]];
    }
    [_tvMenu reloadData];
    
    
    if (_btnPage.selectedSegmentIndex == 2)
    {
        count=1;
        selectedDateForNearBy=date1;
        [locationManager startUpdatingLocation];
    }
    else if (_btnPage.selectedSegmentIndex == 1)
    {
        count=1;
        selectedDateForFav=date1;
        [locationManager startUpdatingLocation];
    }
    else if (_btnPage.selectedSegmentIndex == 0)
    {
        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText=@"Get Events By Date...";
        NSString *email=[userDetail objectForKey:@"email"];
        
        NSMutableDictionary *jsonData =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        email,@"userEmail",
                                        date1,@"date",nil];
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:GETEVENTBYDATE]];
        
        AFHTTPRequestOperation *op = [manager POST:GETEVENTBYDATE parameters:jsonData constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        }
               success:^(AFHTTPRequestOperation *operation, id responseObject)
          {
              [hud hide:YES];
              //NSLog(@"%@",responseObject);
              if([[responseObject objectForKey:@"Result"]isEqualToString:@"True"])
              {
                  eventListDictCopy=[[responseObject objectForKey:@"eventlist"]mutableCopy];
                  eventListDictDateCopy=[[responseObject objectForKey:@"eventlist"]mutableCopy];
                  dateList=[[self getDateList:eventListDictCopy]mutableCopy];
                  dateListDateCopy=[[self getDateList:eventListDictCopy]mutableCopy];
                  
                  isDisplayMBhud=1;
                  isDataByDate=1;
              }
              //NSLog(@"@",dateList);
              [self filterByCategory];
              //[_tveventlist reloadData];
          }
               failure:^(AFHTTPRequestOperation *operation, NSError *error)
          {
              NSLog(@"Error : %@",error);
              [hud hide:YES];
          }
          ];
        [op start];
    }
    
    [_btnCalendar setBackgroundImage:[UIImage imageNamed:@"btn_calendar.png"] forState:UIControlStateNormal];
    _viewClassicCalendar.hidden=true;
    
}

- (IBAction)btnRefresh:(id)sender
{
    
    [_btnCalendar setBackgroundImage:[UIImage imageNamed:@"btn_calendar.png"] forState:UIControlStateNormal];
    _viewClassicCalendar.hidden=true;
    
    rangeDate=[[NSDate alloc]init];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *strRangedate = [dateFormat stringFromDate:rangeDate];
    rangeDate=[dateFormat dateFromString:strRangedate];
    
    [managerForRetraiveData.operationQueue cancelAllOperations];
    
    selectedDateForFav=@"0";
    selectedDateForNearBy=@"0";
    
    round=1;
    count=1;
    //isLoadOrAppear=1;
    isDataByDate=0;
    [locationManager startUpdatingLocation];
}

-(void)FillPopular
{
    [[_svPopularEvent subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];

    int Count=[popular_event count];
    //NSLog(@"Count : %d",Count);
    
    int size=(120*Count)+16;
    [_svPopularEvent setContentSize:CGSizeMake(size, 109)];
    
    int xpos=10;
    for(int i=0;i < Count;i++)
    {
        popular_Event_Detail=[popular_event objectAtIndex:i];
        
        UIView *eventView=[[UIView alloc]initWithFrame:CGRectMake(xpos, 0,115,109)];
        [_svPopularEvent addSubview:eventView];
        
        UIImageView *ivBackground =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 115, 109)];
        ivBackground.image=[UIImage imageNamed:@"view_background.png"];
        
        [eventView addSubview:ivBackground];
        
        UILabel *lbleventName=[[UILabel alloc]initWithFrame:CGRectMake(5, 3, 105, 20)];
        lbleventName.text=[popular_Event_Detail objectForKey:@"eventName"];
        [lbleventName setFont:[UIFont systemFontOfSize:13]];
        lbleventName.textColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
        lbleventName.textAlignment = NSTextAlignmentCenter;
        
        [eventView addSubview:lbleventName];
        
        
        UIImageView *ivEvent=[[UIImageView alloc]initWithFrame:CGRectMake(5, 25, 105, 75)];
        ivEvent.contentMode = UIViewContentModeScaleAspectFill;
        ivEvent.clipsToBounds =YES;
        
        ivEvent.image=[UIImage imageNamed:@"cell_background.png"];
        
        NSString *basicurl = [popular_Event_Detail objectForKey:@"image"];
        
        [image loadImage:basicurl ImageView:ivEvent ActivityIndicator:nil];
        
        [eventView addSubview:ivEvent];
        
        UIButton *btnEvent=[[UIButton alloc]initWithFrame:CGRectMake(0, 0,81,109)];
        [btnEvent addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
        [btnEvent setTag:i];
        [eventView addSubview:btnEvent];
        
        xpos=xpos+120;
    }
}

-(void)btnEvent:(UIButton *)sender
{
    event_Detail=[popular_event objectAtIndex:sender.tag];
    selectedEventId=[event_Detail objectForKey:@"eventId"];
    
    headerDate=[dateConvert convertDate:[event_Detail objectForKey:@"startDate"] Enddate:[event_Detail objectForKey:@"endDate"] StartTime:[event_Detail objectForKey:@"startTime"] EndTime:[event_Detail objectForKey:@"endTime"]];
    
    [self.tabBarController.tabBar setHidden:YES];
    [self performSegueWithIdentifier:@"Detail" sender:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == _tveventlist )//&& _btnPage.selectedSegmentIndex == 0 && [EventList count] == 0)
        //return [eventListDict count];
        return [dateList count];
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView == _tveventlist)
    {
        return 27;
    }
    return 0;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView == _tveventlist)
    {
        UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 27)];
        
        UIImageView *backgroung=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, headerView.bounds.size.width, 27)];
        backgroung.image=[UIImage imageNamed:@"lbl_background2.png"];
        [headerView addSubview:backgroung];
    
        UILabel *lblDate=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, headerView.bounds.size.width, 27)];
        lblDate.textColor=[UIColor whiteColor];
        [lblDate setFont:[UIFont systemFontOfSize:15]];
        [headerView addSubview:lblDate];
        
//        if([EventList count] == 0)
//        {
//            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//            [dateFormat setDateFormat:@"EEE. dd MMM yyyy"];
//            NSString *formmatedDate = [dateFormat stringFromDate:selectedDate];
//            
//            lblDate.text=[NSString stringWithFormat:@"%@",formmatedDate];
//            return headerView;
//        }
        
        NSString *dateOfHeader=[dateList objectAtIndex:section];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd"];
        NSString *today=[df stringFromDate:[NSDate date]];
        NSString *tommorow=[df stringFromDate:[[NSDate date] dateByAddingTimeInterval:60*60*24*1]];
        
        if ([dateOfHeader isEqual:today])
        {
            lblDate.text=@"Today";
        }
        else if([dateOfHeader isEqual:tommorow])
        {
            lblDate.text=@"Tomorrow";
        }
        else
        {
            NSDate *tempDate=[df dateFromString:dateOfHeader];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"EEE. dd MMM yyyy"];
            NSString *formmatedDate = [dateFormat stringFromDate:tempDate];

            lblDate.text=[NSString stringWithFormat:@"%@",formmatedDate];
        }
        
        [lblDate setFont:[UIFont systemFontOfSize:15]];
        [headerView addSubview:lblDate];
        return headerView;
    }
    return 0;
}

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return headerDate;
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == _tveventlist)
    {
//        if (isDataByDate)
//        {
//            EventList=[eventListDict objectForKey:[dateList objectAtIndex:section]];
//            return [EventList count];
//        }
        EventList=[eventListDict objectForKey:[dateList objectAtIndex:section]];
        return [EventList count];
        
    }
    else if (tableView == _tvMenu)
    {
        if([category count] == 0)
            return [category count];
        else
            return ([category count]+1);
    }
    else if (tableView == _tvNearby)
    {
        //NSLog(@"%@",nearbyData);
        return [nearbyData count];
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{ 
    
    if(tableView == _tveventlist)
    {
        static NSString *CellIdentifier = @"SimpleTableCell";
        
        EventTableViewCell *eventCell = (EventTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(eventCell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EventTableViewCell" owner:self options:nil];
            eventCell = [nib objectAtIndex:0];
        }
        
        @try {
            
        
        //NSLog(@"index path :%ld",(long)indexPath.row);
        
        if([indexPath row ] % 2 != 0)
        {
            eventCell.backgroundColor=[UIColor colorWithRed:202.0/255.0 green:202.0/255.0 blue:205.0/255.0 alpha:1.0];
        }
        
        //if (_btnPage.selectedSegmentIndex == 0 && [EventList count] == 0)
        //{
            EventList=[eventListDict objectForKey:[dateList objectAtIndex:indexPath.section]];
        //}
        event_Detail=[EventList objectAtIndex:indexPath.row];
        
        eventCell.lblName.text = [event_Detail objectForKey:@"eventName"];
        eventCell.lblDescription.text=[event_Detail objectForKey:@"city"];
        NSString *timeWithOutFormte=[event_Detail objectForKey:@"startTime"];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"HH:mm:ss"];
        NSDate *date1=[df dateFromString:timeWithOutFormte];
        [df setDateFormat:@"HH:mm"];
        NSString *endTime=[df stringFromDate:date1];
        eventCell.lblTime.text = endTime;
        
        NSString *basicurl = [event_Detail objectForKey:@"image"];
        [image loadImage:basicurl ImageView:eventCell.ivImage ActivityIndicator:nil];
        
        }
        @catch (NSException *exception) {
            NSLog(@"Catch");
        }
        @finally {
            return eventCell;
        }
        
    }
    else if (tableView == _tvMenu)
    {
        static NSString *CellIdentifier = @"SimpleTableCell";
        
        MenuTableViewCell *categoryCell = (MenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(categoryCell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MenuTableViewCell" owner:self options:nil];
            categoryCell = [nib objectAtIndex:0];
        }
        
        if (indexPath.row == 0)
        {
            categoryCell.btnCategory.tag=-1;
            [categoryCell.btnCategory addTarget:self action:@selector(btnCategory:) forControlEvents:UIControlEventTouchUpInside];
            categoryCell.lblCategory.text=@"All";
            
            if ([selectedCategory count] == [category count]) {
                [categoryCell.btnCategory setImage:[UIImage imageNamed:@"icon_round.png"] forState:UIControlStateNormal ];
            }
            else
            {
                [categoryCell.btnCategory setImage:[UIImage imageNamed:nil] forState:UIControlStateNormal ];
            }
            
            return categoryCell;
        }
        
        category_Detail=[category objectAtIndex:indexPath.row-1];
        //NSLog(@"%@",[category_Detail objectForKey:@"categoryName"]);
        
        //[categoryCell.btnCategory setTitle:[category_Detail objectForKey:@"categoryName"] forState:UIControlStateNormal];
        
        categoryCell.btnCategory.tag=indexPath.row-1;
        [categoryCell.btnCategory addTarget:self action:@selector(btnCategory:) forControlEvents:UIControlEventTouchUpInside];
        categoryCell.lblCategory.text=[category_Detail objectForKey:@"categoryName"];
        
        BOOL availableTag = [selectedCategory containsObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row-1]];
        if(availableTag)
        {
            [categoryCell.btnCategory setImage:[UIImage imageNamed:@"icon_round.png"] forState:UIControlStateNormal ];
        }
        else
        {
            [categoryCell.btnCategory setImage:[UIImage imageNamed:nil] forState:UIControlStateNormal ];
        }
        
        return categoryCell;
    }
    else if (tableView == _tvNearby)
    {
        static NSString *CellIdentifier = @"SimpleTableCell";
        
        NearMeEventTableViewCell *eventCell = (NearMeEventTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(eventCell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NearMeEventTableViewCell" owner:self options:nil];
            eventCell = [nib objectAtIndex:0];
        }
        
        @try {
           
        nearbyDetail=[nearbyData objectAtIndex:indexPath.row];
        
        //NSLog(@"%@",nearbyDetail);
        
        float finaldistance=[[nearbyDetail objectForKey:@"distance_in_km"]floatValue]*0.621371;
        eventCell.lblDistance.text=[NSString stringWithFormat:@"%.2f",finaldistance];
        eventCell.lblMeasure.text=@"Miles";
        eventCell.lblEventname.text=[nearbyDetail objectForKey:@"eventName"];
        eventCell.lblLocation.text=[nearbyDetail objectForKey:@"city"];
//        NSString *time=[NSString stringWithFormat:@"%@ %@",[nearbyDetail objectForKey:@"endDate"],[nearbyDetail objectForKey:@"endTime"] ];
//        eventCell.lblTime.text=time;
        eventCell.lblDiscount.text=[NSString stringWithFormat:@"%@%@",[nearbyDetail objectForKey:@"discount"],@"%"];
        
        
        //for display image
        NSString *basicurl = [nearbyDetail objectForKey:@"image"];
        [image loadImage:basicurl ImageView:eventCell.ivEvent ActivityIndicator:nil];
        
        //for rate
        float rate=[[nearbyDetail objectForKey:@"rate"]floatValue];
        [star FillRate:rate FirstImageView:eventCell.ivFirstStar SecondImageView:eventCell.ivSecondStar ThirdImageView:eventCell.ivThirdStar FourthImageView:eventCell.ivFourthStar FifthImageView:eventCell.ivFifthStar];
        
        }
        @catch (NSException *exception) {
            NSLog(@"Catch");
        }
        @finally {
            
            return eventCell;
        }
    }

    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_txtSearchBar resignFirstResponder];
    if (tableView == _tveventlist )
    {
//        if([EventList count] == 0)
        EventList=[eventListDict objectForKey:[dateList objectAtIndex:indexPath.section]];

        event_Detail=[EventList objectAtIndex:indexPath.row];
        selectedEventId=[event_Detail objectForKey:@"eventId"];
        headerDate=[dateConvert convertDate:[dateList objectAtIndex:indexPath.section] StartTime:[event_Detail objectForKey:@"startTime"] EndTime:[event_Detail objectForKey:@"endTime"]];
        
        [self.tabBarController.tabBar setHidden:YES];
        
        [self performSegueWithIdentifier:@"Detail" sender:self];
    }
    else if (tableView == _tvNearby)
    {
        
        event_Detail=[nearbyData objectAtIndex:indexPath.row];
        //NSLog(@"%@",category_Detail);
        selectedEventId=[event_Detail objectForKey:@"eventId"];
        headerDate=[dateConvert convertDate:[event_Detail objectForKey:@"startDate"] Enddate:[event_Detail objectForKey:@"endDate"] StartTime:[event_Detail objectForKey:@"startTime"] EndTime:[event_Detail objectForKey:@"endTime"]];
        
        [self.tabBarController.tabBar setHidden:YES];
        
        [self performSegueWithIdentifier:@"Detail" sender:self];
    }
}

//#pragma mark PullToRefresh
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (_btnPage.selectedSegmentIndex ==0 && rangeDate <= lastDate && !isDisplayMBhud)
//    {
//        [pullToRefreshManager_ setPullToRefreshViewVisible:true];
//        [pullToRefreshManager_ tableViewScrolled];
//    }
//    else
//    {
//        [pullToRefreshManager_ setPullToRefreshViewVisible:false];
//    }
//}
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    if (_btnPage.selectedSegmentIndex == 0 && rangeDate <= lastDate && !isDisplayMBhud)
//    {
//        [pullToRefreshManager_ tableViewReleased];
//    }
//}
//- (void)bottomPullToRefreshTriggered:(MNMBottomPullToRefreshManager *)manager
//{
//    if (_btnPage.selectedSegmentIndex == 0 && rangeDate <= lastDate && !isDisplayMBhud)
//    {
//        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//        [dateFormat setDateFormat:@"yyyy-MM-dd"];
//        NSString *strRangedate = [dateListCopy objectAtIndex:[dateListCopy count]-1];
//        rangeDate=[dateFormat dateFromString:strRangedate];
//
//        rangeDate = [rangeDate dateByAddingTimeInterval:60*60*24*1];
//        
//        [self retriveData];
//        round+=1;
//    }
//}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Detail"])
    {
        SubTabBarViewController *st = (SubTabBarViewController *)segue.destinationViewController;
        st.eventId=selectedEventId;
        st.eventDetail=event_Detail;
        st.dealId=0;
        st.headerDate=headerDate;
//        NSLog(@"%@",st.headerDate);
    }
}

-(void)btnCategory:(UIButton*)sender
{
    UIImage *imageFill= sender.currentImage;
    UIImage *imageForCheck=[UIImage imageNamed:nil];
   
    NSData *data1 = UIImagePNGRepresentation(imageFill);
    NSData *data2 = UIImagePNGRepresentation(imageForCheck);
  
    NSString *selectedTag=[NSString stringWithFormat:@"%ld",(long)sender.tag];
    
    if(data1 == data2)
    {
        
        [sender setImage:[UIImage imageNamed:@"icon_round.png"] forState:UIControlStateNormal ];
        
        if ([selectedTag isEqualToString:@"-1"])
        {
            selectedCategory = [[NSMutableArray alloc]init];
            for (int i=0;i<[category count]; i++) {
                [selectedCategory addObject:[NSString stringWithFormat:@"%d",i]];
            }
            
        }
        else
            [selectedCategory addObject:selectedTag];
        
        [_tvMenu reloadData];
    }
    else
    {
        [sender setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal ];
        if ([selectedTag isEqualToString:@"-1"])
        {
            selectedCategory=[[NSMutableArray alloc]init];
            
        }
        else
        {
            [selectedCategory removeObject:selectedTag];
        }
        [_tvMenu reloadData];
    }

}

//-(void)dismisshud :(id)hud
//{
//    [hud hide:YES];
//}

#pragma mark - retire Data from json
-(void) retriveData
{
    MBProgressHUD *hud;
    
    if (isLoadOrAppear)
    {
        hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText=@"Loading Events...";
        [hud hide:YES afterDelay:5];
//        [self performSelector:@selector(dismisshud:) withObject:hud afterDelay:5];
        isLoadOrAppear=0;
        self.tabBarController.tabBar.userInteractionEnabled=NO;
    }

    
//    NSDate *rangedate=[[NSDate alloc]init];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *strRangedate = [dateFormat stringFromDate:rangeDate];
    
    NSString *email=[userDetail objectForKey:@"email"];
    
    NSMutableDictionary *jsonData =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   email,@"userEmail",
                                   latitude,@"latitude",
                                   longitude,@"longitude",
                                   @"0",@"distance",
                                   strRangedate,@"rangeDate",
                                   nil];
    
//    NSMutableDictionary *jsonData =[NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                    email,@"userEmail",
//                                    latitude,@"latitude",
//                                    longitude,@"longitude",
//                                    @"0",@"distance",
//                                    nil];
    
    //AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:GETEVENT]];
    
    AFHTTPRequestOperation *op = [managerForRetraiveData POST:GETEVENT parameters:jsonData constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    }
    success:^(AFHTTPRequestOperation *operation, id responseObject)
      {
          //[hud hide:YES];
          self.tabBarController.tabBar.userInteractionEnabled=YES;
          //NSLog(@"%@",responseObject);
          if([[responseObject objectForKey:@"Result"]isEqualToString:@"True"])
          {
              if (round == 1)
              {
                  if ([[responseObject objectForKey:@"eventlist"] count] == 0)
                  {
                      eventListDictCopy =[[NSMutableDictionary alloc]init];
                  }
                  else
                  {
                      eventListDictCopy =[[NSMutableDictionary alloc]initWithDictionary:[responseObject objectForKey:@"eventlist"]];
                  }
                  
                  dateListCopy=[self getDateList:eventListDictCopy];
                  
                  NSString *strLastDate=[responseObject objectForKey:@"lastdate"];
                  NSDateFormatter *df = [[NSDateFormatter alloc] init];
                  [df setDateFormat:@"yyyy-MM-dd"];
                  lastDate =[df dateFromString:strLastDate];
                  
                  //popular_event=[responseObject objectForKey:@"popular_event"];
                  //[self FillPopular];
                  
//                  category=[responseObject objectForKey:@"category"];
//                  
//                  selectedCategory =[[NSMutableArray alloc]init];
//                  for (int i=0;i<[category count]; i++) {
//                      [selectedCategory addObject:[NSString stringWithFormat:@"%d",i]];
//                  }
//                  
//                  
//                  [_tvMenu reloadData];
              }
              else
              {
                  if ([[responseObject objectForKey:@"eventlist"]count] == 0)
                  {
                      
                  }
                  else
                  {
                      [eventListDictCopy addEntriesFromDictionary:[responseObject objectForKey:@"eventlist"]];
                  }
                  dateListCopy = [self getDateList:eventListDictCopy];

              }
              isDisplayMBhud=0;
              [self filterByCategory];
              
//              //For No Of Record
//              NSMutableArray *abc=[self getDateList:[responseObject objectForKey:@"eventlist"]];
//              for (int i=0; i<[abc count]; i++)
//              {
//                  NSMutableArray *rgn=[[responseObject objectForKey:@"eventlist"]objectForKey:[abc objectAtIndex:i]];
//                  countForNoOfRecord=countForNoOfRecord+[rgn count];
//                  NSLog(@"Record : %d",countForNoOfRecord);
//              }
          }
      }
        failure:^(AFHTTPRequestOperation *operation, NSError *error)
      {
          //[hud hide:YES];
          self.tabBarController.tabBar.userInteractionEnabled=YES;
          NSLog(@"Error : %@",error);
      }
      ];
    [op start];
}

-(void) retriveDateList
{
    NSMutableDictionary *jsonData =[[NSMutableDictionary alloc]init];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:GETEVENTDATELIST]];
    
    AFHTTPRequestOperation *op = [manager POST:GETEVENTDATELIST parameters:jsonData constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    }
           success:^(AFHTTPRequestOperation *operation, id responseObject)
      {
          if([[responseObject objectForKey:@"Result"]isEqualToString:@"True"])
          {
              dateListForCalendar=[self getDateList:[responseObject objectForKey:@"dateList"]];
              
              [self calendarinit];
          }
      }
           failure:^(AFHTTPRequestOperation *operation, NSError *error)
      {
          self.tabBarController.tabBar.userInteractionEnabled=YES;
          NSLog(@"Error : %@",error);
      }
      ];
    [op start];
}

-(id)getDateList :(NSMutableDictionary *)Dictionary
{
    if ([Dictionary count] == 0)
    {
        return 0;
    }
    return [[[Dictionary allKeys]sortedArrayUsingSelector:@selector(compare:)]mutableCopy];
}

-(void) retrivePopularEvent
{
    NSMutableDictionary *jsonData =[[NSMutableDictionary alloc]init];
    
    AFHTTPRequestOperationManager *managerForPopularEvent = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:GETPOPULAREVENT]];
    
    AFHTTPRequestOperation *op = [managerForPopularEvent POST:GETPOPULAREVENT parameters:jsonData constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    }
           success:^(AFHTTPRequestOperation *operation, id responseObject)
      {
          if([[responseObject objectForKey:@"Result"]isEqualToString:@"True"])
          {
              popular_event=[responseObject objectForKey:@"popular"];
              [self FillPopular];
          }
      }
           failure:^(AFHTTPRequestOperation *operation, NSError *error)
      {
          self.tabBarController.tabBar.userInteractionEnabled=YES;
          NSLog(@"Error : %@",error);
      }
      ];
    [op start];
}

-(void) retriveCategory
{
    NSMutableDictionary *jsonData =[[NSMutableDictionary alloc]init];
    
    AFHTTPRequestOperationManager *managerForPopularEvent = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:GETEVENTCATEGORY]];
    
    AFHTTPRequestOperation *op = [managerForPopularEvent POST:GETEVENTCATEGORY parameters:jsonData constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    }
    success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        if([[responseObject objectForKey:@"Result"]isEqualToString:@"True"])
        {
          category=[responseObject objectForKey:@"category"];              
          selectedCategory =[[NSMutableArray alloc]init];
          
          for (int i=0;i<[category count]; i++)
          {
              [selectedCategory addObject:[NSString stringWithFormat:@"%d",i]];
          }
          
          [_tvMenu reloadData];
        }
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        self.tabBarController.tabBar.userInteractionEnabled=YES;
        NSLog(@"Error : %@",error);
    }
    ];
    [op start];
}

-(void) retriveFavData
{
    MBProgressHUD *hud;
    
    hud=[MBProgressHUD showHUDAddedTo:self.view Tabbar:self.tabBarController.tabBar animated:YES];
    hud.labelText=@"Loading Deals...";
    self.tabBarController.tabBar.userInteractionEnabled=NO;
    
    NSString *email=[userDetail objectForKey:@"email"];
    NSMutableDictionary *jsonDictionary =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                          email,@"userEmail",
                                          selectedDateForFav,@"createdate",
                                          nil];
    AFHTTPRequestOperationManager *getFavDealManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:GETFAVEVENT]];
    
    AFHTTPRequestOperation *op = [getFavDealManager POST:GETFAVEVENT parameters:jsonDictionary constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    }
                                  
    success:^(AFHTTPRequestOperation *operation, id responseObject)
      {
          [hud hide:YES];
          self.tabBarController.tabBar.userInteractionEnabled=YES;
          //NSLog(@"%@",responseObject);
          if([[responseObject objectForKey:@"Result"]isEqualToString:@"True"])
          {
              if ([[responseObject objectForKey:@"eventlist"] count] == 0)
              {
                  eventListDictFavCopy =[[NSMutableDictionary alloc]init];
                  dateListFavCopy=[self getDateList:eventListDictFavCopy];
              }
              else
              {
                  eventListDictFavCopy =[[NSMutableDictionary alloc]initWithDictionary:[responseObject objectForKey:@"eventlist"]];
                  dateListFavCopy=[self getDateList:eventListDictFavCopy];
              }
              
              [self filterByCategoryFav];
              isFirstTimeFav=0;
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

-(void) retriveNearByData
{
    MBProgressHUD *hud;
    
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"Loading Events...";
    
    NSString *email=[userDetail objectForKey:@"email"];
    
    NSMutableDictionary *jsonDictionary =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                          latitude,@"latitude",
                                          longitude,@"longitude",
                                          email,@"userEmail",
                                          distance,@"distance",
                                          selectedDateForNearBy,@"date",
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
//              eventListDictNearCopy =[[NSMutableDictionary alloc]initWithDictionary:[responseObject objectForKey:@"eventlist"]];
//              [self filterByCategory];
              isFirstTimeNearBy=0;
              nearbyDataCopy=[responseObject objectForKey:@"event"];
              [self filterByCategoryNearBy];
          }
          isFirstTimeNearBy=0;
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

- (IBAction)btnCalendar:(id)sender {
    
//    if(_calendarView.hidden == true)
//    {
//        _calendarView.hidden=false;
//    }
//    else
//    {
//        _calendarView.hidden=true;
//    }
    _menuView.hidden=true;
    [_txtSearchBar resignFirstResponder];
    
    if(_viewClassicCalendar.hidden == true)
    {
        _viewClassicCalendar.hidden=false;
        [_btnCalendar setBackgroundImage:[UIImage  imageNamed:@"btn_cancel.png"] forState:UIControlStateNormal];
    }
    else
    {
        _viewClassicCalendar.hidden=true;
        [_btnCalendar setBackgroundImage:[UIImage  imageNamed:@"btn_calendar.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)datePicker:(id)sender {
    
}
- (IBAction)btnDone:(id)sender
{
    
//    NSDate *selectedDate = _datePicker.date;
//    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//    [df setDateFormat:@"yyyy-MM-dd"];
//    NSString *date=[df stringFromDate:selectedDate];
//    _calendarView.hidden=true;
    
}
- (IBAction)btnmenu:(id)sender {
    
    [_txtSearchBar resignFirstResponder];
    _viewClassicCalendar.hidden=true;
    [_btnCalendar setBackgroundImage:[UIImage  imageNamed:@"btn_calendar.png"] forState:UIControlStateNormal];
    
    if(_menuView.hidden == true)
    {
        _menuView.hidden=false;
    }
    else
    {
        _menuView.hidden=true;
    }
    
}
- (IBAction)btnDoneMenu:(id)sender
{
    if (_btnPage.selectedSegmentIndex == 2)
    {
        [self filterByCategoryNearBy];
    }
    else if (_btnPage.selectedSegmentIndex == 0)
    {
        [self filterByCategory];
    }
    else
    {
        [self filterByCategoryFav];
    }
    _menuView.hidden=true;
}

-(void)filterByCategory
{
    int noOfRecord=[selectedCategory count];

//    if (!isDataByDate)
//    {
    NSMutableDictionary *eventListDictTemp=[[NSMutableDictionary alloc]init];
    NSMutableArray *dateListTemp=[[NSMutableArray alloc]init];
    if (!isDataByDate)
    {
        eventListDictTemp =eventListDictCopy;
        dateListTemp=dateListCopy;
    }
    else
    {
        eventListDictTemp=eventListDictDateCopy;
        dateListTemp=dateListDateCopy;
    }
//        NSMutableDictionary *eventListDictTemp =eventListDictCopy;
//        NSMutableArray *dateListTemp=dateListCopy;

        //dateList=[[[eventListDict allKeys]sortedArrayUsingSelector:@selector(compare:)]mutableCopy];
        NSMutableDictionary *dictemp=[[NSMutableDictionary alloc]init];
        NSMutableDictionary *dicttemp2=[[NSMutableDictionary alloc]init];
        NSMutableArray *temp2=[[NSMutableArray alloc]init];
        for (int i=0; i<[eventListDictTemp count]; i++)
        {
            NSMutableArray *temp=[[NSMutableArray alloc]init];
            temp2=[eventListDictTemp objectForKey:[dateListTemp objectAtIndex:i]];
            for (int j=0;j<[temp2 count];j++)
            {
                event_Detail=[temp2 objectAtIndex:j];

                //NSLog(@"Name : %@ Fav : %@",[event_Detail objectForKey:@"eventName"],[event_Detail objectForKey:@"isFavourite"]);
                for (int k=0; k<noOfRecord; k++)
                {
                    int index=[[selectedCategory objectAtIndex:k]integerValue];
                    category_Detail=[category objectAtIndex:index];
                    if([[event_Detail objectForKey:@"categoryId"] isEqualToString:[category_Detail objectForKey:@"categoryId" ]])
                    {
                        [temp addObject:event_Detail];
                    }
                }
            }
            if ([temp count]>0)
            {
                dictemp = [NSMutableDictionary dictionaryWithObjectsAndKeys:temp,[dateListTemp objectAtIndex:i], nil];
                
                [dicttemp2 addEntriesFromDictionary:dictemp];
            }
            
        }
        
        if(_btnPage.selectedSegmentIndex == 0 )
        {
////            eventListDict=dicttemp2;
////            dateList=[self getDateList:eventListDict];
////            [_tveventlist reloadData];
            
            [self searchingWhenGetData:[self getDateList:dicttemp2]:dicttemp2];
            
            if (!isDataByDate)
            {
//                NSLog(@"Ranage Date : %d",rangeDate <= lastDate);
//                NSLog(@"Ranage Date : %d",[rangeDate compare:lastDate] == NSOrderedAscending);
//                NSLog(@"MBHud : %d",!isDisplayMBhud);
                
                
                //if (_btnPage.selectedSegmentIndex == 0 && rangeDate <= lastDate)// && !isDisplayMBhud)
                if (_btnPage.selectedSegmentIndex == 0 && ([rangeDate compare:lastDate] == NSOrderedAscending || [rangeDate compare:lastDate] == NSOrderedSame) && !isDisplayMBhud)
                {
//                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//                    [dateFormat setDateFormat:@"yyyy-MM-dd"];
//                    NSString *strRangedate = [dateListCopy objectAtIndex:[dateListCopy count]-1];
//                    rangeDate=[dateFormat dateFromString:strRangedate];
                    rangeDate= [rangeDate dateByAddingTimeInterval:60*60*24*3];
                    
                    [self retriveData];
                    round+=1;
                }
            }
        }
//    }
}

-(void)searchingWhenGetData:(NSMutableArray *)dateListForSearching :(NSMutableDictionary *)eventListDictForSearching
{
    if([_txtSearchBar.text length] == 0)
    {
        eventListDict=eventListDictForSearching;
        dateList=dateListForSearching;
       
        //[_txtSearchBar resignFirstResponder];
        [_tveventlist reloadData];
        return;
    }
    
    NSMutableDictionary *dictemp=[[NSMutableDictionary alloc]init];
    NSMutableDictionary *dicttemp2=[[NSMutableDictionary alloc]init];
    NSMutableArray *temp2=[[NSMutableArray alloc]init];
    
    NSMutableArray *dateListTemp;
    NSMutableDictionary *eventListDictTemp;
    
    eventListDictTemp=eventListDictForSearching;
    dateListTemp=dateListForSearching;
    
    for (int i=0; i<[eventListDictTemp count]; i++)
    {
        NSMutableArray *temp=[[NSMutableArray alloc]init];
        temp2=[eventListDictTemp objectForKey:[dateListTemp objectAtIndex:i]];
        for (int j=0;j<[temp2 count];j++)
        {
            event_Detail=[temp2 objectAtIndex:j];
            //NSLog(@"Name : %@ Fav : %@",[event_Detail objectForKey:@"eventName"],[event_Detail objectForKey:@"isFavourite"]);
            if ([[NSString stringWithFormat:@"%@",[event_Detail objectForKey:@"eventName" ]] rangeOfString:_txtSearchBar.text options:NSCaseInsensitiveSearch].location == NSNotFound)
            {
            }
            else
            {
                if (_btnPage.selectedSegmentIndex == 1)
                {
                    if ([[event_Detail objectForKey:@"isFavourite"] isEqualToString:@"1"])
                    {
                        [temp addObject:event_Detail];
                    }
                }
                else
                {
                    [temp addObject:event_Detail];
                }
            }
        }
        if ([temp count]>0)
        {
            dictemp = [NSMutableDictionary dictionaryWithObjectsAndKeys:temp,[dateListTemp objectAtIndex:i], nil];
            
            [dicttemp2 addEntriesFromDictionary:dictemp];
        }
        
    }
    eventListDict=dicttemp2;
    dateList=[self getDateList:eventListDict];
    [_tveventlist reloadData];
}

-(void)filterByCategoryFav
{
    int noOfRecord=[selectedCategory count];
    
    eventListDict =eventListDictFavCopy;
    dateList=dateListFavCopy;

    NSMutableDictionary *dictemp=[[NSMutableDictionary alloc]init];
    NSMutableDictionary *dicttemp2=[[NSMutableDictionary alloc]init];
    NSMutableArray *temp2=[[NSMutableArray alloc]init];
    for (int i=0; i<[eventListDict count]; i++)
    {
        NSMutableArray *temp=[[NSMutableArray alloc]init];
        temp2=[eventListDict objectForKey:[dateList objectAtIndex:i]];
        for (int j=0;j<[temp2 count];j++)
        {
            event_Detail=[temp2 objectAtIndex:j];
            //NSLog(@"Name : %@ Fav : %@",[event_Detail objectForKey:@"eventName"],[event_Detail objectForKey:@"isFavourite"]);
            for (int k=0; k<noOfRecord; k++)
            {
                int index=[[selectedCategory objectAtIndex:k]integerValue];
                category_Detail=[category objectAtIndex:index];
                if([[event_Detail objectForKey:@"categoryId"] isEqualToString:[category_Detail objectForKey:@"categoryId" ]])
                {
                    [temp addObject:event_Detail];
                }
            }
        }
        if ([temp count]>0)
        {
            dictemp = [NSMutableDictionary dictionaryWithObjectsAndKeys:temp,[dateList objectAtIndex:i], nil];
            
            [dicttemp2 addEntriesFromDictionary:dictemp];
        }
    }
    
    eventListDict=dicttemp2;
    dateList=[self getDateList:eventListDict];
    [_tveventlist reloadData];
}

-(void)filterByCategoryNearBy
{
    //NSLog(@"Selected : %@",selectedCategory);
    int noOfRecord=[selectedCategory count];
    NSMutableArray *temp=[[NSMutableArray alloc]init];
    
    nearbyData=nearbyDataCopy;
    
    for (int i=0; i<nearbyData.count; i++)
    {
        NSMutableDictionary *category_Detail_deals=[nearbyData objectAtIndex:i];
        for(int j=0;j<noOfRecord;j++)
        {
            //NSLog(@"tag : %d",[selectedCategory[i]integerValue]);
            category_Detail=[category objectAtIndex:[[selectedCategory objectAtIndex:j]integerValue]];
            
            if([[category_Detail objectForKey:@"categoryId"] isEqualToString:[category_Detail_deals objectForKey:@"categoryId" ]])
            {
                [temp addObject:category_Detail_deals];
            }
        }
        //selectedCategoryId[i]=[category_Detail objectForKey:@"categoryId"];
    }
    nearbyData=temp;
    
    [_tvNearby reloadData];
    [self loadData];

}


//-(void)getByCategoryByDate : (NSString*)Date
//{
//    int noOfRecord=[selectedCategory count];
//    if(noOfRecord == 0)
//    {
//        if(_btnPage.selectedSegmentIndex == 0)
//        {
//            [_tveventlist reloadData];
//            _menuView.hidden=true;
//            _lblDate.text=@"Toady";
//            return ;
//        }
//        else if(_btnPage.selectedSegmentIndex == 1)
//        {
//            [self getFavEvent];
//            [_tveventlist reloadData];
//            _menuView.hidden=true;
//        }
//    }
//    
//    for(int i=0;i<noOfRecord;i++)
//    {
//        //NSLog(@"tag : %d",[selectedCategory[i]integerValue]);
//        category_Detail=[category objectAtIndex:[selectedCategory[i]integerValue]];
//        selectedCategoryId[i]=[category_Detail objectForKey:@"categoryId"];
//    }
//    //NSLog(@"ID : %@",selectedCategoryId);
//    
//    for(int i=0;i<noOfRecord;i++)
//    {
//        if(i==0)
//            selectedCategoryString=[NSString stringWithFormat:@"%@",selectedCategoryId[i]];
//        else
//            selectedCategoryString=[NSString stringWithFormat:@"%@,%@",selectedCategoryString,selectedCategoryId[i]];
//    }
//    
//    
//    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText=@"Loading...";
//    NSMutableDictionary *jsonData;
//    if(_btnPage.selectedSegmentIndex == 1)
//    {
//        NSString *email=[userDetail objectForKey:@"email"];
//        jsonData =[NSMutableDictionary dictionaryWithObjectsAndKeys:@"event",@"type",
//                                        selectedCategoryString,@"categoryId",
//                                        Date,@"endDate",
//                                        @"1",@"flag",
//                                        email,@"userEmail",nil];
//    }
//    else if(_btnPage.selectedSegmentIndex == 0)
//    {
//        jsonData =[NSMutableDictionary dictionaryWithObjectsAndKeys:@"event",@"type",
//                                    selectedCategoryString,@"categoryId",
//                                    Date,@"endDate",
//                                    @"1",@"flag", nil];
//    }
//    //NSLog(@"%@",jsonData);
//    
//    NSString *urlString = @"http://iblinfotechapn.com/essexpass/service/getevntdealcategoey.php";
//    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
//    
//    AFHTTPRequestOperation *op = [manager POST:urlString parameters:jsonData constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        
//    }
//                                       success:^(AFHTTPRequestOperation *operation, id responseObject)
//                                  {
//                                      [hud hide:YES];
//                                      //NSLog(@"%@",responseObject);
//                                      if([[responseObject objectForKey:@"Result"]isEqualToString:@"True"])
//                                      {
//                                          categoryEventList=[responseObject objectForKey:@"Detail"];
//                                          [_tveventlist reloadData];
//                                      }
//                                      
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
//

-(void)getFavEvent
{
    //dateList=[[[eventListDictCopy allKeys]sortedArrayUsingSelector:@selector(compare:)]mutableCopy];
    dateList=[self getDateList:eventListDictCopy];
    
    NSMutableDictionary *dictemp=[[NSMutableDictionary alloc]init];
    NSMutableDictionary *dicttemp2=[[NSMutableDictionary alloc]init];
    NSMutableArray *temp2=[[NSMutableArray alloc]init];
    for (int i=0; i<[eventListDictCopy count]; i++)
    {
        NSMutableArray *temp=[[NSMutableArray alloc]init];
        temp2=[eventListDictCopy objectForKey:[dateListCopy objectAtIndex:i]];
        for (int j=0;j<[temp2 count];j++)
        {
            event_Detail=[temp2 objectAtIndex:j];
            //NSLog(@"Name : %@ Fav : %@",[event_Detail objectForKey:@"eventName"],[event_Detail objectForKey:@"isFavourite"]);
            if ([[event_Detail objectForKey:@"isFavourite"] isEqualToString:@"1"])
            {
                [temp addObject:event_Detail];
            }
        }
        if ([temp count]>0)
        {
            dictemp = [NSMutableDictionary dictionaryWithObjectsAndKeys:temp,[dateListCopy objectAtIndex:i], nil];
            
            [dicttemp2 addEntriesFromDictionary:dictemp];
        }
        
    }
    eventListDict=dicttemp2;
    //dateList=[[[eventListDict allKeys]sortedArrayUsingSelector:@selector(compare:)]mutableCopy];
    dateList=[self getDateList:eventListDict];
    //NSLog(@"Dict : %@",dicttemp2);
    [_tveventlist reloadData];

}

- (IBAction)btnPage:(id)sender {
    _lblDate.text=@"EventList";
    [_txtSearchBar resignFirstResponder];
    [self.calendar setCurrentDate:[NSDate date]];
    [_menuView setHidden:true];
    [_btnMap setHidden:true];
    [_menuView setHidden:true];
    [_viewClassicCalendar setHidden:true];
    [_btnCalendar setBackgroundImage:[UIImage imageNamed:@"btn_calendar.png"] forState:UIControlStateNormal];
    
    [self.calendar setCurrentDate:[NSDate date]];
    
    if(_btnPage.selectedSegmentIndex == 0)
    {
        _btnPageBackground.image=[UIImage imageNamed:@"btn_all_home_back.png"];
        //[self retriveData];
//        eventListDict=eventListDictCopy;
//        dateList=dateListCopy;
        [self filterByCategory];
        [_tveventlist reloadData];
        [_viewNearby setHidden:true];
    }
    else if (_btnPage.selectedSegmentIndex == 1)
    {
        _btnPageBackground.image=[UIImage imageNamed:@"btn_favourite_home_back.png"];
        if (isFirstTimeFav)
        {
            count=1;
            [locationManager startUpdatingLocation];
        }
        else
        {
//            eventListDict=eventListDictCopy;
//            dateList=dateListFavCopy;
            
            [self filterByCategoryFav];
        }
        [_viewNearby setHidden:true];
    }
    else if (_btnPage.selectedSegmentIndex == 2)
    {
        _btnPageBackground.image=[UIImage imageNamed:@"btn_nearby_home_back.png"];
        if (isFirstTimeNearBy)
        {
            count=1;
            [locationManager startUpdatingLocation];
        }
        else
        {
            [self filterByCategoryNearBy];
        }
        //[self retriveNearbyData];
        [_viewNearby setHidden:false];
        [_btnMap setHidden:false];
    }
    
}

- (IBAction)btnMap:(id)sender {
    
    if(_viewNearbyList.hidden == true)
    {
        _viewNearbyList.hidden=false;
        _viewNearbyMap.hidden=true;
        [_btnMap setBackgroundImage:[UIImage imageNamed:@"btn_map.png"] forState:UIControlStateNormal];
    }
    else
    {
        _viewNearbyList.hidden=true;
        _viewNearbyMap.hidden=false;
        [_btnMap setBackgroundImage:[UIImage imageNamed:@"btn_map_list.png"] forState:UIControlStateNormal];
    }
}

#pragma mark Serach Bar

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    //[searchBar setSearchBarStyle:uise]
//    if(_btnPage.selectedSegmentIndex == 1)
//    {
//        [self getFavEvent];
//    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
   
    searchBar.showsCancelButton = YES;
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
  
    searchBar.showsCancelButton = NO;
    return YES;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self searching];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [_txtSearchBar resignFirstResponder];
    searchBar.showsCancelButton = NO;
//    if([searchBar.text length] == 0)
//    {
        if(_btnPage.selectedSegmentIndex == 0)
        {
            eventListDict=eventListDictCopy;
            dateList=dateListCopy;
        }
        if(_btnPage.selectedSegmentIndex == 1)
        {
            [self getFavEvent];
        }
        [_tveventlist reloadData];
//      return;
//    }
    _txtSearchBar.text=@"";
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self searching];
    [searchBar resignFirstResponder];
}

-(void)searching
{
    if([_txtSearchBar.text length] == 0)
    {
        if(_btnPage.selectedSegmentIndex == 0)
        {
            if (!isDataByDate)
            {
                eventListDict=eventListDictCopy;
                dateList=dateListCopy;
            }
            else
            {
                eventListDict=eventListDictDateCopy;
                dateList=dateListDateCopy;
            }            
        }
        else
        {
            eventListDict=eventListDictFavCopy;
            dateList=dateListFavCopy;
        }
        
        [_txtSearchBar resignFirstResponder];
        [_tveventlist reloadData];
        _txtSearchBar.showsCancelButton = NO;
        
        return;
    }
    
    NSMutableDictionary *dictemp=[[NSMutableDictionary alloc]init];
    NSMutableDictionary *dicttemp2=[[NSMutableDictionary alloc]init];
    NSMutableArray *temp2=[[NSMutableArray alloc]init];
    
    NSMutableArray *dateListTemp;
    NSMutableDictionary *eventListDictTemp;
    if (_btnPage.selectedSegmentIndex == 0)
    {
        if (!isDataByDate)
        {
            eventListDictTemp=eventListDictCopy;
            dateListTemp=dateListCopy;
        }
        else
        {
            eventListDictTemp=eventListDictDateCopy;
            dateListTemp=dateListDateCopy;
        }
    }
    else
    {
        eventListDictTemp=eventListDictFavCopy;
        dateListTemp=dateListFavCopy;
    }
    
    
    for (int i=0; i<[eventListDictTemp count]; i++)
    {
        NSMutableArray *temp=[[NSMutableArray alloc]init];
        temp2=[eventListDictTemp objectForKey:[dateListTemp objectAtIndex:i]];
        for (int j=0;j<[temp2 count];j++)
        {
            event_Detail=[temp2 objectAtIndex:j];
            if ([[NSString stringWithFormat:@"%@",[event_Detail objectForKey:@"eventName" ]] rangeOfString:_txtSearchBar.text options:NSCaseInsensitiveSearch].location == NSNotFound)
            {
            }
            else
            {
                if (_btnPage.selectedSegmentIndex == 1)
                {
                    if ([[event_Detail objectForKey:@"isFavourite"] isEqualToString:@"1"])
                    {
                        [temp addObject:event_Detail];
                    }
                }
                else
                {
                    [temp addObject:event_Detail];
                }
            }
        }
        if ([temp count]>0)
        {
            dictemp = [NSMutableDictionary dictionaryWithObjectsAndKeys:temp,[dateListTemp objectAtIndex:i], nil];
            
            [dicttemp2 addEntriesFromDictionary:dictemp];
        }
        
    }
    eventListDict=dicttemp2;
    dateList=[self getDateList:eventListDict];
    [_tveventlist reloadData];
}

#pragma mark MKMapViewDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if(count == 1)
    {
        CLLocation *newLocation = [locations lastObject];
        
        latitude = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
        longitude = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];

        if (_btnPage.selectedSegmentIndex == 0)
        {
            [self retriveData];
            [self retrivePopularEvent];
            [self retriveCategory];
        }
        else if (_btnPage.selectedSegmentIndex == 1)
        {
            [self retriveFavData];
        }
        else if (_btnPage.selectedSegmentIndex == 2 )
        {
            [self retriveNearByData];
            [self setCircleToUserLocation];
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
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

-(void)loadData
{
    @try {
        
    self.qTree = [QTree new];
    for( NSUInteger i = 0; i < [nearbyData count]; ++i )
    {
        CustomAnnotation *object = [CustomAnnotation new];
        NSMutableDictionary *eventDetail=[nearbyData objectAtIndex:i];
        object.coordinate = CLLocationCoordinate2DMake([[eventDetail objectForKey:@"latitude"]doubleValue],[[eventDetail objectForKey:@"longitude"]doubleValue]);
        object.titleOfAnnotation=[eventDetail objectForKey:@"eventName"];
        object.tag=[NSString stringWithFormat:@"%lu",(unsigned long)i ];
        //NSLog(@"Objects Tag = %@",object.tag);
        [self.qTree insertObject:object];
        
    }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        [self reloadAnnotations];
    }
}
-(void)reloadAnnotations
{
    
    if( !self.isViewLoaded ) {
        return;
    }
    
    const MKCoordinateRegion mapRegion = self.mvNearby.region;
    
    //BOOL useClustering = 1;//(self.segmentedControl.selectedSegmentIndex == 0);
    const CLLocationDegrees minNonClusteredSpan = useClustering ? MIN(mapRegion.span.latitudeDelta, mapRegion.span.longitudeDelta) / 5
    : 0;
    
    NSArray* objects = [self.qTree getObjectsInRegion:mapRegion minNonClusteredSpan:minNonClusteredSpan];
    
    NSMutableArray* annotationsToRemove = [self.mvNearby.annotations mutableCopy];
    [annotationsToRemove removeObject:self.mvNearby.userLocation];
    [annotationsToRemove removeObjectsInArray:objects];
    [self.mvNearby removeAnnotations:annotationsToRemove];
    
    NSMutableArray* annotationsToAdd = [objects mutableCopy];
    [annotationsToAdd removeObjectsInArray:self.mvNearby.annotations];
    
    [self.mvNearby addAnnotations:annotationsToAdd];
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
    
    [_mvNearby setRegion:region animated:YES];
    
    NSArray *pointsArray = [_mvNearby overlays];
    [_mvNearby removeOverlays:pointsArray];
    
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:userLocationAnnotation.coordinate radius:8046.72];
    [_mvNearby addOverlay:circle];
    
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
-(void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
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
        
        //DummyAnnotation *annotationView = [[DummyAnnotation alloc] init];
        
        
        UIButton *btnInfo = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        [btnInfo addTarget:self action:@selector(pinButton:) forControlEvents:UIControlEventTouchUpInside];
        //NSLog(@"%ld",(long)[annotation.tag integerValue]);
        btnInfo.tag=[annotation.tag integerValue];
        //btnInfo.tag=annotation.tag ;
        
        annotationView.rightCalloutAccessoryView = btnInfo;
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        
        return annotationView;
    }
}

-(IBAction)pinButton:(UIButton*)sender
{
    event_Detail=[nearbyData objectAtIndex:sender.tag];
    //NSLog(@"%@",category_Detail);
    selectedEventId=[event_Detail objectForKey:@"eventId"];
    headerDate=[dateConvert convertDate:[event_Detail objectForKey:@"startDate"] Enddate:[event_Detail objectForKey:@"endDate"] StartTime:[event_Detail objectForKey:@"startTime"] EndTime:[event_Detail objectForKey:@"endTime"]];
    
    [self.tabBarController.tabBar setHidden:YES];
    
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
    }
}

@end
