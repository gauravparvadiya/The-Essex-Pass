//
//  SearchViewController.h
//  essexpass
//
//  Created by Paras Chodavadiya on 27/01/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface SearchViewController : UIViewController<CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource,MKMapViewDelegate,UITextFieldDelegate>

- (IBAction)btnSearchByLocation:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnSearchByLocation;

- (IBAction)btnSearchByName:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnSearchByName;

@property (weak, nonatomic) IBOutlet UITextField *txtSearch;

- (IBAction)btnNearest:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnNearest;

- (IBAction)btnAlphabetical:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnAlphabetical;

- (IBAction)btnRating:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnRating;

- (IBAction)btnBack:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnBack;

- (IBAction)btnSearch:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *lblFilterName;

@property (weak, nonatomic) IBOutlet UITableView *tvFilter;

@property (strong, nonatomic) UINib *searchCellNib;


@end
