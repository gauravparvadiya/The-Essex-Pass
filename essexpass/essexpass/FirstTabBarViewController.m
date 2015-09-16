//
//  FirstTabBarViewController.m
//  essexpass
//
//  Created by Paras Chodavadiya on 08/01/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import "FirstTabBarViewController.h"
#import "Contant.h"
@interface FirstTabBarViewController ()
{
    UIImage *background;
}
@end

@implementation FirstTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
////    [[UITabBar appearance] setBackgroundColor: [UIColor colorWithRed:234.0/255.0 green:147.0/255.0 blue:0.0 alpha:1.0]];
////    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:24.0/255.0 green:40.0/255.0 blue:83.0/255.0 alpha:1.0]];
//   // [[UITabBar appearance] setSelectedImageTintColor:[UIColor colorWithRed:24.0/255.0 green:40.0/255.0 blue:83.0/255.0 alpha:1.0]];
    if(ISIPHONE6)
        background = [UIImage imageNamed:@"tabbar_background2.png"];
    else if(ISIPHONE6P)
        background = [UIImage imageNamed:@"tabbar_background3.png"];
    else
        background = [UIImage imageNamed:@"tabbar_background.png"];
    
    [[UITabBar appearance] setSelectionIndicatorImage:background];

}
@end
