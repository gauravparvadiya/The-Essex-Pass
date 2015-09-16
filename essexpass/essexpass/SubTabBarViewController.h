//
//  SubTabBarViewController.h
//  essexpass
//
//  Created by Paras Chodavadiya on 11/01/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface SubTabBarViewController : UITabBarController

@property(strong,nonatomic) NSString *eventId,*headerDate;
@property(strong,nonatomic) NSString *dealId;
@property (weak, nonatomic) IBOutlet UITabBar *tabbar;

@property (strong, nonatomic) NSMutableDictionary *dealDetail;
@property (strong, nonatomic) NSMutableDictionary *eventDetail;
@end
