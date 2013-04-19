//
//  ViewController.m
//  EFHack2013
//
//  Created by zhangkai on 4/18/13.
//  Copyright (c) 2013 zhangkai. All rights reserved.
//

#import "ViewController.h"
#import "EFDataManager.h"
#import "MediaData.h"
#import "EFDownloadManager.h"
#import "EFVideoViewController.h"
#import "AppDelegate.h"

@interface ViewController ()
{
    UITableView *theTableView;
    NSMutableDictionary *dictionary;
    NSString *activityId;
}
@end

@implementation ViewController

- (id)init{
    if (self = [super init]) {
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(recieveActivityId:) name:@"ACTIVITY_ID_Ready" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(recieveJson:) name:@"JSON_DATA_Ready" object:nil];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    theTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49) style:UITableViewStylePlain];
    theTableView.delegate = self;
    theTableView.dataSource = self;
    [self.view addSubview:theTableView];
    
    urlArray = [[NSMutableArray alloc] init];
    dataArray = [[NSMutableArray alloc] init];
    
    dictionary = [[NSMutableDictionary alloc]init];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

-(void)recieveActivityId:(NSNotification *)noti
{
    NSLog(@"recieved event %@",noti);
    activityId = [noti object];
    //dataArray = @[@"1",@"2"];
    //[theTableView reloadData];
    [self fetchUrl];
    [((AppDelegate*)[UIApplication sharedApplication].delegate).tabBarController setSelectedIndex:1];
}
-(void)recieveJson:(NSNotification *)noti
{
    MediaData *mediaData = [noti object];
    
    [urlArray addObjectsFromArray:mediaData.Medias];
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (int i = 0; i < [mediaData.Medias count]; i++) {
        
        NSString *string = [mediaData.Medias objectAtIndex:i];
        NSArray *stringArray = [string componentsSeparatedByString:@"/"];
        NSString *mediaName = [stringArray lastObject];
        
        NSArray *mediaNameArray = [mediaName componentsSeparatedByString:@"."];
        NSString *fileFormat = [mediaNameArray lastObject];
        if ([fileFormat isEqualToString:@"jpg"]) {
            continue;
        }
        
        [array addObject:mediaName];
        [dictionary setObject:@"NotDownloading" forKey:mediaName];
    }
    [dataArray removeAllObjects];
    [dataArray addObjectsFromArray:array];
    [theTableView reloadData];
}
-(void)fetchUrl
{
    NSString *urlStr = [NSString stringWithFormat:@"http://schooldragonuat.englishtown.com/hackthon/courseware/coursecontent/activityresource/%@",@"89774"];
    [[EFDataManager sharedDataManager]parseUrlResource:urlStr];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSString *string = [dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = string;
    
    UIImage *image = nil;
    NSString *theStr = [dictionary objectForKey:string];
    if ([theStr isEqualToString:@"Finished"]) {
        
        image = [UIImage imageNamed:@"Select.png"];
    }else if([theStr isEqualToString:@"Downloading"]){
        
        image = [UIImage imageNamed:@"Download.png"];
    }else if([theStr isEqualToString:@"NotDownloading"]){
        
        image = [UIImage imageNamed:@"Forward.png"];
    }
    cell.imageView.image = image;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *string = [dataArray objectAtIndex:indexPath.row];
    UITableViewCell *cell = [theTableView cellForRowAtIndexPath:indexPath];
    
//    NSArray *stringArray = [cell.textLabel.text componentsSeparatedByString:@":"];
//    if ([stringArray count] == 2) {
//        NSString *statusStr = [stringArray objectAtIndex:0];
//        if ([statusStr isEqualToString:@"Finished..."]) {
//            NSLog(@"go to play");
//            EFVideoViewController *videoPlayer = [[EFVideoViewController alloc]init];
//            videoPlayer.mediaName = [stringArray objectAtIndex:1];
//            [self presentViewController:videoPlayer animated:YES completion:nil];
//            return;
//        }
//    }
    NSString *statusStr = [dictionary objectForKey:cell.textLabel.text];
    if ([statusStr isEqualToString:@"Finished"]) {
        
        EFVideoViewController *videoPlayer = [[EFVideoViewController alloc]init];
        videoPlayer.mediaName = cell.textLabel.text;
        [self presentViewController:videoPlayer animated:YES completion:nil];
        return;
    }
    
//    cell.textLabel.text = [NSString stringWithFormat:@"Downloading... : %@",string];
    [dictionary setObject:@"Downloading" forKey:cell.textLabel.text];
    cell.imageView.image = [UIImage imageNamed:@"Download.png"];
    
    NSString *urlString = [urlArray objectAtIndex:indexPath.row];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *mediapath = [NSString stringWithFormat:@"%@/%@",documentsDirectory,string];
    
//    __block NSMutableArray *blockDataArray = dataArray;
    __block NSMutableArray *blockUrlArray = urlArray;
    __block UITableView *blockTableView = theTableView;
    __block NSMutableDictionary *blockDictionary = dictionary;
    [[EFDownloadManager sharedEFDownloadManager]enQueueUrl:urlString unzipToPath:mediapath atPriority:0 callback:^(NSString *urlS){
      
        int finishedIndex;
        NSLog(@"---%@---\n",urlS);
        for (int i = 0; i < [blockUrlArray count]; i++) {
            if ([[blockUrlArray objectAtIndex:i] isEqualToString:urlS]) {
                finishedIndex = i;
                break;
            }
        }
        NSIndexPath *indexP = [NSIndexPath indexPathForRow:finishedIndex inSection:0];
        UITableViewCell *cell = [blockTableView cellForRowAtIndexPath:indexP];
        
//         NSString *string = [blockDataArray objectAtIndex:finishedIndex];
//        cell.textLabel.text = [NSString stringWithFormat:@"Finished...:%@",string];
        [blockDictionary setObject:@"Finished" forKey:cell.textLabel.text];
        cell.imageView.image = [UIImage imageNamed:@"Select.png"];
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
