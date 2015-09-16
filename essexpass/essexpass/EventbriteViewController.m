//
//  EventbriteViewController.m
//  The Essex Pass
//
//  Created by Paras Chodavadiya on 11/02/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import "EventbriteViewController.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"

@interface EventbriteViewController ()
{
    NSString *eventbriteurl;
    NSString *token;
    NSString *urlForWebView;
    NSMutableArray *eventList;
    MBProgressHUD *hud;
}
@end

@implementation EventbriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    eventbriteurl=@"https://www.eventbriteapi.com/v3/events/";
    token=@"C4DCDVX2A6BMWOTVVLG4";
    
    eventbriteurl=[NSString stringWithFormat:@"%@%@/?token=%@",eventbriteurl,_eventbriteEventId,token];
    
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"Loading...";
    
    [self getData];
    //[_webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:eventbriteurl]]];
}

- (IBAction)btnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getData
{
    
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:eventbriteurl]];
    
    AFHTTPRequestOperation *op = [manager GET:eventbriteurl parameters:nil
                                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                          //NSLog(@"%@",responseObject);
                                        urlForWebView=[responseObject objectForKey:@"url"];
                                        [_webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlForWebView]]];

                                      }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          NSLog(@"Error : %@",error);
                                          
                                      }];
    [op start];
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [hud hide:YES];
}
@end
