//
//  Vocabulary.m
//  EFHack2013
//
//  Created by Yongwei on 18/4/13.
//  Copyright (c) 2013 zhangkai. All rights reserved.
//

#import "Vocabulary.h"

@implementation Vocabulary

+(Vocabulary *) initWithObject:(NSDictionary *)obj
{
    Vocabulary *result = [[Vocabulary alloc] init];
    
    result.word = [obj objectForKey:@"Word"];
    result.translation = [obj objectForKey:@"Translation"];
    result.audioPath = [NSString stringWithFormat:@"http://%@/etownresources/dictionary_mp3/%@.mp3",
                        SERVER_DOMAIN,
                        [obj objectForKey:@"AudioPath"]];
    result.partOfSpeech = [obj objectForKey:@"PartofSpeech"];
    result.pronunciationUK = [obj objectForKey:@"PhoneticPronunciationUK"];
    result.pronunciationUS = [obj objectForKey:@"PhoneticPronunciationUS"];
    result.sampleImage = @"http://userimage2.360doc.com/12/0227/13/925586_201202271335210705.jpg";
    result.sampleSentence = @"This is a sample sentence";
    
    return result;
}



@end
