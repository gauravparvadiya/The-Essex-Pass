//
//  SearchResultViewController.m
//  The Essex Pass
//
//  Created by Paras Chodavadiya on 05/02/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import "SearchResultViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "SubTabBarViewController.h"
#import "MBProgressHUD.h"
#import "ServiceCall.h"
#import "SearchTableViewCell.h"
#import "NearMeEventTableViewCell.h"
#import "LoadImage.h"
#import "FillRate.h"
#import "ConvertDate.h"

@interface SearchResultViewController ()
{
    NSMutableDictionary *eventDetail;
    LoadImage *image;
    FillRate *star;
    ConvertDate *dateConvert;
    NSString *selectedId,*headerDate;

}
@end

@implementation SearchResultViewController
@synthesize data;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    image=[[LoadImage alloc]init];
    star=[[FillRate alloc]init];
    dateConvert=[[ConvertDate alloc]init];
    
    SubTabBarViewController *stb=[[SubTabBarViewController alloc]init];
    [stb.tabBar setHidden:false];
    
    if ([_type isEqualToString:@"deal"])
    {
        _lblMessage.text=@"No deals found for this search.";
    }
    else
    {
        _lblMessage.text=@"No events found for this search.";
    }
    
    _viewRecordNotFound.layer.cornerRadius=8.0f;
    if([data count] > 0)
       [_viewRecordNotFound setHidden:true];

}

-(void)viewWillAppear:(BOOL)animated
{
    [_tvEventDealList reloadData];
}

//tableview

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
    
    
    if ([_type isEqualToString:@"deal"])
    {
        eventCell.lblEventname.text=[eventDetail objectForKey:@"bussinessName"];
    }
    else
    {
        eventCell.lblEventname.text=[eventDetail objectForKey:@"eventName"];
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
    if ([_type isEqualToString:@"deal"])
    {
        selectedId=[eventDetail objectForKey:@"dealId"];
    }
    else
    {
        selectedId=[eventDetail objectForKey:@"eventId"];
        headerDate=[dateConvert convertDate:[eventDetail objectForKey:@"startDate"] Enddate:[eventDetail objectForKey:@"endDate"] StartTime:[eventDetail objectForKey:@"startTime"] EndTime:[eventDetail objectForKey:@"endTime"]];
    }
    [self performSegueWithIdentifier:@"Detail" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Detail"])
    {
        SubTabBarViewController *st = (SubTabBarViewController *)segue.destinationViewController;
        if ([_type isEqualToString:@"deal"])
        {
            st.dealId=selectedId;
            st.dealDetail=eventDetail;
            st.eventId=0;
        }
        else
        {
            st.eventId=selectedId;
            st.eventDetail=eventDetail;
            st.dealId=0;
            st.headerDate=headerDate;
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

//Back
- (IBAction)btnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnTryAgain:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
