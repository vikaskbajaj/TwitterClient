//
//  TweetDetailedViewController.m
//  TwitterClient
//
//  Created by Vikas Kumar Bajaj on 10/4/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "TweetDetailedViewController.h"
#import "Colours.h"
#import "TweetExpandedView.h"
#import "TweetsViewController.h"
#import "Tweet.h"
#import "ComposeTweet.h"
#import "AppConstants.h"

@interface TweetDetailedViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) Tweet *tweet;

@end

@implementation TweetDetailedViewController

-(id) initWithTweet: (Tweet *) tweet {
    self = [super init];
    
    if (self) {
        self.tweet = tweet;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    self.title = @"Tweet";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 266;
    [self.tableView registerNib:[UINib nibWithNibName:kTweetExpandedView bundle:nil] forCellReuseIdentifier:kTweetExpandedView];
}

-(void) setupNavigationBar {
    
    self.navigationController.navigationBar.tintColor =[UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorFromHexString:kTwitterColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(onHome:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reply" style:UIBarButtonItemStylePlain target:self action:@selector(onReply:)];

    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
}

- (void) onHome: (id) sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) onReply: (id) sender {
    ComposeTweet *composeView = [[ComposeTweet alloc] initWithTweetToReply:self.tweet];
    UINavigationController *composeNC = [[UINavigationController alloc] initWithRootViewController:composeView];
    [self presentViewController:composeNC animated:YES completion:nil];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    TweetExpandedView *cell = [self.tableView dequeueReusableCellWithIdentifier:kTweetExpandedView];
    
    [cell setData:self.tweet];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
