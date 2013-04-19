//
//  FlashCardDataManager.m
//  EFHack2013
//
//  Created by Vincent on 13-4-18.
//  Copyright (c) 2013. All rights reserved.
//

#import "FlashCardDataManager.h"


@implementation FlashCardDataManager

+(FlashCardDataManager *)sharedInstance{
    __strong static FlashCardDataManager *_instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[FlashCardDataManager alloc] init];
    });
    return _instance;
}

- (void)pullVocabularyDataOfUnitId:(int)unit_id withCulture:(NSString *)cultureCode withDoneBlock:(void (^)(void))block
{
    NSString *url = [NSString stringWithFormat:@"http://%@/hackthon/Overview/Unit/Unitoverview/LoadUnitOverviewInfo/?unit_id=%d&cultureCode=%@", SERVER_DOMAIN, unit_id, cultureCode];
    
    dispatch_queue_t pullVocabulary = dispatch_queue_create("vocabulary", NULL);
    dispatch_async(pullVocabulary, ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString: url]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSelectorOnMainThread:@selector(fetchedVocabularyData:)
                                   withObject:data waitUntilDone:YES];
            
            ((void (^)())block)();
            
        });
    });
}

- (void)fetchedVocabularyData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary *json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          options:kNilOptions
                          error:&error];
    NSArray *jsonArray = [json objectForKey:@"Words"];
    self.contentVocabulary = [VocabularyDict initWithObject:jsonArray];
    Vocabulary *voc = [self.contentVocabulary objectForKey:[[self.contentVocabulary allKeys] objectAtIndex:0]];
    NSLog(@"first vocabulary word is:%@ , translation: %@", voc.word, voc.translation);
}



@end
