//
//  Tweet.m
//  TwitterClient
//
//  Created by Vikas Kumar Bajaj on 9/30/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

-(id) initWithDictionary: (NSDictionary *) dictionary {
    
    self = [self init];
    
    if (self) {
        self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];
        self.text = dictionary[@"text"];
        NSString *createdAtString = dictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEE MM d HH:mm:ss Z y";
        self.createdAt = [formatter dateFromString:createdAtString];
        self.isFav = [dictionary[@"favorited"] boolValue];
        self.hasRetweeted = [dictionary[@"retweeted"] boolValue];
        self.tweetID = (NSNumber *)dictionary[@"id"];
        
        self.retweetCount = (NSNumber *)dictionary[@"retweet_count"];
        
        self.favouritesCount = (NSNumber *)dictionary[@"favorite_count"];
    }
    
    return self;
}

+ (NSArray *) tweetsWithArray:(NSArray *) array {
    NSMutableArray *tweets = [NSMutableArray array];
    
    for (NSDictionary *dicttionary in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:dicttionary]];
    }
    return tweets;
}

@end
