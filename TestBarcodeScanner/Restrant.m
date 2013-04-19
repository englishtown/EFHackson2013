//
//  Restrant.m
//  ZhaoChanGuan
//
//  Created by zhang kai on 1/26/13.
//  Copyright (c) 2013 zhang kai. All rights reserved.
//

#import "Restrant.h"

@implementation Restrant
@synthesize business_id = _business_id ,name ,branch_name ,address = _address ,telephone ,city = _city;
@synthesize regions ,categories = _categories ,avg_rating ,rating_img_url ,rating_s_img_url ,product_grade;
@synthesize decoration_grade ,service_grade ,review_count ,distance ,business_url ,photo_url;
@synthesize has_coupon ,coupon_id ,coupon_title ,coupon_url ,has_deal ,deal_id ,deal_title ,deal_url;

-(NSString *)getCategory
{
    NSString *categoryName = @"";
    for (NSString *cName in _categories) {
        categoryName = [NSString stringWithFormat:@"%@%@",categoryName,cName];
    }
    return categoryName;
}
@end
