//
//  TXHttpRequest.h
//  ____
//
//  Created by Thinkey on 10/4/12.
//  Copyright (c) 2012 Thinkey. All rights reserved.
//


typedef enum {
    TXRequestResultNa,    
    TXRequestSuccess,
    TXRequestResponseError,
    TXRequestConnectionError
} TXRequestResultType;

typedef enum {
    TXRequestParserNone,    
    TXRequestParserJson,
    TXRequestParserXml
} TXRequestParserMode;

@class TXHttpRequest;
typedef void (^TXRequestDoneBlock)(TXHttpRequest *);

@interface TXHttpRequest : NSObject 
@property (nonatomic, strong) NSString *_gateway;
@property (nonatomic, strong) NSString *_endPoint;
@property (nonatomic, strong) NSDictionary *_parameters;
@property (nonatomic, strong) NSString *_httpMethod;
@property (nonatomic, assign) NSTimeInterval _timeout;
@property (nonatomic, strong) NSMutableData *_rawData;
@property (nonatomic, strong) id _parsedData;
@property (nonatomic, readonly) TXRequestResultType _result;
@property (nonatomic, assign) TXRequestParserMode _parserMode;
@property (nonatomic, copy) TXRequestDoneBlock _doneBlock;
@property (nonatomic, assign) int _retry;
@property (nonatomic, strong) id _postData;

- (void)sendRequest;
- (id)initWithEndPoint:(NSString *)endPoint parameters:(NSDictionary *)parameters doneBlock:(TXRequestDoneBlock)doneBlock;
+ (id)requestWithEndPoint:(NSString *)endPoint parameters:(NSDictionary *)parameters doneBlock:(TXRequestDoneBlock)doneBlock;
+ (id)sendRequestWithEndPoint:(NSString *)endPoint parameters:(NSDictionary *)parameters doneBlock:(TXRequestDoneBlock)doneBlock;
@end
