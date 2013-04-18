//
//  ViewController.h
//  EFHack2013
//
//  Created by zhangkai on 4/18/13.
//  Copyright (c) 2013 zhangkai. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "Vocabulary.h"
//#import "VocabularyDict.h"
#import "FlashCardViewController.h"

@interface FlashCardRootViewController : UIViewController <UIScrollViewDelegate> {
    
    
}
@property (nonatomic, strong) VocabularyDict *contentVocabulary;

@end
