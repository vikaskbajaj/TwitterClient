//
//  TweetCellTableViewCell.m
//  TwitterClient
//
//  Created by Vikas Kumar Bajaj on 10/1/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "TweetCellTableViewCell.h"
#import "Tweet.h"
#import "UIImageView+AFNetworking.h"
#import "NSDate+DateTools.h"
#import "TwitterClient.h"
#import "ComposeTweet.h"

NSString * const kTweetCell = @"TweetCellTableViewCell";

@interface TweetCellTableViewCell()

@property (nonatomic, weak) Tweet *tweet;

@end

@implementation TweetCellTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setDataFromATweet: (Tweet *) tweet {
    self.tweet = tweet;
    self.tweetText.text = [self.tweet text];
    self.username.text = [[self.tweet user] name];
    self.userid.text = [NSString stringWithFormat:@"@%@",[[self.tweet user] screenName]];
    [self.tweetImage setImageWithURL:[[self.tweet user] profileImageUrl]];
    self.timeLabel.text = [self.tweet createdAt].shortTimeAgoSinceNow;

    [self.replyButton setTitle:@"" forState:UIControlStateNormal];
    [self.retweetButton setTitle:@"" forState:UIControlStateNormal];
    [self.favButton setTitle:@"" forState:UIControlStateNormal];

    [self.replyButton setBackgroundImage:[UIImage imageNamed:@"reply.png"] forState:UIControlStateNormal];
    
    [self refreshView:self.tweet];
    
}
- (IBAction)onClickReplyButton:(id)sender {
    [self.delegate tweetCell:self replyButtonClicked:self.tweet];
}

- (IBAction)onClickFavButton:(id)sender {
    if (self.tweet.isFav) {
        [[TwitterClient sharedInstance] removeFavorite:self.tweet.tweetID];
    } else {
        [[TwitterClient sharedInstance] setFavorite:self.tweet.tweetID];
    }
    self.tweet.isFav = !self.tweet.isFav;
    [self refreshView:self.tweet];
}

- (void)refreshView:(Tweet *)tweet {
    
    if (tweet.hasRetweeted) {
        [self.retweetButton setBackgroundImage:[UIImage imageNamed:@"retweet_on.png"] forState:UIControlStateNormal];
    } else {
        [self.retweetButton setBackgroundImage:[UIImage imageNamed:@"retweet.png"] forState:UIControlStateNormal];
    }

    if (tweet.isFav) {
        [self.favButton setBackgroundImage:[UIImage imageNamed:@"favorite_on.png"] forState:UIControlStateNormal];
    } else {
        [self.favButton setBackgroundImage:[UIImage imageNamed:@"favorite.png"] forState:UIControlStateNormal];
    }
}

@end
