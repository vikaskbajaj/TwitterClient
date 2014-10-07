//
//  User.m
//  TwitterClient
//
//  Created by Vikas Kumar Bajaj on 9/30/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "User.h"
#import "TwitterClient.h"
#import "AppConstants.h"

@interface User()

@property (nonatomic, strong) NSDictionary *dictionary;

@end

@implementation User

static User *_currentUser = nil;

NSString * const kCurrentUserKey = @"kCurrentUserKey";

-(id) initWithDictionary:(NSDictionary *)dictionary {
    
    self = [super init];
    
    if (self) {
        self.dictionary = dictionary;
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        self.profileImageUrl = [NSURL URLWithString:dictionary[@"profile_image_url"]];
        self.tagline = dictionary[@"description"];
    }
    
    return self;
}

+ (User *)currentUser {
    if (_currentUser == nil) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentUserKey];
        if (data != nil) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            _currentUser = [[User alloc] initWithDictionary:dictionary];
        }
    }
    return _currentUser;
}

+ (void) setCurrentUser: (User *) currentUser {
    _currentUser = currentUser;
    
    if (_currentUser != nil) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:currentUser.dictionary options:0 error:NULL];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kCurrentUserKey];
        
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kCurrentUserKey];
        
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void) logout {
    [User setCurrentUser:nil];
    [[TwitterClient sharedInstance].requestSerializer removeAccessToken];
    
    [[NSNotificationCenter defaultCenter] postNotificationName: kTwitterUserDidLogoutNotification object:nil];
}

@end
