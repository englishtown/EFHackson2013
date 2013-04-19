//
//  EFDownloadManualAgent.m
//  Efekta12NavigationTest
//
//  Created by zhangkai on 4/11/13.
//  Copyright (c) 2013 EF Englishtown. All rights reserved.
//

//define our common queue operations, eg : add operation to begin of queue . no ef logic but supply convenience interface for ef cource logic use 

#import <CommonCrypto/CommonDigest.h>
#import "EFDownloadManager.h"
#import "AFNetworking.h"    
//#import "EFDownloadOperation.h"

@interface EFDownloadManager()
{
    //this dictionary record all the finished and started operations for both queue , notice : need to remove the operation in dictionay if uncompress fails
//    NSMutableDictionary *startedAndFinishedOperationsDic;
}
@end

@implementation EFDownloadManager

//manual download queue
+ (NSOperationQueue *)sharedManualDownloadOperationQueue {
    static NSOperationQueue *downloadOperationQueue = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        downloadOperationQueue = [[NSOperationQueue alloc] init];
        [downloadOperationQueue setMaxConcurrentOperationCount:1];
    });
    
    return downloadOperationQueue;
}
//automatic download queue
+ (NSOperationQueue *)sharedAutomaticDownloadOperationQueue {
    static NSOperationQueue *downloadOperationQueue = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        downloadOperationQueue = [[NSOperationQueue alloc] init];
        [downloadOperationQueue setMaxConcurrentOperationCount:1];
    });
    
    return downloadOperationQueue;
}

+(EFDownloadManager *)sharedEFDownloadManager
{
    static EFDownloadManager *downloadManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        downloadManager = [[EFDownloadManager alloc]init];
    });
    return downloadManager;
}

+(NSMutableDictionary *)sharedDownloadDictionary
{
    static NSMutableDictionary *startedAndFinishedOperationsDic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        startedAndFinishedOperationsDic = [NSMutableDictionary dictionary];
    });
    return startedAndFinishedOperationsDic;
}
//for manual download queue to add a download operations in queue , this queue should not be canceled if user not click the cancel button
-(void)enQueueUrl:(NSString *)urlStr unzipToPath:(NSString *)unzipPath atPriority:(int)priority callback:(void(^)(NSString *urlS))success{
        
    NSString *properlyEscapedURL = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:properlyEscapedURL]];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    requestOperation.outputStream = [NSOutputStream outputStreamToFileAtPath:unzipPath append:YES];
    
    __block NSString *blockUrlStr = urlStr;
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (success) {
            success(blockUrlStr);
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@/n",[error description]);
    }];
    [[[self class]sharedManualDownloadOperationQueue] addOperation:requestOperation];
}

- (NSString *)urlencode:(NSString *)str {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[str UTF8String];
    int sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

-(void)pauseUrl:(NSString *)urlStr{
    
}
-(void)cancelUrl:(NSString *)urlStr{
    
}
-(void)pauseAll{
    
    [[[self class]sharedManualDownloadOperationQueue]cancelAllOperations];
}
-(void)cancelAll{
    
    [[[self class]sharedManualDownloadOperationQueue]cancelAllOperations];
    //remove all part downloaded tem files 
}

@end
