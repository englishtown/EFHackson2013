//
//  ActionsViewController.m
//  TestBarcodeScanner
//
//  Created by Shi Lin on 4/18/13.
//  Copyright (c) 2013 Shi Lin. All rights reserved.
//

#import "ActionsViewController.h"
#import "StartActionViewController.h"

@interface ActionsViewController ()

@end

@implementation ActionsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.datasource = [NSArray arrayWithObjects:@"Mikeal Karon",@"Daniel Wallmark",@"Eric Azumi",@"Forrest Shi", nil];
    self.theList.separatorColor = [UIColor colorWithRed:6/255.0 green:64/255.0 blue:94/255.0 alpha:1.0];
    self.navigationController.navigationBar.topItem.title = @"introduce yourself";
    [self.name setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.name setValue:[UIFont systemFontOfSize:25] forKeyPath:@"_placeholderLabel.font"];
    [self.contact setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.contact setValue:[UIFont systemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.textColor = [UIColor colorWithRed:6/255.0 green:64/255.0 blue:94/255.0 alpha:1.0];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    cell.textLabel.text = [self.datasource objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController pushViewController:[[StartActionViewController alloc] init] animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.name resignFirstResponder];
    [self.contact resignFirstResponder];
}
@end
