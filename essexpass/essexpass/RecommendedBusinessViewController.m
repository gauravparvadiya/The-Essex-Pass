//
//  RecommendedBusinessViewController.m
//  The Essex Pass
//
//  Created by Paras Chodavadiya on 23/05/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import "RecommendedBusinessViewController.h"
#import "Contant.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"
#import <CoreLocation/CoreLocation.h>
#import "RecommendedBusinessTableViewCell.h"
#import "AddBusinessViewController.h"

@interface RecommendedBusinessViewController ()
{
    CLLocationManager *locationManager;
    NSString *latitude,*longitude;
    int countForLocation,countForFoursqure;
    NSMutableArray *venues,*venuesCopy;
    NSMutableDictionary *businessDetail,*venusDetail;
    MBProgressHUD *hud;
}
@end

@implementation RecommendedBusinessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    venues=[[NSMutableArray alloc]init];
    venuesCopy=[[NSMutableArray alloc]init];
    businessDetail=[[NSMutableDictionary alloc]init];
    venusDetail=[[NSMutableDictionary alloc]init];
    
    countForFoursqure=0;
    
    UIView *accessoryView=[[UIView alloc]init];
    accessoryView.frame=CGRectMake(0,0, _btnNew.frame.size.width, _btnNew.frame.size.height);
    [accessoryView addSubview:_btnNew];
    _btnNew.frame=CGRectMake(0,0, _btnNew.frame.size.width, _btnNew.frame.size.height);
    
    _txtSearch.inputAccessoryView = accessoryView;
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [_tvBussiness reloadData];
}

#pragma mark Location

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if(countForLocation == 1)
    {
        CLLocation *newLocation = [locations lastObject];
        
        latitude = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
        longitude = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
        
//        latitude=@"";
//        longitude=@"";
        
        [manager stopUpdatingLocation];
        [self getData];
        countForLocation++;
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

#pragma mark Get data from foursqures
-(void)getData
{
    if (countForFoursqure == 0)
    {
        hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText=@"Loading...";
    }
    
    
    NSDate *date=[[NSDate alloc]init];
    NSDateFormatter *df =[[NSDateFormatter alloc]init];
    [df setDateFormat:@"YYYYMMdd"];
    NSString *v=[df stringFromDate:date];
    
    NSMutableDictionary *jsonData =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    @"R2OYKJCVMHFH5FFLA3XB2A1XMNEJ0I1ZGFLXLQSGPTO4PUQ1",@"client_id",
                                    @"DVLBZAJWHVH5PWPD5DJXEOY4FHKCEVD45RTLEBFQDXIE0UG0",@"client_secret",
                                    v,@"v",
                                    [NSString stringWithFormat:@"%@,%@",latitude,longitude],@"ll",
                                    [NSString stringWithFormat:@"%d",countForFoursqure],@"offset",nil];
    
    NSString *url=@"https://api.foursquare.com/v2/venues/explore";
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:url]];
    
    AFHTTPRequestOperation *op=[manager GET:url parameters:jsonData
        success:^(AFHTTPRequestOperation *operation, id responseObject)
        {
            [hud hide:YES];
            //NSLog(@"%@",responseObject);
            NSString *statusCode = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"meta"] objectForKey:@"code"] ];
            if([statusCode isEqualToString:@"200"])
            {
                int totalResults = [[[responseObject objectForKey:@"response"] objectForKey:@"totalResults"]integerValue];
                
                NSMutableArray *groups=[[responseObject objectForKey:@"response"]objectForKey:@"groups"];
                NSMutableDictionary *dict=[groups objectAtIndex:0];
                
                
                if (countForFoursqure == 0)
                {
                    venues=[dict objectForKey:@"items"];
                }
                else
                {
                    venues=[[venues arrayByAddingObjectsFromArray: [dict objectForKey:@"items"]]mutableCopy];
                }
                
                venuesCopy=venues;
                [self searching];
                
                if (countForFoursqure <= totalResults)
                {
                    countForFoursqure+=30;
                    [self getData];
                }
            }
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
                NSLog(@"Error : %@",error);
                [hud hide:YES];
        }];
    [op start];
    
