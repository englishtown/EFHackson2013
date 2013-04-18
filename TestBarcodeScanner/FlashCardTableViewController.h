//
//  FlashCardTableViewController.h
//  EFHack2013
//
//  Created by Vincent on 13-4-18.
//  Copyright (c) 2013年 zhangkai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VocabularyDict.h"

@interface FlashCardTableViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource> {
    
}

@property (nonatomic, strong) VocabularyDict *contentVocabulary;

@end
