//
//  TermsOfUseMoreViewController.m
//  The Essex Pass
//
//  Created by Paras Chodavadiya on 21/05/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import "TermsOfUseMoreViewController.h"
#import "Contant.h"

@interface TermsOfUseMoreViewController ()

@end

@implementation TermsOfUseMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:TERMSANDCONDITION]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)unwindToRed:(UIStoryboardSegue *)unwindSegue
{
    [self.navigationController performSegueWithIdentifier:@"back" sender:self];
}

- (IBAction)btnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
