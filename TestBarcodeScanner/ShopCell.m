//
//  ShopCell.m
//  ZhaoChanGuan
//
//  Created by zhang kai on 2/2/13.
//  Copyright (c) 2013 zhang kai. All rights reserved.
//

#import "ShopCell.h"

@implementation ShopCell
@synthesize shopImageView ,shopNameLabel ,starImageView , categoriesLabel ,addressLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        selectView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 110)];
        selectView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:224/255 alpha:0.6];
        [self addSubview:selectView];
        selectView.hidden = YES;
        
        self.shopImageView = [[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 120, 90)]autorelease];
        [self addSubview:self.shopImageView];
        
        self.shopNameLabel = [[[UILabel alloc]initWithFrame:CGRectMake(135, 10, 170, 30)]autorelease];
        self.shopNameLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.shopNameLabel];
        
        self.starImageView = [[[UIImageView alloc]initWithFrame:CGRectMake(135, 45, 80, 20)]autorelease];
        self.starImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.starImageView];
        
        self.categoriesLabel = [[[UILabel alloc]initWithFrame:CGRectMake(220, 45 - 4, 90, 30)]autorelease];
        self.categoriesLabel.backgroundColor = [UIColor clearColor];
        self.categoriesLabel.font = [UIFont systemFontOfSize:12];
        self.categoriesLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:self.categoriesLabel];
        
        self.addressLabel = [[[UILabel alloc]initWithFrame:CGRectMake(135, 70, 180, 30)]autorelease];
        self.addressLabel.backgroundColor = [UIColor clearColor];
        self.addressLabel.font = [UIFont systemFontOfSize:12];
        self.addressLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:self.addressLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
