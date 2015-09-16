//
//  ConvertDate.m
//  The Essex Pass
//
//  Created by Paras Chodavadiya on 07/04/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import "ConvertDate.h"

@interface ConvertDate ()

@end

@implementation ConvertDate

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSString *)convertDate:(NSString *)headerDate StartTime:(NSString *)startTime EndTime:(NSString *)endTime
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *today=[df stringFromDate:[NSDate date]];
    NSString *tommorow=[df stringFromDate:[[NSDate date] dateByAddingTimeInterval:60*60*24*1]];
    
    NSString *finalDate;
    if ([headerDate isEqual:today])
    {
        finalDate=@"Today";
    }
    else if([headerDate isEqual:tommorow])
    {
        finalDate=@"Tomorrow";
    }
    else
    {
        NSDate *tempDate=[df dateFromString:headerDate];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"EEE. dd MMM yyyy"];
        finalDate = [dateFormat stringFromDate:tempDate];
    }
    
    NSString *startTimeWithOutFormte=startTime;
    NSDateFormatter *df1 = [[NSDateFormatter alloc] init];
    [df1 setDateFormat:@"HH:mm:ss"];
    NSDate *date1=[df1 dateFromString:startTimeWithOutFormte];
    [df1 setDateFormat:@"HH:mm"];
    NSString *startTime1=[df1 stringFromDate:date1];
    
    NSString *endTimeWithOutFormte=endTime;
    NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
    [df2 setDateFormat:@"HH:mm:ss"];
    NSDate *date2=[df2 dateFromString:endTimeWithOutFormte];
    [df2 setDateFormat:@"HH:mm"];
    NSString *endTime1=[df2 stringFromDate:date2];
    
    return [NSString stringWithFormat:@"%@\n%@ - %@",finalDate,startTime1,endTime1];

}

-(NSString *)convertDate :(NSString *)startDate Enddate:(NSString *)endDate StartTime:(NSString *)startTime EndTime:(NSString *)endTime
{
    BOOL isSameDate=0;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *today=[df stringFromDate:[NSDate date]];
    NSString *tommorow=[df stringFromDate:[[NSDate date] dateByAddingTimeInterval:60*60*24*1]];
    
    NSString *finalStartDate,*finalEndDate;
    if ([startDate isEqual:today])
    {
        finalStartDate=@"Today";
    }
    else if([startDate isEqual:tommorow])
    {
        finalStartDate=@"Tomorrow";
    }
    else
    {
        NSDate *tempDate=[df dateFromString:startDate];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd-MM-yyyy"];
        finalStartDate = [dateFormat stringFromDate:tempDate];
    }
    
    if ([endDate isEqual:today])
    {
        finalEndDate=@"Today";
    }
    else if([startDate isEqual:tommorow])
    {
        finalEndDate=@"Tomorrow";
    }
    else
    {
        NSDate *tempDate=[df dateFromString:endDate];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd-MM-yyyy"];
        finalEndDate = [dateFormat stringFromDate:tempDate];
        if ([finalStartDate isEqualToString:finalEndDate])
        {
            [dateFormat setDateFormat:@"EEE. dd MMM yyyy"];
            finalEndDate = [dateFormat stringFromDate:tempDate];
            isSameDate=1;
        }
    }
    
    NSString *startTimeWithOutFormte=startTime;
    NSDateFormatter *df1 = [[NSDateFormatter alloc] init];
    [df1 setDateFormat:@"HH:mm:ss"];
    NSDate *date1=[df1 dateFromString:startTimeWithOutFormte];
    [df1 setDateFormat:@"HH:mm"];
    NSString *startTime1=[df1 stringFromDate:date1];
    
    NSString *endTimeWithOutFormte=endTime;
    NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
    [df2 setDateFormat:@"HH:mm:ss"];
    NSDate *date2=[df2 dateFromString:endTimeWithOutFormte];
    [df2 setDateFormat:@"HH:mm"];
    NSString *endTime1=[df2 stringFromDate:date2];
    
    if (isSameDate)
    {
        return [NSString stringWithFormat:@"%@\n%@ - %@",finalEndDate,startTime1,endTime1];
    }
    else
    {
        return [NSString stringWithFormat:@"%@ to %@\n%@ - %@",finalStartDate,finalEndDate,startTime1,endTime1];
    }
}

@end
