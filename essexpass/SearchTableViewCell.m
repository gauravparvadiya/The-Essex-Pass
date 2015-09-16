//
//  SearchTableViewCell.m
//  essexpass
//
//  Created by Paras Chodavadiya on 27/01/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import "SearchTableViewCell.h"

@implementation SearchTableViewCell

- (void)awakeFromNib {
    _view.layer.cornerRadius=5.0f;
//    _ivImage.layer.cornerRadius=5.0f;
//    _ivImage.layer.masksToBounds=YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
