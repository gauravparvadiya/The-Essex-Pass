//
//  ReviewTableViewCell.h
//  The Essex Pass
//
//  Created by Paras Chodavadiya on 03/03/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *ivStar1;

@property (weak, nonatomic) IBOutlet UIImageView *ivStar2;

@property (weak, nonatomic) IBOutlet UIImageView *ivStar3;

@property (weak, nonatomic) IBOutlet UIImageView *ivStar4;

@property (weak, nonatomic) IBOutlet UIImageView *ivStar5;

@property (weak, nonatomic) IBOutlet UILabel *lblUserName;

@property (weak, nonatomic) IBOutlet UILabel *lblDate;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UILabel *lblDescription;

@end
