//
//  TweetsViewController.m
//  TwitterClient
//
//  Created by Vikas Kumar Bajaj on 10/1/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "TweetsViewController.h"
#import "TweetCellTableViewCell.h"
#import "Colours.h"
#import "User.h"
#import "TwitterClient.h"
#import "ComposeTweet.h"
#import "TweetDetailedViewController.h"
#import "AppConstants.h"
#import "TSMessage.h"
#import "SVProgressHUD.h"

@interface TweetsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tweets;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation TweetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Home";
    
    [SVProgressHUD showWithStatus:@"Loading Tweets" maskType:SVProgressHUDMaskTypeNone];
    
    [self setupNavigationBar];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:kTweetCell bundle:nil] forCellReuseIdentifier:kTweetCell];
    
    //Setup refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshTable:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    [self fetchData];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) userDidTweet:(Tweet *)tweet {
    [self.tweets insertObject:tweet atIndex:0];
    [self.tableView reloadData];
}

- (void) fetchData {
    [[TwitterClient sharedInstance] fetchHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (error == nil) {
            self.tweets = [tweets mutableCopy];
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
        } else {
            [SVProgressHUD dismiss];
            [TSMessage showNotificationInViewController:self
                                                  title:@"Error!"
                                               subtitle:@"Please retry after sometime."
                                                   type:TSMessageNotificationTypeError
                                               duration:TSMessageNotificationDurationAutomatic
                                   canBeDismissedByUser:YES];
        }
    }];
}

- (void)refreshTable:(id)sender {
    [SVProgressHUD showWithStatus:@"Loading Tweets" maskType:SVProgressHUDMaskTypeNone];
    [self fetchData];
    [(UIRefreshControl *)sender endRefreshing];
}

-(void) setupNavigationBar {
    
    self.navigationController.navigationBar.tintColor =[UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorFromHexString:kTwitterColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onSignOut:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(onNew:)];

    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
}

-(void) onSignOut: (id) sender {
    [User logout];
}

-(void) onNew: (id) sender {
    ComposeTweet *composeView = [[ComposeTweet alloc] initWithTweetToReply:nil];
    composeView.delegate = self;
    UINavigationController *composeNC = [[UINavigationController alloc] initWithRootViewController:composeView];
    [self presentViewController:composeNC animated:YES completion:nil];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tweets count];
}

-(TweetCellTableViewCell *) getCellForRowAtIndexPath: (NSIndexPath *) indexPath {
    TweetCellTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kTweetCell];
    if (!cell) {
        cell = [[TweetCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTweetCell];
    }
    
    cell.delegate = self;
    
    [cell setDataFromATweet:self.tweets[indexPath.row]];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self getCellForRowAtIndexPath:indexPath];
}

-(void) tweetCell:(TweetCellTableViewCell *)tweetCell replyButtonClicked:(Tweet *)tweet {
    ComposeTweet *composeView = [[ComposeTweet alloc] initWithTweetToReply:tweet];
    composeView.delegate = self;
    UINavigationController *composeNavController = [[UINavigationController alloc] initWithRootViewController:composeView];
    [self presentViewController:composeNavController animated:YES completion:nil];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    TweetDetailedViewController *dvc = [[TweetDetailedViewController alloc] initWithTweet:self.tweets[indexPath.row]];
    [self.navigationController pushViewController:dvc animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *) cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == [self.tweets count] - 1) {
        [self fetchData];
    }
}

@end
