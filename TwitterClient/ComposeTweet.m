//
//  ComposeTweet.m
//  TwitterClient
//
//  Created by Vikas Kumar Bajaj on 10/3/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "ComposeTweet.h"
#import "UIImageView+AFNetworking.h"
#import "User.h"
#import "Colours.h"
#import "TwitterClient.h"
#import "Tweet.h"
#import "AppConstants.h"

@interface ComposeTweet ()

@property (nonatomic, weak) Tweet *inReplyingToTweet;

@end

@implementation ComposeTweet

static NSString *defaultText = @"What's on your mind";

-(id) initWithTweetToReply:(Tweet *)tweet {
    self = [super init];
    if (self) {
        self.inReplyingToTweet = tweet;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tweetText.delegate = self;
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *) titleForRightBar {
    if (self.inReplyingToTweet) {
        return @"Send";
    } else {
        return @"Tweet";
    }
}

-(void) setupNavigationBar {
    
    self.navigationController.navigationBar.tintColor =[UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorFromHexString:kTwitterColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancel:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: [self titleForRightBar] style:UIBarButtonItemStylePlain target:self action:@selector(onTweet:)];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
}

-(NSString *) windowTitle {
    if (self.inReplyingToTweet) {
        return @"Reply";
    } else {
        return @"Compose";
    }
}

-(void) textViewDidChange:(UITextView *)textView {
    int charCount = (int)self.tweetText.text.length;
    self.characterCountLabel.text = [NSString stringWithFormat:@"%i", 140-charCount];
}

-(void) setupUI {
    [self setupNavigationBar];
    self.title = self.windowTitle;
    [self.profileImage setImageWithURL:[[User currentUser] profileImageUrl]];
    self.screenname.text = [NSString stringWithFormat:@"@%@",[[User currentUser] screenName]];
    self.name.text = [[User currentUser] name];
    
    self.tweetText.textColor = [UIColor colorFromHexString:@"8899a6"];
    if (self.inReplyingToTweet) {
        self.tweetText.text = [NSString stringWithFormat:@"@%@ ", [self.inReplyingToTweet.user screenName]];
    } else {
        self.tweetText.text =  defaultText;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text length] == 0) {
        if([self.tweetText.text length] != 0) {
            return YES;
        }
    }
    else if([[self.tweetText text] length] > 139) {
        NSLog(@"Maximum limit for tweet reached");
        return NO;
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.tweetText.text isEqualToString:defaultText]) {
        self.tweetText.text = @"";
    }
    [self.tweetText becomeFirstResponder];
}

- (void) onCancel: (id) sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) onTweet: (id) sender {
    Tweet *newTweet = [[Tweet alloc] init];
    newTweet.user = [User currentUser];
    newTweet.createdAt = [NSDate date];
    newTweet.text = self.tweetText.text;
    newTweet.retweetCount = 0;
    newTweet.favouritesCount = 0;
    newTweet.isFav = NO;
    newTweet.hasRetweeted = NO;
    [[TwitterClient sharedInstance] statusUpdate:self.tweetText.text inReplyTo:[self.inReplyingToTweet tweetID]];
    [self.delegate userDidTweet:newTweet];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
