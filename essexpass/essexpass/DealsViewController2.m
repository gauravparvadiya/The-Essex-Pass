//
//  DealsViewController.m
//  essexpass
//
//  Created by Paras Chodavadiya on 21/01/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import "DealsViewController2.h"
#import "Contant.h"
#import "DealTableViewCell.h"
#import "MenuTableViewCell.h"
#import "MBProgressHUD.h"
#import "SubTabBarViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "NearMeEventTableViewCell.h"
#import <CoreLocation/CoreLocation.h>
#import "CustomAnnotation.h"
#import "LoadImage.h"
#import "FillRate.h"

//qtree
#import "QTree.h"
#import "QCluster.h"
#import "ClusterAnnotationView.h"
#import "CustomAnnotation.h"

@interface DealsViewController2 ()
{
    CLLocationManager *locationManager;
    NSMutableArray *category;
    
    NSMutableDictionary *userDetail;
    
    NSMutableArray *deals,*allDeals,*favouriteDeals,*nearbyDeals;
    NSMutableArray *dateListForDeal;
    
    NSMutableDictionary *deal_Detail;
    NSMutableDictionary *category_Detail;
    
    NSMutableArray *selectedCategory,*selectedCategoryTemp;
    NSMutableArray *selectedCategoryId;
    NSString *selectedCategoryString;
    
    int count;
    
    NSString *selectedDealId;
    
    NSString *latitude,*longitude,*distance;
    
    NSMutableDictionary *nearbyDetail;
    int noOfDeals,round;//for featch record in group
    LoadImage *image;
    FillRate *star;
    BOOL useClustering,isClickRefresh,isServiceCall,isFirstTimeNearBy,isFirstTimeFavourite;
    
    AFHTTPRequestOperationManager *getDealManager ;
    
}
@end

@implementation DealsViewController2


- (void)viewDidLoad {
    [super viewDidLoad];
    userDetail=[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"];
    round=1;
    useClustering=1;
    isFirstTimeNearBy=1;
    isFirstTimeFavourite=1;
    isServiceCall=0;
    distance=@"0";
    
    //Chat Notification
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveNearbyDealNotification:) name:@"nearByDeal" object:nil];
    
    image=[[LoadImage alloc]init];
    star=[[FillRate alloc]init];
    getDealManager =[[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:GETDEALINGROUPNEW]];
    
    //pullToRefreshManager_ = [[MNMBottomPullToRefreshManager alloc] initWithPullToRefreshViewHeight:45.0f tableView:_tvDeallist withClient:self];
    
    _menuView.layer.borderColor=[UIColor colorWithRed:24.0/255.0 green:40.0/255.0 blue:83.0/255.0 alpha:1.0].CGColor;
    _menuView.layer.borderWidth=1.0;
    
    count=1;
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate=self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1)
    {
        // here you go with iOS 8
        [locationManager requestAlwaysAuthorization];
        [locationManager requestWhenInUseAuthorization];
    }
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"nearbyNotification"]count] == 0)
    {
//        count=1;
        [locationManager startUpdatingLocation];
    }
    else
    {
        [self reciveNearbyDealNotification:[[NSUserDefaults standardUserDefaults]objectForKey:@"nearbyNotification"]];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"nearbyNotification"];
    }
    
    [self.tabBarController.tabBar setHidden:NO];
    
    selectedCategory =[[NSMutableArray alloc]init];
    selectedCategoryTemp=[[NSMutableArray alloc]init];
    selectedCategoryId=[[NSMutableArray alloc]init];
    selectedCategoryString=[[NSString alloc]init];

}

-(void) retriveNearbyData
{
    NSMutableArray *temp=[[NSMutableArray alloc]init];
    for (int i=0; i<[deals count]; i++) {
        deal_Detail=[deals objectAtIndex:i];
        if ([[deal_Detail objectForKey:@"distance_in_km"]floatValue] <= [distance floatValue])
        {
            [temp addObject:deal_Detail];
        }
    }
    deals=temp;
}

//- (void)viewDidLayoutSubviews
//{
//    [super viewDidLayoutSubviews];
//    [pullToRefreshManager_ relocatePullToRefreshView];
//}

