//
//  MenuTableViewCell.m
//  essexpass
//
//  Created by Paras Chodavadiya on 09/01/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import "MenuTableViewCell.h"

@implementation MenuTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


//- (IBAction)btnCategory:(id)sender {
    
//    UIImage *imageFill= [_ivCheckbox image];
//    UIImage *imageForCheck=[UIImage imageNamed: @"chk_check.png"];
//    
//    NSData *data1 = UIImagePNGRepresentation(imageFill);
//    NSData *data2 = UIImagePNGRepresentation(imageForCheck);
//    
//    //if(imageFill == imageForCheck)
//    if([data1 isEqual:data2])
//    {
//        _ivCheckbox.image=[UIImage imageNamed: @"chk_uncheck.png"];
//    }
//    else
//    {
//         _ivCheckbox.image=[UIImage imageNamed: @"chk_check.png"];
//    }
//}
@end
