//
//  ViewController.m
//  EFHack2013
//
//  Created by zhangkai on 4/18/13.
//  Copyright (c) 2013 zhangkai. All rights reserved.
//

#import "FlashCardRootViewController.h"
#import "FlashCardDataManager.h"
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"


#define labelHeight 50

@interface FlashCardRootViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *viewControllers;

@end

@implementation FlashCardRootViewController

- (id)init{
    if (self = [super init]) {
        self.unitIdString = @"385";
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveUnitId:) name:@"FlashCardView" object:nil];
    }
    return self;
}


-(void)receiveUnitId:(NSNotification *)noti
{
    NSLog(@"recieved event %@",noti);
    
    NSString *newUnitId = [noti object];
    
    if ([newUnitId isEqualToString:self.unitIdString]) {
        return;
    }
    
    self.unitIdString = newUnitId;
    
    [self prepareVocabularyData];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareVocabularyData];
}

- (void)prepareView {
    
    NSUInteger numberPages = [[self.contentVocabulary allKeys] count];
    
    // view controllers are created lazily
    // in the meantime, load the array with placeholders which will be replaced on demand
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < numberPages; i++)
    {
		[controllers addObject:[NSNull null]];
    }
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.viewControllers = controllers;
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.scrollView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.scrollView];
    
    
    // a page is the width of the scroll view
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize =
    CGSizeMake(CGRectGetWidth(self.scrollView.frame) * numberPages, CGRectGetHeight(self.scrollView.frame));
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    
    self.pageControl.numberOfPages = numberPages;
    self.pageControl.currentPage = 0;
    
    // pages are created on demand
    // load the visible page
    // load the page on either side to avoid flashes when the user starts scrolling
    //
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    
    // Dispose of any resources that can be recreated.
}

- (void)testCreateVocabulary
{
    // create test data
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"afternoon" forKey:@"Word"];
    [dict setObject:@"下午" forKey:@"Translation"];
    [dict setObject:@"http://www.englishtown.com/etownresources/dictionary_mp3/Headword/US/c/ca/cak/cake_us_1.mp3" forKey:@"AudioPath"];
    [dict setObject:@"noun" forKey:@"PartofSpeech"];
    [dict setObject:@"ˌɑːftəˈnuːn" forKey:@"PhoneticPronunciationUK"];
    [dict setObject:@"ˌɑːftəˈnuːn" forKey:@"PhoneticPronunciationUS"];
    
    NSMutableDictionary *dict2 = [[NSMutableDictionary alloc] init];
    [dict2 setObject:@"American" forKey:@"Word"];
    [dict2 setObject:@"美洲人;(尤指)美国人" forKey:@"Translation"];
    [dict2 setObject:@"http://www.englishtown.com/etownresources/dictionary_mp3/Headword/US/A/American.mp3" forKey:@"AudioPath"];
    [dict2 setObject:@"noun" forKey:@"PartofSpeech"];
    [dict2 setObject:@"əˈmerɪkən" forKey:@"PhoneticPronunciationUK"];
    [dict2 setObject:@"əˈmerɪkən" forKey:@"PhoneticPronunciationUS"];
    
    NSMutableArray *a = [[NSMutableArray alloc] init];
    [a addObject:dict];
    [a addObject:dict2];
    
    // Sample of using
    self.contentVocabulary = [VocabularyDict initWithObject:a];
    
    [self prepareView];
    
}


- (void)prepareVocabularyData {

    [[FlashCardDataManager sharedInstance] pullVocabularyDataOfUnitId:[self.unitIdString intValue] withCulture:@"zh-CN" withDoneBlock:^{
        self.contentVocabulary = [FlashCardDataManager sharedInstance].contentVocabulary;
        
        
        Vocabulary *v = [self.contentVocabulary.allValues lastObject];
        NSLog(@"Translation: %@", v.translation);
        
        [((AppDelegate*)[UIApplication sharedApplication].delegate).tabBarController setSelectedIndex:2];
        
        [self prepareView];
    }];
}

- (void)loadScrollViewWithPage:(NSUInteger)page
{
    if (page >=  [[self.contentVocabulary allKeys] count])
        return;
    
    // replace the placeholder if necessary
    FlashCardViewController *controller = [self.viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null])
    {
        controller = [[FlashCardViewController alloc] init];
        [self.viewControllers replaceObjectAtIndex:page withObject:controller];
    }
    
    // add the controller's view to the scroll view
    if (controller.view.superview == nil)
    {
        CGRect frame = self.scrollView.frame;
        frame.origin.x = CGRectGetWidth(frame) * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        controller.vocabulary = [[self.contentVocabulary allValues] objectAtIndex:page];
        [self addChildViewController:controller];
        [self.scrollView addSubview:controller.view];
        [controller didMoveToParentViewController:self];
        
    }
}

// at the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    NSUInteger page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    // a possible optimization would be to unload the views+controllers which are no longer visible
}

- (void)gotoPage:(BOOL)animated
{
    NSInteger page = self.pageControl.currentPage;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
	// update the scroll view to the appropriate page
    CGRect bounds = self.scrollView.bounds;
    bounds.origin.x = CGRectGetWidth(bounds) * page;
    bounds.origin.y = 0;
    [self.scrollView scrollRectToVisible:bounds animated:animated];
}

- (IBAction)changePage:(id)sender
{
    [self gotoPage:YES];    // YES = animate
}



@end
