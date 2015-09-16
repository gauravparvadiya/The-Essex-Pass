//
//  ActivityViewController.h
//  The Essex Pass
//
//  Created by Paras Chodavadiya on 03/07/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblActivity;

- (IBAction)btnBack:(id)sender;

@end
