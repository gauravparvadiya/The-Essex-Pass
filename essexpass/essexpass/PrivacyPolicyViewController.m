//
//  PrivacyPolicyViewController.m
//  The Essex Pass
//
//  Created by Paras Chodavadiya on 04/07/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import "PrivacyPolicyViewController.h"
#import "Contant.h"

@interface PrivacyPolicyViewController ()

@end

@implementation PrivacyPolicyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:PRIVACYPOLICY]]];}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
