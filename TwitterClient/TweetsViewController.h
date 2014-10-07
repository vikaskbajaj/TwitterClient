//
//  TweetsViewController.h
//  TwitterClient
//
//  Created by Vikas Kumar Bajaj on 10/1/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetCellTableViewCell.h"
#import "ComposeTweet.h"

@interface TweetsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, TweetCellDelegate, ComposeTweetDelegate>

@end
