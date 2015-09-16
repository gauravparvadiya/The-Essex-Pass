//
//  DealsViewController.h
//  essexpass
//
//  Created by Paras Chodavadiya on 21/01/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//


//#import "MNMBottomPullToRefreshManager.h"
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

//qtree
#import "QTree.h"
#import "QCluster.h"
#import "ClusterAnnotationView.h"

@interface DealsViewController2 : UIViewController<CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource,MKMapViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate>
//,MNMBottomPullToRefreshManagerClient>
//{
//    MNMBottomPullToRefreshManager *pullToRefreshManager_;
//}

@property (weak, nonatomic) IBOutlet UIView *viewClassicCalendar;

@property (nonatomic, readwrite, strong) IBOutlet UITableView *tvDeallist;

- (IBAction)btnCalendar:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnCalendar;

- (IBAction)datePicker:(id)sender;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (weak, nonatomic) IBOutlet UIView *calendarView;

@property (weak, nonatomic) IBOutlet UIButton *btnDone;

- (IBAction)btnDone:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tvMenu;

- (IBAction)btnmenu:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *menuView;

- (IBAction)btnDoneMenu:(id)sender;

@property (weak, nonatomic) IBOutlet UISegmentedControl *btnPage;

- (IBAction)btnPage:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnMap;

- (IBAction)btnMap:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewNearby;

@property (weak, nonatomic) IBOutlet UIView *viewNearbyList;

@property (weak, nonatomic) IBOutlet UIView *viewNearbyMap;

@property (weak, nonatomic) IBOutlet UITableView *tvNearby;

@property (weak, nonatomic) IBOutlet MKMapView *mvNearby;


@property (weak, nonatomic) IBOutlet UIImageView *btnPageBackground;

@property(nonatomic, strong) QTree* qTree;


@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

- (IBAction)segmentedControl:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnRefresh;

- (IBAction)btnRefresh:(id)sender;


@end
