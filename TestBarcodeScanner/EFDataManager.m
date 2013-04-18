//
//  EFDataManager.m
//  EFHack2013
//
//  Created by zhangkai on 4/18/13.
//  Copyright (c) 2013 zhangkai. All rights reserved.
//

#import "EFDataManager.h"
#import "AFNetworking.h"
#import "MediaData.h"

@implementation EFDataManager

+(id)sharedDataManager
{
    static EFDataManager *dataManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataManager = [[EFDataManager alloc]init];
    });
    return dataManager;
}
-(void)parseUrlResource:(NSString *)urlStr
{
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [theRequest setHTTPMethod:@"POST"];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:theRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"App.net Global Stream: %@", JSON);
        MediaData *mediaData = [self parseJsonData:JSON];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"JSON_DATA_Ready" object:mediaData userInfo:nil];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
        NSLog(@"---Error---: %@", [error description]);
    }];
    [operation start];
}

-(MediaData *)parseJsonData:(NSDictionary *)dic
{
    MediaData *mediaData = [[MediaData alloc]init];
    mediaData.HtmlPaper = [dic objectForKey:@"HtmlPaper"];
    mediaData.ImagePaper = [dic objectForKey:@"ImagePaper"];
    mediaData.Medias = [dic objectForKey:@"Medias"];
    return mediaData;
}
@end
