//
//  EventBriteViewController.m
//  The Essex Pass
//
//  Created by Paras Chodavadiya on 07/02/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import "EventBriteListViewController.h"
#import "EventBriteTableViewCell.h"
#import "EventTableViewCell.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"

@interface EventBriteListViewController ()
{
    NSString *url;
    NSMutableArray *eventList;
    NSMutableDictionary *eventDetail,*eventSubDetail,*eventInnerDetail;
    
}
@end

@implementation EventBriteListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    url = @"https://www.eventbriteapi.com/v3/events/search/?q=Hello&venue.city=London&token=C4DCDVX2A6BMWOTVVLG4";
    
    eventList =[[NSMutableArray alloc]init];
    eventDetail=[[NSMutableDictionary alloc]init];
    eventSubDetail=[[NSMutableDictionary alloc]init];
    
    [self getData];
}

//Get Data from API
-(void)getData
{
MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
hud.labelText=@"Loading...";

AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:url]];

AFHTTPRequestOperation *op = [manager GET:url parameters:nil
    success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        //NSLog(@"%@",responseObject);
        eventList=[responseObject objectForKey:@"events"];
        [_tvEventList reloadData];
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error : %@",error);
        [hud hide:YES];
    }];
[op start];

}

//Table View
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [eventList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SimpleTableCell";
    
    EventTableViewCell *eventCell = (EventTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(eventCell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EventTableViewCell" owner:self options:nil];
        eventCell = [nib objectAtIndex:0];
    }
    
    if([indexPath row ] % 2 != 0)
    {
        eventCell.backgroundColor=[UIColor colorWithRed:202.0/255.0 green:202.0/255.0 blue:205.0/255.0 alpha:1.0];
    }
    
    
    eventDetail=[eventList objectAtIndex:indexPath.row];
    eventSubDetail=[eventDetail objectForKey:@"name"];
    //NSLog(@"Event Detail : %@",eventSubDetail);
    eventCell.lblName.text=[eventSubDetail objectForKey:@"text"];
    
    eventSubDetail=[eventDetail objectForKey:@"venue"];
    eventInnerDetail=[eventSubDetail objectForKey:@"address"];
    eventCell.lblDescription.text=[NSString stringWithFormat:@"%@, %@",[eventInnerDetail objectForKey:@"city"],[eventInnerDetail objectForKey:@"region"]];
    
    eventSubDetail=[eventDetail objectForKey:@"start"];
    NSString *startDate=[eventSubDetail objectForKey:@"local"];
    
    eventCell.lblTime.text=[NSString stringWithFormat:@"%@",startDate];
    
    eventSubDetail=[eventDetail objectForKey:@"logo"];
    if (eventSubDetail != [NSNull null]) {
        NSString *basicurl = [eventSubDetail objectForKey:@"url"];
        NSString *urlForImage=[basicurl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        //NSURL *imageURL = [NSURL URLWithString:urlForImage];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager GET:urlForImage parameters:nil success:^(AFHTTPRequestOperation *operation, NSData *returnData)
         {
             [eventCell.indicatorImage setHidden:true];
             //eventCell.ivImage.image = [UIImage imageWithData:returnData];
             [UIView transitionWithView:eventCell.ivImage
                               duration:0.5f
                                options:UIViewAnimationOptionTransitionCrossDissolve
                             animations:^{
                                 eventCell.ivImage.image = [UIImage imageWithData:returnData];
                             } completion:NULL];
         }
             failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"Error: %@", error.description);
         }];

    }
    else
        [eventCell.indicatorImage setHidden:true];
    
        
    return eventCell;
}
- (IBAction)btnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
