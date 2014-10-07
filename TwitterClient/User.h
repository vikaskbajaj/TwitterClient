//
//  User.h
//  TwitterClient
//
//  Created by Vikas Kumar Bajaj on 9/30/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSURL *profileImageUrl;
@property (nonatomic, strong) NSString *tagline;

- (id) initWithDictionary: (NSDictionary *) dictionary;

+ (User *)currentUser;

+ (void)setCurrentUser: (User *) currentUser;

+(void) logout;

@end