//    AFHTTPRequestOperation *op = [manager POST:url parameters:jsonData constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//    }
//        success:^(AFHTTPRequestOperation *operation, id responseObject)
//        {
//            [hud hide:YES];
//            NSLog(@"%@",responseObject);
//            NSString *statusCode = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"meta"] objectForKey:@"code"] ];
//            if([statusCode isEqualToString:@"200"])
//            {
//                int totalResults = [[[responseObject objectForKey:@"response"] objectForKey:@"totalResults"]integerValue];
//                
//                NSMutableArray *groups=[[responseObject objectForKey:@"response"]objectForKey:@"groups"];
//                NSMutableDictionary *dict=[groups objectAtIndex:0];
//                
//                
//                if (countForFoursqure == 0)
//                {
//                    venues=[dict objectForKey:@"items"];
//                }
//                else
//                {
//                    venues=[[venues arrayByAddingObjectsFromArray: [dict objectForKey:@"items"]]mutableCopy];
//                }
//                
//                venuesCopy=venues;
//                [self searching];
//                
//                if (countForFoursqure <= totalResults)
//                {
//                    countForFoursqure+=30;
//                    [self getData];
//                }
//            }
//        }
//        failure:^(AFHTTPRequestOperation *operation, NSError *error)
//        {
//            NSLog(@"Error : %@",error);
//            [hud hide:YES];
//        }
//        ];
//    [op start];
}


#pragma mark TableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [venues count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SimpleTableCell";
    
    RecommendedBusinessTableViewCell *businessCell = (RecommendedBusinessTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(businessCell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RecommendedBusinessTableViewCell" owner:self options:nil];
        businessCell = [nib objectAtIndex:0];
    }
    
    businessDetail=[venues objectAtIndex:indexPath.row];
    venusDetail=[businessDetail objectForKey:@"venue"];
    businessCell.lblBusinessName.text=[venusDetail objectForKey:@"name"];

    businessCell.lblAddress.text=[self formattingAddress:venusDetail];
    
    return businessCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    businessDetail=[venues objectAtIndex:indexPath.row];
    if (_viewSearch.frame.origin.y == 60.0)
    {
         [self downKeyBoardWithAnimation];
    }
    
   
    [self performSegueWithIdentifier:@"AddBusiness" sender:self];
}

-(NSString *)formattingAddress: (NSMutableDictionary *)venusDetailTemp
{
    NSString *address=[[NSString alloc]init];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    dict=[venusDetailTemp objectForKey:@"location"];
    
    for (int i=0; i<[[dict objectForKey:@"formattedAddress" ] count]; i++)
    {
        if (i == 0)
        {
            address=[NSString stringWithFormat:@"%@",[[dict objectForKey:@"formattedAddress"] objectAtIndex:i]];
        }
        else
        {
            address=[NSString stringWithFormat:@"%@, %@",address,[[dict objectForKey:@"formattedAddress"] objectAtIndex:i]];
        }
    }
    return address;
}

#pragma mark SearchBar

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
    _btnNew.hidden=false;
    
    [UIView animateWithDuration:0.45
                     animations:^{
                         [_viewImage setFrame:CGRectMake(0,-292, _viewImage.frame.size.width, _viewImage.frame.size.height)];
                         [_viewSearch setFrame:CGRectMake(0, 60, _viewSearch.frame.size.width, self.view.frame.size.height-60)];
                         _tvBussiness.frame=CGRectMake(0,44, _tvBussiness.frame.size.width, _tvBussiness.frame.size.height-251);
     }
     completion:^(BOOL finished){
         _viewImage.hidden=true;
     }];

    
    
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;
    _viewImage.hidden=false;
    [UIView animateWithDuration:0.45
                     animations:^{
                         [_viewImage setFrame:CGRectMake(0,60, _viewImage.frame.size.width, _viewImage.frame.size.height)];
                         _tvBussiness.frame=CGRectMake(0,44 , _tvBussiness.frame.size.width, _tvBussiness.frame.size.height+251);
                         [_viewSearch setFrame:CGRectMake(0, 352, _viewSearch.frame.size.width, self.view.frame.size.height-_viewImage.frame.size.height-60)];
    }
    completion:^(BOOL finished)
    {
                         
    }];
    
    //NSLog(@"%f",_tvBussiness.frame.size.height);
    return YES;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self searching];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [_searchBar resignFirstResponder];
    searchBar.showsCancelButton = NO;
    venues=venuesCopy;

    [_tvBussiness reloadData];
    _searchBar.text=@"";
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self searching];
    [searchBar resignFirstResponder];
}

