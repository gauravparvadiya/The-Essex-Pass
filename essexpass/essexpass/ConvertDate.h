//
//  ConvertDate.h
//  The Essex Pass
//
//  Created by Paras Chodavadiya on 07/04/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConvertDate : UIViewController

-(NSString *)convertDate :(NSString *)headerDate StartTime:(NSString *)startTime EndTime:(NSString *)endTime;

-(NSString *)convertDate :(NSString *)startDate Enddate:(NSString *)endDate StartTime:(NSString *)startTime EndTime:(NSString *)endTime;

@end
