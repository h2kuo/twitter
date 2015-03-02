//
//  LoginViewController.m
//  Twitter
//
//  Created by Helen Kuo on 2/19/15.
//  Copyright (c) 2015 Helen Kuo. All rights reserved.
//

#import "LoginViewController.h"
#import "TwitterClient.h"
#import "TweetsViewController.h"
#import "MainViewController.h"
#import "MenuViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
- (IBAction)onLogin:(id)sender {
    
    [[TwitterClient sharedInstance] loginWithCompletion:^(User *user, NSError *error) {
        if (user != nil) {
            NSLog(@"Welcome to %@", user.name);
            [self presentViewController:[[MainViewController alloc] initWithMenuController:[[MenuViewController alloc] init] contentController:[[UINavigationController alloc] initWithRootViewController:[[TweetsViewController alloc] initWithHome:YES]]] animated:YES completion:nil];
        } else {
            
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
