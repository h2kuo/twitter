//
//  TweetDetailControllerViewController.m
//  Twitter
//
//  Created by Helen Kuo on 2/21/15.
//  Copyright (c) 2015 Helen Kuo. All rights reserved.
//

#import "TweetDetailController.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"
#import "ComposeViewController.h"
#import "ProfileViewController.h"

@interface TweetDetailController ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCount;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCount;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteLabel;
@property (weak, nonatomic) IBOutlet UIView *retweetedView;
@property (weak, nonatomic) IBOutlet UILabel *retweetedLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageTopConstraint;

@end

@implementation TweetDetailController
- (IBAction)onRetweet:(id)sender {
    self.tweet.isRetweeted = !self.tweet.isRetweeted;
    self.tweet.retweetCount += self.tweet.isRetweeted ? 1 : -1;
    [self setRetweetDetails];
    if (self.tweet.isRetweeted) {
        [[TwitterClient sharedInstance] retweet:self.tweet];
    } else {
        [[TwitterClient sharedInstance] undoRetweet:self.tweet];
    }
}
- (IBAction)onFavorite:(id)sender {
    self.tweet.isFavorited = !self.tweet.isFavorited;
    self.tweet.favoriteCount += self.tweet.isFavorited ? 1 : -1;
    [self setFavoriteDetails];
    [[TwitterClient sharedInstance] toggleFavoriteTweetWithId:self.tweet.tweetId on:self.tweet.isFavorited];
}
- (IBAction)onReply:(id)sender {
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[[ComposeViewController alloc] initWithTweetToReplyTo:self.tweet]] animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Tweet";
    [self setTweetDetails];
    self.avatarView.layer.cornerRadius = 3;
    self.avatarView.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onProfileTap:(id)sender {
    User *user = self.tweet.retweetedStatus == nil ? self.tweet.user : self.tweet.retweetedStatus.user;
    [self.navigationController pushViewController:[[ProfileViewController alloc] initWithUser:user] animated:YES];
}

-(void)setTweetDetails {
    Tweet *tweet = self.tweet;
    if (self.tweet.retweetedStatus != nil) {
        self.retweetedView.hidden = NO;
        self.imageTopConstraint.constant = 39;
        self.retweetedLabel.text = [NSString stringWithFormat:@"%@ retweeted", self.tweet.user.name];
        tweet = self.tweet.retweetedStatus;
    } else {
        self.retweetedView.hidden = YES;
        self.imageTopConstraint.constant = 15;
    }
    
    self.avatarView.image = nil;
    NSString *biggerUrl = [tweet.user.profileImageUrl stringByReplacingOccurrencesOfString:@".png" withString:@"_bigger.png"];
    [self.avatarView setImageWithURL:[NSURL URLWithString:biggerUrl]];
    self.authorLabel.text = tweet.user.name;
    self.userLabel.text = [NSString stringWithFormat:@"@%@", tweet.user.screenname];
    self.tweetLabel.attributedText = tweet.attributedText;
    self.timeLabel.text = [NSDateFormatter localizedStringFromDate:tweet.createdAt dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    
    [self setFavoriteDetails];
    [self setRetweetDetails];
    
}

- (void)setFavoriteDetails {
    Tweet *tweet = self.tweet.retweetedStatus != nil ? self.tweet.retweetedStatus : self.tweet;
    [self.favoriteButton setImage:[UIImage imageNamed:tweet.isFavorited ? @"favorite_on" : @"favorite"] forState:UIControlStateNormal];
    self.favoriteCount.text = tweet.favoriteCount > 0 ? [NSNumberFormatter localizedStringFromNumber:@(self.tweet.favoriteCount) numberStyle:NSNumberFormatterDecimalStyle] : @"";
    if (tweet.favoriteCount > 0) {
        self.favoriteLabel.text = tweet.favoriteCount == 1 ? @"FAVORITE" : @"FAVORITES";
        self.favoriteCount.text = [NSNumberFormatter localizedStringFromNumber:@(tweet.favoriteCount) numberStyle:NSNumberFormatterDecimalStyle];
    } else {
        self.favoriteLabel.text = @"";
        self.favoriteCount.text = @"";
    }
}

- (void)setRetweetDetails {
    Tweet *tweet = self.tweet.retweetedStatus != nil ? self.tweet.retweetedStatus : self.tweet;
    [self.retweetButton setImage:[UIImage imageNamed:tweet.isRetweeted ? @"retweet_on" : @"retweet"] forState:UIControlStateNormal];
    self.retweetCount.text = tweet.retweetCount > 0 ? [NSNumberFormatter localizedStringFromNumber:@(self.tweet.retweetCount) numberStyle:NSNumberFormatterDecimalStyle] : @"";
    if (tweet.retweetCount > 0) {
        self.retweetLabel.text = tweet.retweetCount == 1 ? @"RETWEET" : @"RETWEETS";
        self.retweetCount.text = [NSNumberFormatter localizedStringFromNumber:@(tweet.retweetCount) numberStyle:NSNumberFormatterDecimalStyle];
    } else {
        self.retweetCount.text = @"";
        self.retweetLabel.text = @"";
    }
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
