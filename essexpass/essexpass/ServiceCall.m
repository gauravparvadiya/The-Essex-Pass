//
//  ServiceCall.m
//  essexpass
//
//  Created by Paras Chodavadiya on 06/01/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import "ServiceCall.h"
#import "MBProgressHUD.h"

@implementation ServiceCall

-(NSMutableDictionary *)serviceCall : (NSString *)serviceName : (NSMutableDictionary *)jsonDictionary
{
    //NSLog(@"Service Name : %@",serviceName);
    //NSLog(@"JsonDictionry : %@",jsonDictionary);
    
    NSError *error;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",serviceName]];
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:kNilOptions error:&error];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonData];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSMutableDictionary *response = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableLeaves error:&error];
    //NSLog(@"response : %@",response);
    return response;
}
@end
