//
//  ActivityViewController.m
//  The Essex Pass
//
//  Created by Paras Chodavadiya on 03/07/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import "ActivityViewController.h"
#import "ActivityTableViewCell.h"
#import "Contant.h"
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"
#import "LoadImage.h"


@interface ActivityViewController ()
{
    NSMutableArray *activityList;
    NSMutableDictionary *activityDetail,*userDetail;
    LoadImage *loadImage;
}
@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    activityList=[[NSMutableArray alloc]init];
    loadImage=[[LoadImage alloc]init];
    userDetail=[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"];
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Get Data
-(void)getData
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"loading...";
    
    NSMutableDictionary *jsonData =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [userDetail objectForKey:@"email"],@"userEmail",
                                    nil];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:GETACTIVITY]];
    
    AFHTTPRequestOperation *op = [manager POST:GETACTIVITY parameters:jsonData constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    }
        success:^(AFHTTPRequestOperation *operation, id responseObject)
      {
          [hud hide:YES];
          if([[responseObject objectForKey:@"Result"]isEqualToString:@"True"])
          {
              activityList=[responseObject objectForKey:@"PassHistory"];
              [_tblActivity reloadData];
          }
      }
        failure:^(AFHTTPRequestOperation *operation, NSError *error)
      {
          [hud hide:YES];
          NSLog(@"Error : %@",error);
      }
      ];
    [op start];
}

#pragma mark tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [activityList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ActivityTableViewCell";
    
    ActivityTableViewCell *cell = (ActivityTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ActivityTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    activityDetail=[activityList objectAtIndex:indexPath.row];
    cell.lblDealName.text=[activityDetail objectForKey:@"bussinessName"];
    cell.lblDealTime.text =[self convertTimeIntoLocal:[activityDetail objectForKey:@"createDate"]];
    
    [loadImage loadImage:[activityDetail objectForKey:@"image"] ImageView:cell.ivDeal ActivityIndicator:nil];
    
    return cell;
}

#pragma mark convert in local time
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


#pragma mark Button
- (IBAction)btnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
