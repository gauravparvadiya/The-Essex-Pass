//
//  EventBriteTableViewCell.h
//  The Essex Pass
//
//  Created by Paras Chodavadiya on 07/02/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventBriteTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *ivEvent;

@property (weak, nonatomic) IBOutlet UILabel *lblName;

@property (weak, nonatomic) IBOutlet UILabel *lblLocation;

@property (weak, nonatomic) IBOutlet UILabel *lblTime;

@end
