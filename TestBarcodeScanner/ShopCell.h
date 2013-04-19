//
//  ShopCell.h
//  ZhaoChanGuan
//
//  Created by zhang kai on 2/2/13.
//  Copyright (c) 2013 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopCell : UITableViewCell
{
    UIView *selectView;
    
    UIImageView *shopImageView;
    UILabel *shopNameLabel;
    UIImageView *starImageView;
    UILabel *categoriesLabel;
    UILabel *addressLabel;
}
@property(nonatomic,retain) UIImageView *shopImageView;
@property(nonatomic,retain) UILabel *shopNameLabel;
@property(nonatomic,retain) UIImageView *starImageView;
@property(nonatomic,retain) UILabel *categoriesLabel;
@property(nonatomic,retain) UILabel *addressLabel;
@end
