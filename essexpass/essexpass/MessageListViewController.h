//
//  MessageViewController.h
//  essexpass
//
//  Created by Paras Chodavadiya on 17/01/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tvMessage;
@property (weak, nonatomic) IBOutlet UIView *viewMessage;

@end
