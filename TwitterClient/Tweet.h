//
//  Tweet.h
//  TwitterClient
//
//  Created by Vikas Kumar Bajaj on 9/30/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) User *user;
@property NSNumber *tweetID;
@property BOOL hasRetweeted;
@property BOOL isFav;

@property (nonatomic, strong) NSNumber *retweetCount;
@property (nonatomic, strong) NSNumber *favouritesCount;

-(id) initWithDictionary: (NSDictionary *) dictionary;

+ (NSArray *) tweetsWithArray:(NSArray *) array;

@end
