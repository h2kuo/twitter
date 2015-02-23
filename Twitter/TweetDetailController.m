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

-(void)setTweetDetails {
    self.avatarView.image = nil;
    NSString *biggerUrl = [self.tweet.user.profileImageUrl stringByReplacingOccurrencesOfString:@".png" withString:@"_bigger.png"];
    [self.avatarView setImageWithURL:[NSURL URLWithString:biggerUrl]];
    self.authorLabel.text = self.tweet.user.name;
    self.userLabel.text = [NSString stringWithFormat:@"@%@", self.tweet.user.screenname];
    self.tweetLabel.attributedText = self.tweet.attributedText;
    self.timeLabel.text = [NSDateFormatter localizedStringFromDate:self.tweet.createdAt dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    
    [self setFavoriteDetails];
    [self setRetweetDetails];
    
}

- (void)setFavoriteDetails {
    [self.favoriteButton setImage:[UIImage imageNamed:self.tweet.isFavorited ? @"favorite_on" : @"favorite"] forState:UIControlStateNormal];
    self.favoriteCount.text = self.tweet.favoriteCount > 0 ? [NSNumberFormatter localizedStringFromNumber:@(self.tweet.favoriteCount) numberStyle:NSNumberFormatterDecimalStyle] : @"";
    if (self.tweet.favoriteCount > 0) {
        self.favoriteLabel.text = self.tweet.favoriteCount == 1 ? @"FAVORITE" : @"FAVORITES";
        self.favoriteCount.text = [NSNumberFormatter localizedStringFromNumber:@(self.tweet.favoriteCount) numberStyle:NSNumberFormatterDecimalStyle];
    } else {
        self.favoriteLabel.text = @"";
        self.favoriteCount.text = @"";
    }
}

- (void)setRetweetDetails {
    [self.retweetButton setImage:[UIImage imageNamed:self.tweet.isRetweeted ? @"retweet_on" : @"retweet"] forState:UIControlStateNormal];
    self.retweetCount.text = self.tweet.retweetCount > 0 ? [NSNumberFormatter localizedStringFromNumber:@(self.tweet.retweetCount) numberStyle:NSNumberFormatterDecimalStyle] : @"";
    if (self.tweet.retweetCount > 0) {
        self.retweetLabel.text = self.tweet.retweetCount == 1 ? @"RETWEET" : @"RETWEETS";
        self.retweetCount.text = [NSNumberFormatter localizedStringFromNumber:@(self.tweet.retweetCount) numberStyle:NSNumberFormatterDecimalStyle];
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
