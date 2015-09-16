//
//  AddBusinessViewController.h
//  The Essex Pass
//
//  Created by Paras Chodavadiya on 23/05/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddBusinessViewController : UIViewController

- (IBAction)btnBack:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtPlaceName;
@property (weak, nonatomic) IBOutlet UITextField *txtLocation;
@property (weak, nonatomic) IBOutlet UITextView *txtAbout;

@property(strong, nonatomic) NSMutableDictionary *businessDetail;


- (IBAction)btnAdd:(id)sender;

@end
