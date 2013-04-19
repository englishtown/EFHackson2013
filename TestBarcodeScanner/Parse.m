//
//  Parse.m
//  ZhaoChanGuan
//
//  Created by zhang kai on 1/26/13.
//  Copyright (c) 2013 zhang kai. All rights reserved.
//

#import "Parse.h"
#import "JSONKit.h"

@implementation Parse


+(id)sharedParse
{
    static Parse *parse;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        parse = [[Parse alloc]init];
    });
    return parse;
}

-(Restrant *)parseRestrant:(NSDictionary *)dictionary 
{
    Restrant *restrant = [[Restrant alloc]init];
    
    restrant.business_id = [dictionary objectForKey:@"business_id"];
    restrant.name = [dictionary objectForKey:@"name"];
    restrant.branch_name = [dictionary objectForKey:@"branch_name"];
    restrant.city = [dictionary objectForKey:@"city"];
    restrant.address = [dictionary objectForKey:@"address"];
    restrant.telephone = [dictionary objectForKey:@"telephone"];
    restrant.regions = [dictionary objectForKey:@"regions"];
    restrant.categories = [dictionary objectForKey:@"categories"];
    restrant.avg_rating = [dictionary objectForKey:@"avg_rating"];
    restrant.rating_img_url = [dictionary objectForKey:@"rating_img_url"];
    restrant.rating_s_img_url = [dictionary objectForKey:@"rating_s_img_url"];
    restrant.product_grade = [dictionary objectForKey:@"product_grade"];
    restrant.decoration_grade = [dictionary objectForKey:@"decoration_grade"];
    restrant.service_grade = [dictionary objectForKey:@"service_grade"];
    restrant.review_count = [dictionary objectForKey:@"review_count"];
    restrant.distance = [dictionary objectForKey:@"distance"];
    restrant.business_url = [dictionary objectForKey:@"business_url"];
    restrant.photo_url = [dictionary objectForKey:@"photo_url"];
    restrant.has_coupon = [dictionary objectForKey:@"has_coupon"];
    restrant.coupon_id = [dictionary objectForKey:@"coupon_id"];
    restrant.coupon_title = [dictionary objectForKey:@"coupon_title"];
    restrant.coupon_url = [dictionary objectForKey:@"coupon_url"];
    restrant.has_deal = [dictionary objectForKey:@"has_deal"];
    restrant.deal_id = [dictionary objectForKey:@"deal_id"];
    restrant.deal_title = [dictionary objectForKey:@"deal_title"];
    restrant.deal_url = [dictionary objectForKey:@"deal_url"];
    
    return [restrant autorelease];
}

-(Restrants *)parseRestrants:(NSData *)data
{
    Restrants *restrants = [[Restrants alloc]init];
    NSString *jsonString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *jsonDictionary = [jsonString objectFromJSONString];
    [jsonString release];
    
    restrants.status = [jsonDictionary objectForKey:@"status"];
    restrants.count = [jsonDictionary objectForKey:@"count"];
    
    NSArray *restrantArray = [jsonDictionary objectForKey:@"businesses"];
    
    NSMutableArray *multableArray = [NSMutableArray array];
    for (NSDictionary *oneDic in restrantArray){
        
        Restrant *restrant = [self parseRestrant:oneDic];
        [multableArray addObject:restrant];
    }
    restrants.restrantsArray = [NSArray arrayWithArray:multableArray];
    return [restrants autorelease];
}

@end
