//
//  DealTableViewCell.h
//  essexpass
//
//  Created by Paras Chodavadiya on 28/01/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DealTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *ivDeal;

@property (weak, nonatomic) IBOutlet UILabel *lblBussinessName;

@property (weak, nonatomic) IBOutlet UILabel *lblOffer;

@property (weak, nonatomic) IBOutlet UILabel *lblDealPlace;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorImage;

@property (weak, nonatomic) IBOutlet UILabel *lblBackground;

@property (weak, nonatomic) IBOutlet UIProgressView *pr;


@end
