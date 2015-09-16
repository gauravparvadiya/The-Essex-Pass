//
//  LoadImage.h
//  The Essex Pass
//
//  Created by Paras Chodavadiya on 14/03/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadImage : UIViewController

@property(nonatomic,strong)NSMutableArray *arrURL;

@property(nonatomic,strong)NSMutableArray *arrData;

//-(void)loadImage :(NSString *)url ArrayOfURL:(NSMutableArray *)arrURL ArrayOfData:(NSMutableArray *)arrData ImageView:(UIImageView *)ivImage ActivityIndicator:(UIActivityIndicatorView *)activityIndicator;

-(void)loadImage :(NSString *)url ImageView:(UIImageView *)ivImage ActivityIndicator:(UIActivityIndicatorView *)activityIndicator;

@end
