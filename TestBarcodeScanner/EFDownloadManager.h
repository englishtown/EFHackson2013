//
//  EFDownloadManualAgent.h
//  Efekta12NavigationTest
//
//  Created by zhangkai on 4/11/13.
//  Copyright (c) 2013 EF Englishtown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EFDownloadManager : NSObject

+(EFDownloadManager *)sharedEFDownloadManager;
+(NSMutableDictionary *)sharedDownloadDictionary;
-(void)enQueueUrl:(NSString *)urlStr unzipToPath:(NSString *)unzipPath atPriority:(int)priority callback:(void(^)(NSString *urlS))success;
-(void)preLoadUrls:(NSArray *)urlStrs unzipToPathes:(NSArray *)unzipPaths callback:(void(^)(long progress))progress;
-(void)pauseUrl:(NSString *)urlStr;
-(void)cancelUrl:(NSString *)urlStr;
-(void)pauseAll;
-(void)cancelAll;

@end
