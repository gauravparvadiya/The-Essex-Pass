//
//  AboutViewController.h
//  The Essex Pass
//
//  Created by Paras Chodavadiya on 30/01/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController

- (IBAction)btnBack:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblVersion;
@property (weak, nonatomic) IBOutlet UILabel *lblApplicationName;

@end
