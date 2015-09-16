//
//  SearchResultViewController.h
//  The Essex Pass
//
//  Created by Paras Chodavadiya on 05/02/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tvEventDealList;

- (IBAction)btnBack:(id)sender;

@property (strong,nonatomic) NSMutableArray *data;

@property (weak, nonatomic) IBOutlet UIView *viewRecordNotFound;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;


- (IBAction)btnTryAgain:(id)sender;

@property(strong,nonatomic) NSString *type;
@end
