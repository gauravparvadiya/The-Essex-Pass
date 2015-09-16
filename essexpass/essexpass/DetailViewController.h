//
//  DetailViewController.h
//  essexpass
//
//  Created by Paras Chodavadiya on 21/01/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MessageUI/MessageUI.h>

@interface DetailViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

- (IBAction)btnRegister:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnRegister;

@property (strong,nonatomic)NSString *eventId, *eventbriteEventId, *headerDate;
@property (strong,nonatomic)NSString *dealId, *dealName, *dealExpireDate, *dealPlace, *actualDeal;
@property (strong,nonatomic)NSMutableArray *loyalty;

@property (strong, nonatomic) NSMutableDictionary *dealDetail;
@property (strong, nonatomic) NSMutableDictionary *eventDetail;

@property (weak, nonatomic) IBOutlet UIImageView *ivEvent;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UILabel *lblEventName;

@property (weak, nonatomic) IBOutlet UIButton *btnDetails;

- (IBAction)btnDetails:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnLocation;

- (IBAction)btnLocation:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnContact;

- (IBAction)btnContact:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnConditions;

- (IBAction)btnConditions:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnStar;

- (IBAction)btnStar:(id)sender;

- (IBAction)btnShare:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@property (weak, nonatomic) IBOutlet UILabel *lblBackOffer;
@property (weak, nonatomic) IBOutlet UILabel *lblOffer;


@property (weak, nonatomic) IBOutlet UILabel *lblPrice;

@property (weak, nonatomic) IBOutlet UILabel *lblDesh;

@property (weak, nonatomic) IBOutlet UILabel *lblOfferPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblCapacity;

@property (weak, nonatomic) IBOutlet UILabel *lblDiscount;

@property (weak, nonatomic) IBOutlet UILabel *lblStartDate;
@property (weak, nonatomic) IBOutlet UILabel *lblEndDate;

@property (weak, nonatomic) IBOutlet UITextView *txtDescription;
@property (weak, nonatomic) IBOutlet UIView *viewDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@property (weak, nonatomic) IBOutlet UIView *viewDetails;
@property (weak, nonatomic) IBOutlet UIView *viewDetailsDeal;

@property (weak, nonatomic) IBOutlet UIView *viewLocation;
@property (weak, nonatomic) IBOutlet MKMapView *mvLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;

@property (weak, nonatomic) IBOutlet UIView *viewContact;

@property (weak, nonatomic) IBOutlet UIView *viewConditions;

@property (weak, nonatomic) IBOutlet UIView *viewDealConditions;

@property (weak, nonatomic) IBOutlet UIView *viewBussinessDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblBussinessDescription;

@property (weak, nonatomic) IBOutlet UIView *viewDeal;

@property (weak, nonatomic) IBOutlet UILabel *lblDeal;

@property (weak, nonatomic) IBOutlet UIButton *btnWriteReview;

- (IBAction)btnWriteReview:(id)sender;


@property (weak, nonatomic) IBOutlet UIImageView *iv1;
@property (weak, nonatomic) IBOutlet UIImageView *iv2;
@property (weak, nonatomic) IBOutlet UIImageView *iv3;
@property (weak, nonatomic) IBOutlet UIImageView *iv4;
@property (weak, nonatomic) IBOutlet UIImageView *iv5;
@property (weak, nonatomic) IBOutlet UIImageView *iv6;

@property (weak, nonatomic) IBOutlet UILabel *lblConditions;

@property (weak, nonatomic) IBOutlet UIButton *btnContactName;
@property (weak, nonatomic) IBOutlet UILabel *lblContactName;

@property (weak, nonatomic) IBOutlet UILabel *lblPhoneNumber;
- (IBAction)btnCall:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *lblEmail;
- (IBAction)btnEmail:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *lblWebsite;
- (IBAction)btnWeb:(id)sender;
- (IBAction)btnBack:(id)sender;

//Review
@property (weak, nonatomic) IBOutlet UIImageView *ivStar1;
@property (weak, nonatomic) IBOutlet UIImageView *ivStar2;
@property (weak, nonatomic) IBOutlet UIImageView *ivStar3;
@property (weak, nonatomic) IBOutlet UIImageView *ivStar4;
@property (weak, nonatomic) IBOutlet UIImageView *ivStar5;


@property (weak, nonatomic) IBOutlet UIView *viewIndicator;
@property (weak, nonatomic) IBOutlet UITableView *tvReview;

@property (weak, nonatomic) IBOutlet UIView *viewVideo;

@end
