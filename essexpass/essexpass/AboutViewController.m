//
//  AboutViewController.m
//  The Essex Pass
//
//  Created by Paras Chodavadiya on 30/01/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblVersion.text=[[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnBack:(id)sender
{    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
