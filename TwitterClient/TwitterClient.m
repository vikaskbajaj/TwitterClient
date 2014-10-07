//
//  TwitterClient.m
//  TwitterClient
//
//  Created by Vikas Kumar Bajaj on 9/29/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "TwitterClient.h"
#import "User.h"
#import "Tweet.h"
#import "AppConstants.h"

NSString * const TwitterConsumerKey = @"a34h9cK4fLfDWasaPOkGf0YzS";
NSString * const TwitterConsumerSecret = @"2UgkGkewxqOkgfatkpAyNJExhmBdX1kRH3mQhJVr81jwz6PnwK";
NSString * const TwitterBaseUrl = @"https://api.twitter.com";

@interface TwitterClient()

@property (nonatomic, strong) void (^loginCompletion)(User *user, NSError *error);

@end

@implementation TwitterClient

+ (TwitterClient *) sharedInstance {
    static TwitterClient *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:TwitterBaseUrl] consumerKey:TwitterConsumerKey consumerSecret:TwitterConsumerSecret];
        }
    });
    return instance;
}

- (void) loginWithCompletion:(void (^)(User *user, NSError *error))completion {
    
    self.loginCompletion = completion;
    
    [self.requestSerializer removeAccessToken];
    
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"twitterClient://oauth"] scope:nil success:^(BDBOAuthToken *requestToken) {
        NSURL *authorizeURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
        
        [[UIApplication sharedApplication] openURL:authorizeURL];
        
    } failure:^(NSError *error) {
        NSLog(@"Got error");
        self.loginCompletion(nil, error);
    }];
    
}

-(void) statusUpdate: (NSString *) status inReplyTo: (NSNumber *) in_reply_to_status_id {
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    data[@"status"] = status;
    if (in_reply_to_status_id != nil) {
        data[@"in_reply_to_status_id"] = in_reply_to_status_id;
    }
    
    [self POST:@"1.1/statuses/update.json" parameters:data success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName: kStatusUpdateSuccessful object:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName: kStatusUpdateError object:nil];
        
    }];
}

-(void) setFavorite:(NSNumber *)tweetId {
    NSDictionary *parameters = @{@"id": tweetId};
    
    [self POST:@"1.1/favorites/create.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName: kFavSetSuccessful object:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error while set tweet id %@ as fav. Reason: %@", tweetId, error);

        [[NSNotificationCenter defaultCenter] postNotificationName: kFavSetError object:nil];
        
    }];
}

-(void) removeFavorite:(NSNumber *)tweetId {
    
    NSDictionary *parameters = @{@"id": tweetId};
    
    [self POST:@"1.1/favorites/destroy.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName: kFavSetSuccessful object:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error while removing fav from tweet id %@. Reason: %@", tweetId, error);
        
        [[NSNotificationCenter defaultCenter] postNotificationName: kFavSetError object:nil];
        
    }];
    
}


-(void) fetchHomeTimelineWithCompletion: (void (^)(NSArray *tweets, NSError *error))completion {

    [self GET:@"1.1/statuses/home_timeline.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        completion([Tweet tweetsWithArray:responseObject], nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error receiving home time data. Reason: %@", error);
        
        completion(nil, error);
        
    }];
}

-(void) openURL:(NSURL *)url {
    
    [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuthToken tokenWithQueryString: url.query] success:^(BDBOAuthToken *accessToken) {
        
        [self.requestSerializer saveAccessToken:accessToken];
        
        [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            User *user = [[User alloc] initWithDictionary:responseObject];
            [User setCurrentUser:user];
            self.loginCompletion(user, nil);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            self.loginCompletion(nil, error);
            
        }];
        
    } failure:^(NSError *error) {
        
        NSLog(@"Failed to get the access token");
        
    }];

}

@end
