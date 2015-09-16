//
//  SearchTableViewCell.h
//  essexpass
//
//  Created by Paras Chodavadiya on 27/01/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *view;

@property (weak, nonatomic) IBOutlet UIImageView *ivImage;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *inditator;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *detail;

@property (weak, nonatomic) IBOutlet UIImageView *iv1;

@property (weak, nonatomic) IBOutlet UIImageView *iv2;

@property (weak, nonatomic) IBOutlet UIImageView *iv3;

@property (weak, nonatomic) IBOutlet UIImageView *iv4;

@property (weak, nonatomic) IBOutlet UIImageView *iv5;

@property (weak, nonatomic) IBOutlet UIImageView *iv6;

@property (weak, nonatomic) IBOutlet UIImageView *ivFirstStar;

@property (weak, nonatomic) IBOutlet UIImageView *ivSecondStar;

@property (weak, nonatomic) IBOutlet UIImageView *ivThirdStar;

@property (weak, nonatomic) IBOutlet UIImageView *ivFourthStar;

@property (weak, nonatomic) IBOutlet UIImageView *ivFifthStar;

@property (weak, nonatomic) IBOutlet UILabel *lblDistance;



@end
