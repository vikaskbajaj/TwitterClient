//
//  ComposeTweet.h
//  TwitterClient
//
//  Created by Vikas Kumar Bajaj on 10/3/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@protocol ComposeTweetDelegate <NSObject>

- (void)userDidTweet:(Tweet*) tweet;

@end

@interface ComposeTweet : UIViewController <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *screenname;
@property (weak, nonatomic) IBOutlet UITextView *tweetText;
@property (weak, nonatomic) IBOutlet UILabel *characterCountLabel;
@property (weak, nonatomic) id<ComposeTweetDelegate> delegate;

-(id) initWithTweetToReply: (Tweet *) tweet;

@end
