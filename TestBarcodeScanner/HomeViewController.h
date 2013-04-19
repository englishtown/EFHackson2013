//
//  HomeViewController.h
//  ZhaoChanGuan
//
//  Created by zhang kai on 1/23/13.
//  Copyright (c) 2013 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Restrants.h"

@interface HomeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>
{    
    UITableView *myTableView;
    
    CLLocationManager *locationManager;
    CLLocation *mylocation;
    
    Restrants *restrants;
}
@property(nonatomic,retain) CLLocation *mylocation;
@property(nonatomic,retain) Restrants *restrants;

-(void)huntRestrant;
@end
