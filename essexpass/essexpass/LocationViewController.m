//
//  LocationViewController.m
//  The Essex Pass
//
//  Created by Paras Chodavadiya on 07/02/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import "LocationViewController.h"

@interface LocationViewController ()

@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)btnBack:(id)sender {
    
     [self.navigationController popViewControllerAnimated:YES];    
}
@end
