//
//  TweetExpandedView.m
//  TwitterClient
//
//  Created by Vikas Kumar Bajaj on 10/4/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "TweetExpandedView.h"
#import "Tweet.h"
#import "UIImageView+AFNetworking.h"


NSString * const kTweetExpandedView = @"TweetExpandedView";

@implementation TweetExpandedView

- (void)awakeFromNib {
    // Initialization code
}

- (void) setData:(Tweet *)tweet {
    [self.profileImage setImageWithURL:[tweet.user profileImageUrl]];
    self.username.text = [tweet.user name];
    self.userid.text = [NSString stringWithFormat:@"@%@",[[tweet user] screenName]];
    self.tweet.text = tweet.text;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy HH:mm"];
    self.tweetDate.text = [dateFormat stringFromDate:tweet.createdAt];
    self.favCount.text = [tweet.favouritesCount stringValue];
    self.tweetCount.text = [tweet.retweetCount stringValue];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
