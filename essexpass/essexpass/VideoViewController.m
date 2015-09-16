//
//  VideoViewController.m
//  The Essex Pass
//
//  Created by Paras Chodavadiya on 10/03/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import "VideoViewController.h"
#import "MBProgressHUD.h"
@interface VideoViewController ()
//{
//    MBProgressHUD *hud;
//}
@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText=@"Loading...";
    
    NSURL *urlForWebView=[NSURL URLWithString:_videoLink];
    //NSURL *urlForWebView=[NSURL URLWithString:@"http://moimagazine.iblinfotech.com/Restaurant_LindecyWood/Video/BusserVideo.m4v"];
    [_wvVideo loadRequest:[NSURLRequest requestWithURL:urlForWebView]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    [hud hide:YES];
//}

- (IBAction)btnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