#pragma mark notification of Nearby
- (void )reciveNearbyDealNotification:(NSDictionary *)notification
{
    NSMutableDictionary *noti=[notification mutableCopy];

    category_Detail=[[noti objectForKey:@"payload"]objectForKey:@"detail"];
    selectedDealId=[category_Detail objectForKey:@"dealId"];
    [self.tabBarController.tabBar setHidden:YES];
    
    [self performSegueWithIdentifier:@"Detail" sender:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    [_menuView setHidden:true];
    [self.tabBarController.tabBar setHidden:NO];
    
    [_tvDeallist reloadData];
    [_tvNearby reloadData];
    //    if (_btnPage.selectedSegmentIndex == 2) {
    //        round=noOfDeals;
    //    }
    //    else
    //    {
    //        round=1;
    //    }
    //    [_viewClassicCalendar setHidden:true];
    //    [_btnCalendar setBackgroundImage:[UIImage imageNamed:@"btn_calendar.png"] forState:UIControlStateNormal];
    //
    //    if(latitude != nil && longitude != nil)
    //        [self retriveData];
    //    [self reloadAnnotations ];
}


#pragma mark Table View

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == _tvDeallist)
    {
        return [deals count];
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
        return [deals count];
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if(tableView == _tvDeallist)
    {
        //        if (indexPath.row == ([deals count]-1) && round <= noOfDeals && _btnPage.selectedSegmentIndex == 0) {
        //            round++;
        //            [self retriveData:date1];
        //        }
        
        static NSString *CellIdentifier = @"SimpleTableCell";
        
        DealTableViewCell *dealCell = (DealTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(dealCell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DealTableViewCell" owner:self options:nil];
            dealCell = [nib objectAtIndex:0];
        }
        
        @try {
        deal_Detail=[deals objectAtIndex:indexPath.row];
        
        //        CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 50.0f);
        //        dealCell.pr.transform = transform;
        
        dealCell.lblBackground.layer.cornerRadius=8.0f;
        dealCell.lblBackground.layer.masksToBounds=YES;
        
        dealCell.ivDeal.layer.cornerRadius=8.0f;
        dealCell.ivDeal.layer.masksToBounds=YES;
        
        dealCell.lblBussinessName.text = [deal_Detail objectForKey:@"bussinessName"];
        dealCell.lblDealPlace.text=[deal_Detail objectForKey:@"city"];
        
        if([[deal_Detail objectForKey:@"deal"] containsString:@"2 for 1"])
        {
            dealCell.lblOffer.text = @"2 for 1";
        }
        else if([[deal_Detail objectForKey:@"deal"] containsString:@"50%"])
        {
            dealCell.lblOffer.text = @"50% Off";
        }
        else if([[deal_Detail objectForKey:@"deal"] containsString:@"%"])
        {
            NSArray *arrtemp=[[deal_Detail objectForKey:@"deal"] componentsSeparatedByString:@"%"];
            
            NSString *discount;
            if([[arrtemp objectAtIndex:0] length] == 1)
                discount=[[arrtemp objectAtIndex:0] substringFromIndex: [[arrtemp objectAtIndex:0] length] - 1];
            else
                discount=[[arrtemp objectAtIndex:0] substringFromIndex: [[arrtemp objectAtIndex:0] length] - 2];
            
            dealCell.lblOffer.text=[NSString stringWithFormat:@"%@%% Off",discount];
        }
        else
        {
            dealCell.lblOffer.text=[deal_Detail objectForKey:@"deal"];
        }
        
        NSString *basicurl = [deal_Detail objectForKey:@"image"];
        //[self loadImage:basicurl :dealCell.ivDeal];
        [image loadImage:basicurl ImageView:dealCell.ivDeal ActivityIndicator:nil];
        
        }
        @catch (NSException *exception) {
            NSLog(@"Catch");
        }
        @finally {
            
            return dealCell;
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
            if ([selectedCategoryTemp count] == [category count]) {
                [categoryCell.btnCategory setImage:[UIImage imageNamed:@"icon_round.png"] forState:UIControlStateNormal ];
            }
            else
            {
                [categoryCell.btnCategory setImage:[UIImage imageNamed:nil] forState:UIControlStateNormal ];
            }
            return categoryCell;
        }
        
        category_Detail=[category objectAtIndex:indexPath.row-1];
        //NSLog(@"%@",category_Detail);
        
        //[categoryCell.btnCategory setTitle:[category_Detail objectForKey:@"categoryName"] forState:UIControlStateNormal];
        
        categoryCell.btnCategory.tag=indexPath.row-1;
        [categoryCell.btnCategory addTarget:self action:@selector(btnCategory:) forControlEvents:UIControlEventTouchUpInside];
        categoryCell.lblCategory.text=[category_Detail objectForKey:@"categoryName"];
        
        BOOL availableTag = [selectedCategoryTemp containsObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row-1]];
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
        
            
        //        if (indexPath.row == ([deals count]-2) && round <= noOfDeals) {
        //            round++;
        //            [self retriveData:date1];
        //        }
        
        static NSString *CellIdentifier = @"SimpleTableCell";
        
        NearMeEventTableViewCell *eventCell = (NearMeEventTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(eventCell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NearMeEventTableViewCell" owner:self options:nil];
            eventCell = [nib objectAtIndex:0];
        }
        
        @try
        {
        nearbyDetail=[deals objectAtIndex:indexPath.row];
        
        float finaldistance=[[nearbyDetail objectForKey:@"distance_in_km"]floatValue]*0.621371 ;
        eventCell.lblDistance.text=[NSString stringWithFormat:@"%.2f",finaldistance];
        eventCell.lblMeasure.text=@"Miles";
        eventCell.lblEventname.text=[nearbyDetail objectForKey:@"bussinessName"];
        eventCell.lblLocation.text=[nearbyDetail objectForKey:@"city"];
        
        NSMutableArray *img = [[NSMutableArray alloc]init];
        
        if([[nearbyDetail objectForKey:@"isBooking"] isEqual:@"1"])
            [img addObject:@"call.png"];
        
        if([[nearbyDetail objectForKey:@"isFridayOff"] isEqual:@"1"])
            [img addObject:@"icon_fri_off.png"];
        
        if([[nearbyDetail objectForKey:@"isSaturdayOff"] isEqual:@"1"])
            [img addObject:@"icon_sat_off.png"];
        
        if([[nearbyDetail objectForKey:@"isDecemberOff"] isEqual:@"1"])
            [img addObject:@"icon_dec_off.png"];
        
        if([[nearbyDetail objectForKey:@"dealRestrictions"] isEqual:@"2"])
            [img addObject:@"icon_2.png"];
        else if([[nearbyDetail objectForKey:@"dealRestrictions"] isEqual:@"4"])
            [img addObject:@"icon_4.png"];
        else if([[nearbyDetail objectForKey:@"dealRestrictions"] isEqual:@"6"])
            [img addObject:@"icon_6.png"];
        
        NSString *labelString;
        
        if([[nearbyDetail objectForKey:@"deal"] containsString:@"2 for 1"])
        {
            [img addObject:@"241.png"];
            labelString=@"241";
        }
        else if([[nearbyDetail objectForKey:@"deal"] containsString:@"50%"])
        {
            [img addObject:@"50percent.png"];
            labelString=@"50% Off";
        }
        else if([[nearbyDetail objectForKey:@"deal"] containsString:@"%"])
        {
            NSArray *arrtemp=[[nearbyDetail objectForKey:@"deal"] componentsSeparatedByString:@"%"];
            
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
                case 2:
                    [eventCell.iv3 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[img objectAtIndex:i]]]];
                    break;
                case 3:
                    [eventCell.iv4 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[img objectAtIndex:i]]]];
                    break;
                case 4:
                    [eventCell.iv5 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[img objectAtIndex:i]]]];
                    break;
                case 5:
                    [eventCell.iv6 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[img objectAtIndex:i]]]];
                    break;
            }
        }
        
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
    category_Detail=[deals objectAtIndex:indexPath.row];
    //NSLog(@"%@",category_Detail);
    selectedDealId=[category_Detail objectForKey:@"dealId"];
    [self.tabBarController.tabBar setHidden:YES];
    
    [self performSegueWithIdentifier:@"Detail" sender:self];
    
}

