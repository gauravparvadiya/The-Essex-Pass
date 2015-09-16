//
//  ActivityTableViewCell.h
//  The Essex Pass
//
//  Created by Paras Chodavadiya on 03/07/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *ivDeal;

@property (weak, nonatomic) IBOutlet UILabel *lblDealName;

@property (weak, nonatomic) IBOutlet UILabel *lblDealTime;
@end
