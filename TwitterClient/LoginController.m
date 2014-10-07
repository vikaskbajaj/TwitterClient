//
//  LoginController.m
//  TwitterClient
//
//  Created by Vikas Kumar Bajaj on 10/4/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "LoginController.h"
#import "TwitterClient.h"
#import "TweetsViewController.h"
#import "Colours.h"
#import "AppConstants.h"

@interface LoginController ()

@end

@implementation LoginController

- (IBAction)onLogin:(id)sender {
    [[TwitterClient sharedInstance] loginWithCompletion:^(User *user, NSError *error) {
        if (user != nil) {
            TweetsViewController *tvc = [[TweetsViewController alloc] init];
            UINavigationController *unc = [[UINavigationController alloc] initWithRootViewController:tvc];
            [self presentViewController:unc animated:YES completion:nil];
        } else {
            //present error view
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorFromHexString:kTwitterColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorFromHexString:kTwitterColor];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
