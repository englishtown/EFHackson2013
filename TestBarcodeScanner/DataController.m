//
//  DataController.m
//  ZhaoChanGuan
//
//  Created by zhang kai on 1/23/13.
//  Copyright (c) 2013 zhang kai. All rights reserved.
//

#import <CommonCrypto/CommonHMAC.h>
#import "DataController.h"
#import "Parse.h"

#import "Restrants.h"
#import "NotificationName.h"

#define ServerIp @"http://api.dianping.com/v1/business/find_businesses"
#define AppKey @"4061232521"
#define AppSecret @"15af841455254c71bfde7b012e4ec71f"

@implementation DataController

+(id)sharedDataController
{
    static DataController *dataController;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        dataController = [[DataController alloc]init];
    });
    return dataController;
}

-(NSString *)createSHA:(NSString*)hashkey
{    
    // PHP uses ASCII encoding, not UTF
    const char *s = [hashkey cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *keyData = [NSData dataWithBytes:s length:strlen(s)];
    
    // This is the destination
    uint8_t digest[CC_SHA1_DIGEST_LENGTH] = {0};
    // This one function does an unkeyed SHA1 hash of your hash data
    CC_SHA1(keyData.bytes, keyData.length, digest);
    
    // Now convert to NSData structure to make it usable again
    NSData *out = [NSData dataWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
    // description converts to hex but puts <> around it and spaces every 4 bytes
    NSString *hash = [out description];
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    return [hash retain];
}

-(NSString *)createSign:(NSMutableDictionary *)params
{
    NSArray *keys=[params allKeys];
    keys=[keys sortedArrayUsingSelector:@selector(compare:)];
    
    NSString *signData=[[[NSString alloc] init]autorelease];
    signData=[signData stringByAppendingFormat:AppKey];
    for(NSString *key in keys)
    {
        signData=[signData stringByAppendingFormat:@"%@%@",key,[params objectForKey:key]];
    }
    signData=[signData stringByAppendingFormat:AppSecret];
    return [self createSHA:signData];
}

-(void)fetachRestrant:(float)lat longitude:(float)lon
{
        
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"美食" forKey:@"category"];
    [params setObject:[NSString stringWithFormat:@"%f",lat] forKey:@"latitude"];
    [params setObject:[NSString stringWithFormat:@"%f",lon] forKey:@"longitude"];
    [params setObject:@"3" forKey:@"sort"];
    [params setObject:@"200" forKey:@"radius"];
    [params setObject:@"json" forKey:@"format"];
    
    NSString *sign = [self createSign:params];
    
    NSString *bsign = [sign uppercaseString];
    
    NSString *urlString = [NSString stringWithFormat:@"%@?appkey=%@&sign=%@&category=美食&format=json&latitude=%f&longitude=%f&sort=3&radius=200",ServerIp,AppKey,bsign,lat,lon];
    NSString* escapedUrlString =
    [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:escapedUrlString]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    [request setHTTPMethod: @"GET"];
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    NSData *response1 = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    
     if (response1 == nil) {
         
     }else{
         Restrants *restrants = [[[Restrants alloc]init]autorelease];
         restrants = [[Parse sharedParse] parseRestrants:response1];
         [[NSNotificationCenter defaultCenter]postNotificationName:GET_SHOP_DATA object:restrants userInfo:nil];
     }
    
    [params release];        
}
@end
