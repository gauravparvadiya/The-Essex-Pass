//
//  EventbriteViewController.h
//  The Essex Pass
//
//  Created by Paras Chodavadiya on 11/02/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventbriteViewController : UIViewController<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webview;

- (IBAction)btnBack:(id)sender;

@property (strong,nonatomic) NSString *eventbriteEventId;

@end
