//
//  FlashCardViewController.m
//  EFHack2013
//
//  Created by Vincent on 13-4-18.
//  Copyright (c) 2013年 zhangkai. All rights reserved.
//

#import "FlashCardViewController.h"


@interface FlashCardViewController ()

@end

@implementation FlashCardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#define labelHeight 40

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.word = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 200, labelHeight)];
    self.symbol = [[UILabel alloc] initWithFrame:CGRectMake(10, 90, 200, labelHeight)];
    self.translation = [[UILabel alloc] initWithFrame:CGRectMake(10, 130, 220, 60)];
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 220, 300, 240)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.translation.numberOfLines = 0;
    self.isImageLoaded = false;
    
    UIButton *audioButton = [[UIButton alloc] initWithFrame:CGRectMake(250, 50, 50, 50)];
    [audioButton setBackgroundImage:[UIImage imageNamed:@"sound_big.png"] forState:UIControlStateNormal];
    [audioButton addTarget:self action:@selector(playAudio) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.word];
    [self.view addSubview:self.symbol];
    [self.view addSubview:self.translation];
    [self.view addSubview:audioButton];
    [self.view addSubview:self.imageView];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [self layoutVocabularyView];
    [self loadImage];
}




- (void)layoutVocabularyView {
    self.word.text = self.vocabulary.word;
    self.symbol.text = [NSString stringWithFormat:@"/%@/", self.vocabulary.pronunciationUK];
    self.translation.text = [NSString stringWithFormat:@"[%@]  %@", self.vocabulary.partOfSpeech, self.vocabulary.translation];
    
}

- (void)playAudio {
    
    dispatch_queue_t playAudioQ = dispatch_queue_create("playAudio", NULL);
    dispatch_async(playAudioQ, ^{
        
        NSString *_mp3file = self.vocabulary.audioPath;
        NSData *_mp3data = [NSData dataWithContentsOfURL:[NSURL URLWithString: _mp3file]];
        if (_mp3data == nil) {
            return;
        }
        
        NSError *error;
        self.audioPlayer = [[AVAudioPlayer alloc] initWithData:_mp3data error:&error];

        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        [self.audioPlayer play];
    }
                   );
}



- (void)loadImage {
    
    if (self.isImageLoaded) {
        return;
    }
    
    NSString *queue = [NSString stringWithFormat:@"%@:%@", @"loadImage",self.vocabulary.word];
    const char *queuechar = [queue UTF8String];
    dispatch_queue_t loadImageQ = dispatch_queue_create(queuechar, NULL);
    
    dispatch_async(loadImageQ, ^{
        
        NSString *googleServiceUrl = [NSString stringWithFormat:@"http://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=%@", self.vocabulary.word];
        
        NSLog(@"GoogleService URL: %@", googleServiceUrl);
        
        NSData *responseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:googleServiceUrl]];
        
        if (responseData == nil) {
            return;
        }
        
        NSError *error;
        NSDictionary *json = [NSJSONSerialization
                              JSONObjectWithData:responseData
                              options:kNilOptions
                              error:&error];
        
        NSArray *jsonArray = [[json objectForKey:@"responseData"] objectForKey:@"results"];;
        NSDictionary *dict = [jsonArray lastObject];
        NSString *imageUrl = [dict objectForKey:@"tbUrl"];
        responseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        
        NSLog(@"Image URL: %@", googleServiceUrl);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = [UIImage imageWithData:responseData];
            self.isImageLoaded = true;
        });
        
    });
}

@end
