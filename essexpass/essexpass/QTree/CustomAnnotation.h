//
// This file is subject to the terms and conditions defined in
// file 'LICENSE.md', which is part of this source code package.
//

@import MapKit;

#import "QTreeInsertable.h"


@interface CustomAnnotation : NSObject<MKAnnotation, QTreeInsertable>

@property(nonatomic, assign) CLLocationCoordinate2D coordinate;
//@property (nonatomic, copy) NSString *title;
//@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, assign) NSString *locationType;
@property(nonatomic, strong) NSString *titleOfAnnotation;
@property (nonatomic, copy)     NSString* tag;
//@property(nonatomic, strong) NSString *tagofan;

-(NSString*)title;
-(NSString *)tag;
@end