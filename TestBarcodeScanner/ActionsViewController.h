//
//  ActionsViewController.h
//  TestBarcodeScanner
//
//  Created by Shi Lin on 4/18/13.
//  Copyright (c) 2013 Shi Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActionsViewController : UIViewController
@property (nonatomic, strong) IBOutlet UITableView *theList;
@property (nonatomic, strong) NSArray *datasource;
@property (nonatomic, strong) IBOutlet UITextField *name;
@property (nonatomic, strong) IBOutlet UITextField *contact;

@end
