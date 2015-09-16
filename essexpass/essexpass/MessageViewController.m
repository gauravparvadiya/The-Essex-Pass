//
//  MessageViewController.m
//  The Essex Pass
//
//  Created by Paras Chodavadiya on 11/02/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import "MessageViewController.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.text=_messageTitle;
    _lblDate.text=_date;
    _lblTime.text=_time;
    _txtDescription.text=_messageDescription;
    
    _txtDescription.layer.cornerRadius=5.0;
    _txtDescription.layer.masksToBounds=YES;
}

- (IBAction)btnBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
