//
//  FlashCardTableViewController.m
//  EFHack2013
//
//  Created by Vincent on 13-4-18.
//  Copyright (c) 2013年 zhangkai. All rights reserved.
//

#import "FlashCardTableViewController.h"


@interface FlashCardTableViewController ()

@end

@implementation FlashCardTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView {
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self testCreateVocabulary];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.contentVocabulary allKeys] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Flash Card Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    NSUInteger *index = indexPath.row;
    
    cell.textLabel.text = [[self.contentVocabulary allValues] objectAtIndex:index];
    
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

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
    
}


@end
