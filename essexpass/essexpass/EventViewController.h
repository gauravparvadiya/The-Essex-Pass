//
//  EventViewController.h
//  essexpass
//
//  Created by Paras Chodavadiya on 08/01/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTCalendar.h"
#import "JTCalendarMenuMonthView.h"
#import "JTCalendarMonthView.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

//qtree
#import "QTree.h"
#import "QCluster.h"
#import "ClusterAnnotationView.h"

@interface EventViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,JTCalendarDataSource,UISearchBarDelegate,UISearchDisplayDelegate,MKMapViewDelegate>//, MNMBottomPullToRefreshManagerClient>
//{
//    MNMBottomPullToRefreshManager *pullToRefreshManager_;
//}
@property (weak, nonatomic) IBOutlet UIView *viewClassicCalendar;

@property (strong, nonatomic) JTCalendar *calendar;
@property (weak, nonatomic) IBOutlet JTCalendarContentView *calView;
@property (weak, nonatomic) IBOutlet JTCalendarMenuView *CalMenuView;

@property(nonatomic, strong) QTree* qTree;

@property (weak, nonatomic) IBOutlet UITableView *tveventlist;

@property (weak, nonatomic) IBOutlet UILabel *lblDate;

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

@property (weak, nonatomic) IBOutlet UIScrollView *svPopularEvent;

- (IBAction)btnDoneMenu:(id)sender;

- (IBAction)btnPage:(id)sender;

@property (weak, nonatomic) IBOutlet UISegmentedControl *btnPage;


@property (weak, nonatomic) IBOutlet UISearchBar *txtSearchBar;

@property (weak, nonatomic) IBOutlet UIButton *btnMap;

- (IBAction)btnMap:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewNearby;

@property (weak, nonatomic) IBOutlet UIView *viewNearbyList;

@property (weak, nonatomic) IBOutlet UIView *viewNearbyMap;

@property (weak, nonatomic) IBOutlet UITableView *tvNearby;

@property (weak, nonatomic) IBOutlet MKMapView *mvNearby;


@property (weak, nonatomic) IBOutlet UIImageView *btnPageBackground;


- (IBAction)btnRefresh:(id)sender;

@end
