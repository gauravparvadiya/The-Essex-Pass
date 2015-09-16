//
//  FillRate.m
//  The Essex Pass
//
//  Created by Paras Chodavadiya on 01/04/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import "FillRate.h"

@interface FillRate ()

@end

@implementation FillRate

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)FillRate :(float)rate FirstImageView:(UIImageView *) ivFirstStar SecondImageView:(UIImageView *) ivSecondStar ThirdImageView:(UIImageView *) ivThirdStar FourthImageView:(UIImageView *) ivFourthStar FifthImageView:(UIImageView *) ivFifthStar
{
    int finalRate=ceil(rate);
    float secondRate;
    
    NSArray *arr=[[NSString stringWithFormat:@"%.2f",rate] componentsSeparatedByString:@"."];
    
    float pointDecimal=[[arr objectAtIndex:1]floatValue];
    
    if (pointDecimal == 0)
    {
        secondRate=finalRate;
    }
    else if (pointDecimal <= 50)
    {
        secondRate=[[NSString stringWithFormat:@"%d.50",finalRate]floatValue];
    }
    else
    {
        secondRate=[[NSString stringWithFormat:@"%d",finalRate]floatValue];
    }
    
    //NSLog(@"Rate : %f\tFinalRate : %d",rate,finalRate);
    switch (finalRate)
    {
        case 1:
            if (secondRate == finalRate) {
                ivFirstStar.image=[UIImage imageNamed:@"icon_star@2x.png"];
            }
            else
            {
                ivFirstStar.image=[UIImage imageNamed:@"icon_half_star_.png"];
            }
            break;
        case 2:
            ivFirstStar.image=[UIImage imageNamed:@"icon_star@2x.png"];
            if (secondRate == finalRate) {
                ivSecondStar.image=[UIImage imageNamed:@"icon_star@2x.png"];
            }
            else
            {
                ivSecondStar.image=[UIImage imageNamed:@"icon_half_star_.png"];
            }
            break;
        case 3:
            ivFirstStar.image=[UIImage imageNamed:@"icon_star@2x.png"];
            ivSecondStar.image=[UIImage imageNamed:@"icon_star@2x.png"];
            if (secondRate == finalRate) {
                ivThirdStar.image=[UIImage imageNamed:@"icon_star@2x.png"];
            }
            else
            {
                ivThirdStar.image=[UIImage imageNamed:@"icon_half_star_.png"];
            }
            break;
        case 4:
            ivFirstStar.image=[UIImage imageNamed:@"icon_star@2x.png"];
            ivSecondStar.image=[UIImage imageNamed:@"icon_star@2x.png"];
            ivThirdStar.image=[UIImage imageNamed:@"icon_star@2x.png"];
            if (secondRate == finalRate) {
                ivFourthStar.image=[UIImage imageNamed:@"icon_star@2x.png"];
            }
            else
            {
                ivFourthStar.image=[UIImage imageNamed:@"icon_half_star_.png"];
            }
            break;
        case 5:
            ivFirstStar.image=[UIImage imageNamed:@"icon_star@2x.png"];
            ivSecondStar.image=[UIImage imageNamed:@"icon_star@2x.png"];
            ivThirdStar.image=[UIImage imageNamed:@"icon_star@2x.png"];
            ivFourthStar.image=[UIImage imageNamed:@"icon_star@2x.png"];
            if (secondRate == finalRate) {
                ivFifthStar.image=[UIImage imageNamed:@"icon_star@2x.png"];
            }
            else
            {
                ivFifthStar.image=[UIImage imageNamed:@"icon_half_star_.png"];
            }
            break;
    }
}
@end
