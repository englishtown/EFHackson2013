//
//  HomeViewController.m
//  ZhaoChanGuan
//
//  Created by zhang kai on 1/23/13.
//  Copyright (c) 2013 zhang kai. All rights reserved.
//

#import "HomeViewController.h"
#import "DataController.h"
#import "Restrant.h"
#import "NotificationName.h"
#import "UIImageView+WebCache.h"
#import "ShopCell.h"

@interface HomeViewController ()
@end

@implementation HomeViewController
@synthesize mylocation;
@synthesize restrants;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    restrants = [[Restrants alloc]init];
    
	// Do any additional setup after loading the view.
    myTableView = [[UITableView alloc]initWithFrame: CGRectMake(0,0,320,460) style:UITableViewStylePlain];
    myTableView.rowHeight = 110;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];
    
    //[self addObserver:self forKeyPath:@"mylocation" options:0 context:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getTheShopData:) name:GET_SHOP_DATA object:nil];
        
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[self addObserver:self forKeyPath:@"mylocation" options:0 context:nil];
    [locationManager startUpdatingLocation];
}

-(void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context {
    if (object == self && [keyPath isEqualToString:@"mylocation"]) {
        
        [self huntRestrant];
    }
}
-(void)getTheShopData:(NSNotification *)noti
{
    self.restrants = [noti object];
    [myTableView reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[restrants restrantsArray]count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[[ShopCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"]autorelease];
    }
    
    Restrant *restrant = [[restrants restrantsArray]objectAtIndex:indexPath.row];
    cell.shopNameLabel.text = restrant.name;
    [cell.shopImageView setImageWithURL:[NSURL URLWithString:restrant.photo_url] placeholderImage:[UIImage imageNamed:@"NoPicFrame"]];
    [cell.starImageView setImageWithURL:[NSURL URLWithString:restrant.rating_s_img_url] placeholderImage:nil];
    cell.categoriesLabel.text = [restrant getCategory];
    cell.addressLabel.text = restrant.address;
    return cell;
}

-(void)huntRestrant
{
    DataController *dataController = [DataController sharedDataController];
    [dataController fetachRestrant:mylocation.coordinate.latitude longitude:mylocation.coordinate.longitude];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"OldLocation %f %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
    NSLog(@"NewLocation %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    if (mylocation == nil) {
        self.mylocation = newLocation;
        [self huntRestrant];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [locationManager stopUpdatingLocation];
   // [self removeObserver:self forKeyPath:@"mylocation"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
