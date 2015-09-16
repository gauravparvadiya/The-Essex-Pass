//
//  MessageViewController.m
//  essexpass
//
//  Created by Paras Chodavadiya on 17/01/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import "MessageListViewController.h"
#import "MessageViewController.h"
#import "MessageTableViewCell.h"
#import "ServiceCall.h"
#import "MBProgressHUD.h"
#import "Contant.h"
#import "AFHTTPRequestOperationManager.h"

@interface MessageListViewController ()
{
    NSMutableArray *messageList;
    NSMutableDictionary *messageDetail;
    NSString *messageTitle, *messageDescription, *time, *date;
}
@end

@implementation MessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _viewMessage.layer.cornerRadius=8.0f;
}

-(void)viewDidAppear:(BOOL)animated
{
     [self retriveData];
}
#pragma mark - retire Data from json
-(void) retriveData
{
//    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText=@"Loading Messages...";
    NSMutableDictionary *userDetail=[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"];
    NSString *userEmail=[userDetail objectForKey:@"email"];
    
    NSMutableDictionary *jsonData =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                                       userEmail,@"userEmail",nil];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:MESSAGE]];
    
    AFHTTPRequestOperation *op = [manager POST:MESSAGE parameters:jsonData constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    }
                                       success:^(AFHTTPRequestOperation *operation, id responseObject)
                                  {
                                      //[hud hide:YES];
                                      if([[responseObject objectForKey:@"Result"]isEqualToString:@"True"])
                                      {
                                          messageList=[responseObject objectForKey:@"messageList"];
                                          //NSLog(@"Message List : %@",messageList);
                                          if ([messageList count] == 0)
                                          {
                                              _viewMessage.hidden=false;
                                              _tvMessage.hidden=true;
                                          }
                                          else
                                          {
                                              _viewMessage.hidden=true;
                                              _tvMessage.hidden=false;
                                          }
                                      }
                                      else
                                      {
                                                          
                                      }
                                      [_tvMessage reloadData];

                                  }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error)
                                  {
                                      NSLog(@"Error : %@",error);
                                      //[hud hide:YES];
                                  }
                                  ];
    [op start];
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSMutableDictionary *jsonDictionary =[[NSMutableDictionary alloc]init];
//        
//        ServiceCall *sc=[[ServiceCall alloc]init];
//        NSMutableDictionary *response = [sc serviceCall:[NSString stringWithFormat:@"%@",GETMESSAGELIST]:jsonDictionary];
//        //NSLog(@"Response : %@",response);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [hud hide:YES];
//            NSString *status = [response objectForKey:@"ResponseCode"];
//            
//            if ([status isEqualToString:@"1"])
//            {
//                messageList=[response objectForKey:@"data"];
//                //NSLog(@"Message List : %@",messageList);
//            }
//            else
//            {
//                
//            }
//            [_tvMessage reloadData];
//        });
//    });
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [messageList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SimpleTableCell";
    
    MessageTableViewCell *messageCell = (MessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(messageCell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MessageTableViewCell" owner:self options:nil];
        messageCell = [nib objectAtIndex:0];
    }
    
    messageDetail=[messageList objectAtIndex:indexPath.row];
    
    messageCell.lblName.text=[messageDetail objectForKey:@"messageName"];
    messageCell.lblDescription.text=[messageDetail objectForKey:@"messageDescription"];
    
    //13:17:40
    messageCell.lblTime.text=[messageDetail objectForKey:@"messageTime"];
//
//    [dateformate setDateFormat:@"HH:mm:ss"];
//    NSDate *formateTime=[dateformate dateFromString:[messageDetail objectForKey:@"messageTime"]];
    
    
    //Set Date
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"YYYY-MM-dd"];
    NSString *date_String=[dateformate stringFromDate:[NSDate date]];
    
    if (![date_String isEqual:[messageDetail objectForKey:@"messageDate"]])
    {
        [dateformate setDateFormat:@"dd MMM YYYY"];
        date=[dateformate stringFromDate:[NSDate date]];
        messageCell.lblDate.text=date;
    }
    else
    {
        
    }
    
    return messageCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    messageDetail=[messageList objectAtIndex:indexPath.row];
    messageTitle=[messageDetail objectForKey:@"messageName"];
    messageDescription=[messageDetail objectForKey:@"messageDescription"];
    time=[messageDetail objectForKey:@"messageTime"];
    
    [self performSegueWithIdentifier:@"MessageDetail" sender:self];
    
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


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"MessageDetail"])
    {
        MessageViewController *mvc = (MessageViewController *)segue.destinationViewController;
        mvc.messageTitle=messageTitle;
        mvc.messageDescription=messageDescription;
        mvc.date=date;
        mvc.time=time;
    }
}

@end