//#pragma mark PullToRefresh
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (_btnPage.selectedSegmentIndex ==0 && round <= noOfDeals)
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
//    if (_btnPage.selectedSegmentIndex == 0 && round <= noOfDeals)
//    {
//        [pullToRefreshManager_ tableViewReleased];
//    }
//}
//- (void)bottomPullToRefreshTriggered:(MNMBottomPullToRefreshManager *)manager
//{
//    if (_btnPage.selectedSegmentIndex == 0 && round <= noOfDeals)
//    {
//        round++;
//        [self retriveData];
//    }
//}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Detail"])
    {
        SubTabBarViewController *st = (SubTabBarViewController *)segue.destinationViewController;
        st.dealId=selectedDealId;
        st.dealDetail=category_Detail;
        st.eventId=0;
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
            selectedCategoryTemp = [[NSMutableArray alloc]init];
            for (int i=0;i<[category count]; i++) {
                [selectedCategoryTemp addObject:[NSString stringWithFormat:@"%d",i]];
            }
            
        }
        else
            [selectedCategoryTemp addObject:selectedTag];
        
        [_tvMenu reloadData];
    }
    else
    {
        [sender setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal ];
        if ([selectedTag isEqualToString:@"-1"])
        {
            selectedCategoryTemp=[[NSMutableArray alloc]init];
        }
        else
        {
            [selectedCategoryTemp removeObject:selectedTag];
        }
        [_tvMenu reloadData];
    }
}

