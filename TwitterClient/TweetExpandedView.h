//
//  TweetExpandedView.h
//  TwitterClient
//
//  Created by Vikas Kumar Bajaj on 10/4/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

extern NSString * const kTweetExpandedView;

@interface TweetExpandedView : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *userid;
@property (weak, nonatomic) IBOutlet UILabel *tweet;
@property (weak, nonatomic) IBOutlet UILabel *tweetDate;
@property (weak, nonatomic) IBOutlet UILabel *favCount;
@property (weak, nonatomic) IBOutlet UILabel *tweetCount;

- (void) setData: (Tweet *) tweet;

@end
