//
//  SubDealsViewController.h
//  essexpass
//
//  Created by Paras Chodavadiya on 10/01/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface SubDealsViewController : UIViewController

@property (strong,nonatomic)NSString *eventId;

@property (weak, nonatomic) IBOutlet UIImageView *ivEvent;

@property (weak, nonatomic) IBOutlet UILabel *lblEventName;

@property (weak, nonatomic) IBOutlet UIButton *btnDetails;

- (IBAction)btnDetails:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnLocation;

- (IBAction)btnLocation:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnContact;

- (IBAction)btnContact:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnConditions;

- (IBAction)btnConditions:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *lblDescription1;

@property (weak, nonatomic) IBOutlet UILabel *lblDescription2;

@property (weak, nonatomic) IBOutlet UILabel *lblPrice;

@property (weak, nonatomic) IBOutlet UILabel *lblDesh;

@property (weak, nonatomic) IBOutlet UILabel *lblOfferPrice;

@property (weak, nonatomic) IBOutlet UILabel *lblDiscount;

@property (weak, nonatomic) IBOutlet UILabel *lblTime;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@property (weak, nonatomic) IBOutlet UIView *viewDetails;

@property (weak, nonatomic) IBOutlet UIView *viewLocation;
@property (weak, nonatomic) IBOutlet MKMapView *mvLocation;
@property (weak, nonatomic) IBOutlet UITextView *txtAddress;

@property (weak, nonatomic) IBOutlet UIView *viewContact;

@property (weak, nonatomic) IBOutlet UIView *viewConditions;
@property (weak, nonatomic) IBOutlet UITextView *txtConditions;




- (IBAction)btnBack:(id)sender;

@end