- (IBAction)btnCalendar:(id)sender
{
    
}

- (IBAction)datePicker:(id)sender
{}
- (IBAction)btnDone:(id)sender
{}

#pragma mark - retire Data from json
-(void) retriveDataAll
{
    MBProgressHUD *hud;
    if(round == 1 || isClickRefresh)
    {
        hud=[MBProgressHUD showHUDAddedTo:self.view Tabbar:self.tabBarController.tabBar animated:YES];
        hud.labelText=@"Loading Deals...";
        //self.tabBarController.tabBar.userInteractionEnabled=NO;
        isClickRefresh=0;
    }
    NSString *email=[userDetail objectForKey:@"email"];
    NSMutableDictionary *jsonDictionary =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                              email,@"userEmail",
                                              [NSString stringWithFormat:@"%d",round],@"count",
                                              nil];
    
//    NSMutableDictionary *jsonDictionary =[NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                          @"51.5536744",@"latitude",
//                                          @"0.6102363",@"longitude",
//                                          distance,@"distance",
//                                          @"0",@"date",
//                                          email,@"userEmail",
//                                          [NSString stringWithFormat:@"%d",round],@"count",
//                                          nil];
    
    //AFHTTPRequestOperationManager *getDealManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:GETDEALINGROUPNEW]];
    
    AFHTTPRequestOperation *op = [getDealManager POST:GETDEALINGROUPNEW parameters:jsonDictionary constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    }
                                  
   success:^(AFHTTPRequestOperation *operation, id responseObject)
  {
      [hud hide:YES];
      //self.tabBarController.tabBar.userInteractionEnabled=YES;
      //NSLog(@"%@",responseObject);
      if([[responseObject objectForKey:@"Result"]isEqualToString:@"True"])
      {
          if(_btnPage.selectedSegmentIndex == 0)
          {
              if (round == 1)
              {
                  allDeals=[responseObject objectForKey:@"deals"];
              }
              else
              {
                  allDeals = [[allDeals arrayByAddingObjectsFromArray:[responseObject objectForKey:@"deals"]] mutableCopy];
              }
              isServiceCall=1;
              
          }
          
//          if (round == 1)
//          {
//              category=[responseObject objectForKey:@"category"];
//              selectedCategory =[[NSMutableArray alloc]init];
//              selectedCategoryTemp=[[NSMutableArray alloc]init];
//              for (int i=0;i<[category count]; i++)
//              {
//                  [selectedCategory addObject:[NSString stringWithFormat:@"%d",i]];
//                  [selectedCategoryTemp addObject:[NSString stringWithFormat:@"%d",i]];
//              }
//              [_tvMenu reloadData];
//          }
          
          noOfDeals=ceil([[responseObject objectForKey:@"TotalDeal"]floatValue]/20);
          
          [self filterByCategory];
      }
  }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
  {
      NSLog(@"Round : %d Error : %@",round,error);
      [hud hide:YES];
      //self.tabBarController.tabBar.userInteractionEnabled=YES;
  }
  ];
    [op start];
}

-(void) retriveCategory
{
    NSMutableDictionary *jsonData =[[NSMutableDictionary alloc]init];
    
    AFHTTPRequestOperationManager *managerForPopularEvent = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:GETDEALCATEGORY]];
    
    AFHTTPRequestOperation *op = [managerForPopularEvent POST:GETDEALCATEGORY parameters:jsonData constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    }
    success:^(AFHTTPRequestOperation *operation, id responseObject)
      {
          if([[responseObject objectForKey:@"Result"]isEqualToString:@"True"])
          {
              category=[responseObject objectForKey:@"category"];
              selectedCategory =[[NSMutableArray alloc]init];
              selectedCategoryTemp=[[NSMutableArray alloc]init];
              for (int i=0;i<[category count]; i++)
              {
                  [selectedCategory addObject:[NSString stringWithFormat:@"%d",i]];
                  [selectedCategoryTemp addObject:[NSString stringWithFormat:@"%d",i]];
              }
              [_tvMenu reloadData];
          }
      }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
      {
          //self.tabBarController.tabBar.userInteractionEnabled=YES;
          NSLog(@"Error : %@",error);
      }
      ];
    [op start];
}


