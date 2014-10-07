//
//  TwitterClient.h
//  TwitterClient
//
//  Created by Vikas Kumar Bajaj on 9/29/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *) sharedInstance;

- (void) loginWithCompletion:(void (^)(User *user, NSError *error))completion;

- (void) openURL: (NSURL *) url;

- (void) fetchHomeTimelineWithCompletion: (void (^)(NSArray *tweets, NSError *error))completion;

- (void) statusUpdate: (NSString *) status inReplyTo: (NSNumber *) in_reply_to_status_id;

- (void) setFavorite: (NSNumber *) tweetId;

- (void) removeFavorite: (NSNumber *) tweetId;

@end
