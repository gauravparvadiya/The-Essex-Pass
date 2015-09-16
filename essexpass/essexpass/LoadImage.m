//
//  LoadImage.m
//  The Essex Pass
//
//  Created by Paras Chodavadiya on 14/03/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import "LoadImage.h"
#import "AFHTTPRequestOperationManager.h"

@implementation LoadImage
@synthesize arrURL,arrData;

//-(void)loadImage :(NSString *)url ArrayOfURL:(NSMutableArray *)arrURL ArrayOfData:(NSMutableArray *)arrData ImageView:(UIImageView *)ivImage ActivityIndicator:(UIActivityIndicatorView *)activityIndicator
//{
//    activityIndicator.hidesWhenStopped=YES;
//    int flag=0,i;
//    if ([url length]>0)
//    {
//        [activityIndicator startAnimating];
//        url=[url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
//        for (i=0; i<[arrURL count]; i++)
//        {
//            if ([[arrURL objectAtIndex:i]  isEqualToString:url])
//            {
//                flag=1;
//                break;
//            }
//        }
//        if (flag == 1)
//        {
//            [activityIndicator stopAnimating];
//            ivImage.image=[UIImage imageWithData:[arrData objectAtIndex:i]];
//        }
//        else
//        {
//            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//            [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, NSData *returnData)
//             {
//                 [activityIndicator stopAnimating];
//                 [UIView transitionWithView:ivImage
//                                   duration:0.5f
//                                    options:UIViewAnimationOptionTransitionCrossDissolve
//                                 animations:^
//                  {
//                      ivImage.image = [UIImage imageWithData:returnData];
//                  } completion:NULL];
//                 [arrURL addObject:url];
//                 [arrData addObject:returnData];
//             }
//                 failure:^(AFHTTPRequestOperation *operation, NSError *error)
//             {
//                 NSLog(@"Error: %@", error.description);
//             }];
//        }
//    }
//}

-(void)loadImage :(NSString *)url ImageView:(UIImageView *)ivImage ActivityIndicator:(UIActivityIndicatorView *)activityIndicator
{
    activityIndicator.hidesWhenStopped=YES;
    int flag=0,i;
    if ([url length]>0)
    {
        [activityIndicator startAnimating];
        url=[url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        if ([arrData count] == 0|| [arrURL count] == 0)
        {
            arrURL=[[NSMutableArray alloc]init];
            arrData=[[NSMutableArray alloc]init];
        }
        
        for (i=0; i<[arrURL count]; i++)
        {
            if ([[arrURL objectAtIndex:i]  isEqualToString:url])
            {
                flag=1;
                break;
            }
        }
        if (flag == 1)
        {
            [activityIndicator stopAnimating];
            ivImage.image=[UIImage imageWithData:[arrData objectAtIndex:i]];
        }
        else
        {
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, NSData *returnData)
             {
                 [activityIndicator stopAnimating];
                 [UIView transitionWithView:ivImage
                                   duration:0.5f
                                    options:UIViewAnimationOptionTransitionCrossDissolve
                                 animations:^
                  {
                      ivImage.image = [UIImage imageWithData:returnData];
                  } completion:NULL];

                 [arrURL addObject:url];
                 [arrData addObject:returnData];
             }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error)
             {
                 NSLog(@"Error: %@", error.description);
             }];
        }
    }
}



@end