-(void) retriveNearByData
{
    MBProgressHUD *hud;
    hud=[MBProgressHUD showHUDAddedTo:self.view Tabbar:self.tabBarController.tabBar animated:YES];
    hud.labelText=@"Loading Deals...";
    
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
          //noOfDeals=ceil([[responseObject objectForKey:@"TotalDeal"]floatValue]/20);
          
          //NSLog(@"%@",responseObject);
          if([[responseObject objectForKey:@"Result"]isEqualToString:@"True"])
          {
              nearbyDeals=[responseObject objectForKey:@"deals"];
              isFirstTimeNearBy=0;
              [self filterByCategoryNearBy];
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

-(void) retriveFavData
{
    MBProgressHUD *hud;
    
    hud=[MBProgressHUD showHUDAddedTo:self.view Tabbar:self.tabBarController.tabBar animated:YES];
    hud.labelText=@"Loading Deals...";
    //self.tabBarController.tabBar.userInteractionEnabled=NO;
    
    NSString *email=[userDetail objectForKey:@"email"];
    NSMutableDictionary *jsonDictionary =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                          latitude,@"latitude",
                                          longitude,@"longitude",
                                          email,@"userEmail",
                                          nil];
    AFHTTPRequestOperationManager *getFavDealManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:GETFAVDEAL]];
    
    AFHTTPRequestOperation *op = [getFavDealManager POST:GETFAVDEAL parameters:jsonDictionary constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    }
                                  
    success:^(AFHTTPRequestOperation *operation, id responseObject)
  {
      [hud hide:YES];
      //self.tabBarController.tabBar.userInteractionEnabled=YES;
      //NSLog(@"%@",responseObject);
      if([[responseObject objectForKey:@"Result"]isEqualToString:@"True"])
      {
          favouriteDeals=[responseObject objectForKey:@"deals"];
          isFirstTimeFavourite=0;
          [self filterByCategory];
          
      }
  }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
  {
      NSLog(@"Error : %@",error);
      [hud hide:YES];
      //self.tabBarController.tabBar.userInteractionEnabled=YES;
  }
  ];
    [op start];
}
- (IBAction)btnmenu:(id)sender
{
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
    selectedCategory=selectedCategoryTemp;
    
    if (_btnPage.selectedSegmentIndex == 2)
    {
        [self filterByCategoryNearBy];
    }
    else
    {
        [self filterByCategory];
    }
    _menuView.hidden=true;
}

