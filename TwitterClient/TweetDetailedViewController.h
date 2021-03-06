//
//  TweetDetailedViewController.h
//  TwitterClient
//
//  Created by Vikas Kumar Bajaj on 10/4/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface TweetDetailedViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

-(id) initWithTweet: (Tweet*) tweet;

@end
