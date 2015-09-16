//
//  RecommendedBusinessViewController.h
//  The Essex Pass
//
//  Created by Paras ChRecommendedBusinessTableViewCellodavadiya on 23/05/15.
//  Copyright (c) 2015 IBL Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendedBusinessViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UITextFieldDelegate>

- (IBAction)btnBack:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tvBussiness;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UIButton *btnNew;
- (IBAction)btnNew:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewImage;
@property (weak, nonatomic) IBOutlet UIView *viewSearch;

@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
- (IBAction)btnCancel:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *txtSearch;
- (IBAction)txtSearch:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *lblStatus;

@end
