//
//  VideoViewController.h
//  The Essex Pass
//
//  Created by Paras Chodavadiya on 10/03/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoViewController : UIViewController<UIWebViewDelegate>
- (IBAction)btnBack:(id)sender;
@property (weak, nonatomic) IBOutlet UIWebView *wvVideo;
@property (strong, nonatomic)NSString *videoLink;
@end
