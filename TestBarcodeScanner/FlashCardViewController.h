//
//  FlashCardViewController.h
//  EFHack2013
//
//  Created by Vincent on 13-4-18.
//  Copyright (c) 2013年 zhangkai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VocabularyDict.h"
#import "Vocabulary.h"
#import <AVFoundation/AVFoundation.h>

@interface FlashCardViewController : UIViewController {
    VocabularyDict *vDict;
}

@property (nonatomic, strong) Vocabulary *vocabulary;
@property (nonatomic, strong) NSString *audioPath;
@property (nonatomic, strong) UILabel *word;
@property (nonatomic, strong) UILabel *symbol;
@property (nonatomic, strong) UILabel *translation;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;


@end
