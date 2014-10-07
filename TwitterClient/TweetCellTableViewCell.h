//
//  TweetCellTableViewCell.h
//  TwitterClient
//
//  Created by Vikas Kumar Bajaj on 10/1/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

extern NSString * const kTweetCell;

@class TweetCellTableViewCell;

@protocol TweetCellDelegate <NSObject>

-(void) tweetCell: (TweetCellTableViewCell *) tweetCell replyButtonClicked: (Tweet *) tweet;

@end

@interface TweetCellTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *tweetImage;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *userid;

@property (weak, nonatomic) IBOutlet UILabel *tweetText;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favButton;

@property (weak, nonatomic) id<TweetCellDelegate> delegate;


-(void) setDataFromATweet: (Tweet *) tweet;

- (void)refreshView:(Tweet *)tweet;

@end
