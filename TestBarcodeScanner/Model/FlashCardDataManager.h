//
//  FlashCardDataManager.h
//  EFHack2013
//
//  Created by Vincent on 13-4-18.
//  Copyright (c) 2013年 zhangkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vocabulary.h"
#import "VocabularyDict.h"

@interface FlashCardDataManager : NSObject {
    
}

@property (nonatomic, strong) VocabularyDict* contentVocabulary;

+(FlashCardDataManager *)sharedInstance;
- (void)pullVocabularyDataOfUnitId:(int)unit_id withCulture:(NSString *)cultureCode withDoneBlock:(void (^)(void))block;


@end
