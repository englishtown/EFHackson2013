//
//  VocabularyDict.m
//  EFHack2013
//
//  Created by Yongwei on 18/4/13.
//  Copyright (c) 2013 zhangkai. All rights reserved.
//

#import "VocabularyDict.h"
#import "Vocabulary.h"

@implementation VocabularyDict

+(VocabularyDict *)initWithObject:(NSArray *)obj
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    
    if(obj != nil)
    {
        for (int i = 0; i < obj.count; i++) {
            NSDictionary *iDict = [obj objectAtIndex:i];
            Vocabulary *iVoc = [Vocabulary initWithObject:iDict];
            
            [result setValue:iVoc forKey:iVoc.word];
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:result];
}

@end