-(void)searching
{
    if([_txtSearch.text length] == 0)
    {
        venues=venuesCopy;
        //[_txtSearch resignFirstResponder];
        [_tvBussiness reloadData];
        //_searchBar.showsCancelButton = NO;
        return;
    }
    
    NSMutableArray *tempVenus=[[NSMutableArray alloc]init];
    
    for (int i=0; i<[venuesCopy count]; i++)
    {
        businessDetail=[venuesCopy objectAtIndex:i];
        venusDetail=[businessDetail objectForKey:@"venue"];

        if ([[venusDetail objectForKey:@"name"] rangeOfString:_txtSearch.text options:NSCaseInsensitiveSearch].location == NSNotFound
            && [[self formattingAddress:venusDetail] rangeOfString:_txtSearch.text options:NSCaseInsensitiveSearch].location == NSNotFound)
        {
        }
        else
        {
            [tempVenus addObject:businessDetail];
        }
        
    }
    venues=tempVenus;
    [_tvBussiness reloadData];
}

- (IBAction)txtSearch:(id)sender
{
    [self searching];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _btnNew.hidden=false;
    [UIView animateWithDuration:0.45
                     animations:^{
                         [_viewImage setFrame:CGRectMake(0,-265, _viewImage.frame.size.width, _viewImage.frame.size.height)];
                         [_viewSearch setFrame:CGRectMake(0, 60, _viewSearch.frame.size.width, self.view.frame.size.height-60)];
                         _tvBussiness.frame=CGRectMake(0,90, _tvBussiness.frame.size.width, _tvBussiness.frame.size.height-251);
                         
     }
     completion:^(BOOL finished){
         _viewImage.hidden=true;
         _btnCancel.hidden = false;
         _lblStatus.text=@"SEARCH RESULT";
     }];
    
    return true;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_txtSearch resignFirstResponder];
    return  true;
}

- (IBAction)btnCancel:(id)sender
{
    [self downKeyBoardWithAnimation];
}

-(void)downKeyBoardWithAnimation
{
    [_txtSearch setText:@""];
    [self searching];
    [_txtSearch resignFirstResponder];
    _viewImage.hidden=false;
    [UIView animateWithDuration:0.45
                     animations:^{
                         [_viewImage setFrame:CGRectMake(0,60, _viewImage.frame.size.width, _viewImage.frame.size.height)];
                         _tvBussiness.frame=CGRectMake(0,90, _tvBussiness.frame.size.width, _tvBussiness.frame.size.height+251);
                         [_viewSearch setFrame:CGRectMake(0, 325, _viewSearch.frame.size.width, self.view.frame.size.height-_viewImage.frame.size.height-60)];
                     }
                     completion:^(BOOL finished)
     {
         _btnCancel.hidden = YES;
         _lblStatus.text=@"NEARBY PLACES";
     }];
}


#pragma mark Button
- (IBAction)btnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnNew:(id)sender
{
    businessDetail=[[NSMutableDictionary alloc]init];
    [self downKeyBoardWithAnimation];
    [self performSegueWithIdentifier:@"AddBusiness" sender:self];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    AddBusinessViewController *add=(AddBusinessViewController *)segue.destinationViewController;
    add.businessDetail=businessDetail;
}


@end