-(void)filterByCategory
{
    //NSLog(@"Selected : %@",selectedCategory);
    NSInteger noOfRecord=[selectedCategory count];
    NSMutableArray *temp=[[NSMutableArray alloc]init];
    
    if(_btnPage.selectedSegmentIndex == 0)
    {
        deals=allDeals;
    }
    else if(_btnPage.selectedSegmentIndex == 1)
    {
        deals=favouriteDeals;
    }
    

    for (int i=0; i<deals.count; i++)
    {
        NSMutableDictionary *category_Detail_deals=[deals objectAtIndex:i];
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
    deals=temp;
    
    if(_btnPage.selectedSegmentIndex == 0)
    {
        [_tvDeallist reloadData];
        if(round < noOfDeals)
        {
            round++;
            [self retriveDataAll];
            
        }
            //[pullToRefreshManager_ tableViewReloadFinished];
//            isServiceCall=0;
//        }
        
    }
    else if(_btnPage.selectedSegmentIndex == 1)
    {
        [_tvDeallist reloadData];
    }
}

-(void)filterByCategoryNearBy
{
    //NSLog(@"Selected : %@",selectedCategory);
    NSInteger noOfRecord=[selectedCategory count];
    NSMutableArray *temp=[[NSMutableArray alloc]init];
    deals=nearbyDeals;
    
    for (int i=0; i<deals.count; i++)
    {
        NSMutableDictionary *category_Detail_deals=[deals objectAtIndex:i];
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
    deals=temp;
    
    [_tvNearby reloadData];
    [self loadData];
}

- (IBAction)btnPage:(id)sender
{
    [_viewNearby setHidden:true];
    [_btnMap setHidden:true];
    //[_btnRefresh setHidden:true];
    [_menuView setHidden:true];
    [_viewClassicCalendar setHidden:true];
    [_btnCalendar setBackgroundImage:[UIImage imageNamed:@"btn_calendar.png"] forState:UIControlStateNormal];
    
    //[self.calendar setCurrentDate:[NSDate date]];
    if(_btnPage.selectedSegmentIndex == 0)
    {
        [self filterByCategory];
        //distance=@"0";
        //round=1;
        _btnPageBackground.image=[UIImage imageNamed:@"btn_all_home_back.png"];
        [_viewNearby setHidden:true];
    }
    else if (_btnPage.selectedSegmentIndex == 1)
    {
        if (isFirstTimeFavourite)
        {
            count=1;
            [locationManager startUpdatingLocation];
        }
        else
        {
            [self filterByCategory];
        }
        _btnPageBackground.image=[UIImage imageNamed:@"btn_favourite_home_back.png"];
        [_viewNearby setHidden:true];
    }
    else if (_btnPage.selectedSegmentIndex == 2)
    {
        //round=0;
        distance=@"8.04672";
        if (isFirstTimeNearBy)
        {
            count=1;
            [locationManager startUpdatingLocation];
        }
        else
        {
            [self filterByCategoryNearBy];
        }
        _btnPageBackground.image=[UIImage imageNamed:@"btn_nearby_home_back.png"];
        [_viewNearby setHidden:false];
        [_btnMap setHidden:false];
    }
    
}
- (IBAction)btnMap:(id)sender
{
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

#pragma mark MKMapViewDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if(count == 1)
    {
        CLLocation *newLocation = [locations lastObject];
        
        latitude = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
        longitude = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
    
        NSLog(@"lat: %@\tlong: %@",latitude,longitude);

        [manager stopUpdatingLocation];
        
        if (_btnPage.selectedSegmentIndex == 0 )
        {
            round=1;
            [self retriveCategory];
            [self retriveDataAll];
        }
        else if(_btnPage.selectedSegmentIndex == 2)
        {
            [self retriveNearByData];
        }
        else
        {
            [self retriveFavData];
        }
        
        
        [self setCircleToUserLocation];
        count++;
    }
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

-(void)loadData
{
    @try {
        self.qTree = [QTree new];
        for( NSUInteger i = 0; i < [deals count]; ++i )
        {
            CustomAnnotation *object = [CustomAnnotation new];
            NSMutableDictionary *eventDetail=[deals objectAtIndex:i];
            object.coordinate = CLLocationCoordinate2DMake([[eventDetail objectForKey:@"latitude"]doubleValue],[[eventDetail objectForKey:@"longitude"]doubleValue]);
            object.titleOfAnnotation=[eventDetail objectForKey:@"bussinessName"];
            object.tag=[NSString stringWithFormat:@"%lu",(unsigned long)i ];
            //NSLog(@"Objects Tag = %@",object.tag);
            [self.qTree insertObject:object];            
        }
    }
    @catch (NSException *exception)
    {
        
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

-(IBAction)segmentChanged:(id)sender
{
    [self reloadAnnotations];
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

-(void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    if (isClickRefresh) {
        useClustering=1;
        isClickRefresh=0;
        return;
    }
    float currentZoomScale = mapView.bounds.size.width / mapView.visibleMapRect.size.width;
    //NSLog(@"%f",currentZoomScale);
    if (currentZoomScale >= 0.072726)
    {
        useClustering=0;
    }
    else
    {
        useClustering=1;
    }
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    if (_btnPage.selectedSegmentIndex == 2) {
        
        MKCircleView *circleView = [[MKCircleView alloc] initWithOverlay:overlay];
        [circleView setFillColor:[UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:0.5]];
        [circleView setStrokeColor:[UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0]];
        [circleView setLineWidth:5.0];
        [circleView setAlpha:0.3];
        
        return circleView;
    }
    
    return 0;
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
    //NSLog(@"Annotation Id :%ld",(long)sender.tag);
    category_Detail=[deals objectAtIndex:sender.tag];
    //NSLog(@"%@",category_Detail);
    selectedDealId=[category_Detail objectForKey:@"dealId"];
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

- (IBAction)segmentedControl:(id)sender
{
    [self reloadAnnotations];
}

- (IBAction)btnRefresh:(id)sender
{
    [getDealManager.operationQueue cancelAllOperations];
    
    isClickRefresh=1;
    useClustering=1;
    //distance=@"8.04672";
    count=1;
    
    [locationManager startUpdatingLocation];
}
@end
