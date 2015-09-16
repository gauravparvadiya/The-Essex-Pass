//
//  NearMeViewController.h
//  essexpass
//
//  Created by Paras Chodavadiya on 13/01/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
//qtree
#import "QTree.h"
#import "QCluster.h"
#import "ClusterAnnotationView.h"

@interface NearMeViewController : UIViewController<CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource,MKMapViewDelegate>

- (IBAction)btnBack:(id)sender;

- (IBAction)btnMap:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnMap;

- (IBAction)btnRefresh:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnRefresh;

- (IBAction)btnFilter:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tvEventList;

@property (weak, nonatomic) IBOutlet MKMapView *mvEvent;

@property (weak, nonatomic) IBOutlet UIView *viewList;

@property (weak, nonatomic) IBOutlet UIView *viewMap;

@property(nonatomic, strong) QTree* qTree;


@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@end
