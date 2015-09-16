//
//  NearMeEventTableViewCell.h
//  essexpass
//
//  Created by Paras Chodavadiya on 13/01/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NearMeEventTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblDistance;

@property (weak, nonatomic) IBOutlet UILabel *lblMeasure;

@property (weak, nonatomic) IBOutlet UIImageView *ivFirstStar;
@property (weak, nonatomic) IBOutlet UIImageView *ivSecondStar;
@property (weak, nonatomic) IBOutlet UIImageView *ivThirdStar;
@property (weak, nonatomic) IBOutlet UIImageView *ivFourthStar;
@property (weak, nonatomic) IBOutlet UIImageView *ivFifthStar;

@property (weak, nonatomic) IBOutlet UIImageView *ivEvent;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorEventImage;

@property (weak, nonatomic) IBOutlet UILabel *lblEventname;

@property (weak, nonatomic) IBOutlet UILabel *lblLocation;

@property (weak, nonatomic) IBOutlet UILabel *lblDiscount;

@property (weak, nonatomic) IBOutlet UIImageView *iv1;

@property (weak, nonatomic) IBOutlet UIImageView *iv2;

@property (weak, nonatomic) IBOutlet UIImageView *iv3;

@property (weak, nonatomic) IBOutlet UIImageView *iv4;

@property (weak, nonatomic) IBOutlet UIImageView *iv5;

@property (weak, nonatomic) IBOutlet UIImageView *iv6;

@property (weak, nonatomic) IBOutlet UIImageView *ivBackground;









@end
