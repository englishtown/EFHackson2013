//
//  Vocabulary.h
//  EFHack2013
//
//  Created by Yongwei on 18/4/13.
//  Copyright (c) 2013 zhangkai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Vocabulary : NSObject


@property (nonatomic, strong) NSString *word;
@property (nonatomic, strong) NSString *translation;
@property (nonatomic, strong) NSString *audioPath;
@property (nonatomic, strong) NSString *partOfSpeech;
@property (nonatomic, strong) NSString *pronunciationUK;
@property (nonatomic, strong) NSString *pronunciationUS;
@property (nonatomic, strong) NSString *sampleImage;
@property (nonatomic, strong) NSString *sampleSentence;

+(Vocabulary *)initWithObject:(NSDictionary *)obj;


@end
