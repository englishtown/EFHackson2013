//
//  Restrant.h
//  ZhaoChanGuan
//
//  Created by zhang kai on 1/26/13.
//  Copyright (c) 2013 zhang kai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Restrant : NSObject


@property(nonatomic,retain) NSString *business_id;
@property(nonatomic,retain) NSString *name;
@property(nonatomic,retain) NSString *branch_name;
@property(nonatomic,retain) NSString *address;
@property(nonatomic,retain) NSString *telephone;
@property(nonatomic,retain) NSString *city;
@property(nonatomic,retain) NSArray *regions;
@property(nonatomic,retain) NSArray *categories;
@property(nonatomic,retain) NSString *avg_rating;
@property(nonatomic,retain) NSString *rating_img_url;
@property(nonatomic,retain) NSString *rating_s_img_url;
@property(nonatomic,retain) NSString *product_grade;
@property(nonatomic,retain) NSString *decoration_grade;
@property(nonatomic,retain) NSString *service_grade;
@property(nonatomic,retain) NSString *review_count;
@property(nonatomic,retain) NSString *distance;
@property(nonatomic,retain) NSString *business_url;
@property(nonatomic,retain) NSString *photo_url;

@property(nonatomic,retain) NSString *has_coupon;
@property(nonatomic,retain) NSString *coupon_id;
@property(nonatomic,retain) NSString *coupon_title;
@property(nonatomic,retain) NSString *coupon_url;

@property(nonatomic,retain) NSString *has_deal;
@property(nonatomic,retain) NSString *deal_id;
@property(nonatomic,retain) NSString *deal_title;
@property(nonatomic,retain) NSString *deal_url;

-(NSString *)getCategory;
@end
