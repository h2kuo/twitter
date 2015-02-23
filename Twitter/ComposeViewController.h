//
//  ComposeViewController.h
//  Twitter
//
//  Created by Helen Kuo on 2/22/15.
//  Copyright (c) 2015 Helen Kuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Tweet.h"

@class ComposeViewController;

@protocol ComposeViewControllerDelegate <NSObject>

-(void)composeViewController:(ComposeViewController *)composeViewController didPostStatus:(Tweet *)tweet;

@end

@interface ComposeViewController : UIViewController

@property (nonatomic, strong) User *user;
@property (nonatomic, weak) id<ComposeViewControllerDelegate> delegate;

- (id)initWithTweetToReplyTo:(Tweet *)tweetToReplyTo;

@end
