//
//  MessageViewController.h
//  The Essex Pass
//
//  Created by Paras Chodavadiya on 11/02/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UILabel *lblDate;

@property (weak, nonatomic) IBOutlet UILabel *lblTime;

@property (weak, nonatomic) IBOutlet UITextView *txtDescription;

@property(strong ,nonatomic)NSString *messageTitle, *date, *time, *messageDescription;

@property (weak, nonatomic) IBOutlet UIButton *btnBack;

- (IBAction)btnBack:(id)sender;

@end
