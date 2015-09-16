//
//  ServiceCall.h
//  essexpass
//
//  Created by Paras Chodavadiya on 06/01/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceCall : NSObject

-(NSMutableDictionary *)serviceCall : (NSString *)serviceName : (NSMutableDictionary *)jsonDictionary;

@end
