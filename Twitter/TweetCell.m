//
//  TweetCell.m
//  Twitter
//
//  Created by Helen Kuo on 2/21/15.
//  Copyright (c) 2015 Helen Kuo. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"
#import "ComposeViewController.h"

@interface TweetCell ()


@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UITextView *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCount;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCount;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageTopConstraint;
@property (weak, nonatomic) IBOutlet UILabel *retweetedLabel;
@property (weak, nonatomic) IBOutlet UIView *retweetedView;


@end

@implementation TweetCell

- (IBAction)onFavorite:(id)sender {
    self.tweet.isFavorited = !self.tweet.isFavorited;
    self.tweet.favoriteCount += self.tweet.isFavorited ? 1 : -1;
    [self setFavoriteDetails];
    [[TwitterClient sharedInstance] toggleFavoriteTweetWithId:self.tweet.tweetId on:self.tweet.isFavorited];
}
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
- (IBAction)onReply:(id)sender {
    [self.delegate didTapReply:self];
}

- (void)setFavoriteDetails {
    [self.favoriteButton setImage:[UIImage imageNamed:self.tweet.isFavorited ? @"favorite_on" : @"favorite"] forState:UIControlStateNormal];
    self.favoriteCount.textColor = self.tweet.isFavorited ? [UIColor colorWithRed:1 green:0.675 blue:0.2 alpha:1] : [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    self.favoriteCount.text = self.tweet.favoriteCount > 0 ? [NSNumberFormatter localizedStringFromNumber:@(self.tweet.favoriteCount) numberStyle:NSNumberFormatterDecimalStyle] : @"";
}

- (void)setRetweetDetails {
    [self.retweetButton setImage:[UIImage imageNamed:self.tweet.isRetweeted ? @"retweet_on" : @"retweet"] forState:UIControlStateNormal];
    self.retweetCount.textColor = self.tweet.isRetweeted ? [UIColor colorWithRed:0.467 green:0.698 blue:0.333 alpha:1] : [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    self.retweetCount.text = self.tweet.retweetCount > 0 ? [NSNumberFormatter localizedStringFromNumber:@(self.tweet.retweetCount) numberStyle:NSNumberFormatterDecimalStyle] : @"";
}

- (void)awakeFromNib {
    // Initialization code
    self.avatarView.layer.cornerRadius = 3;
    self.avatarView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
    if (tweet.retweetedStatus != nil) {
        self.retweetedView.hidden = NO;
        self.imageTopConstraint.constant = 32;
        self.retweetedLabel.text = [NSString stringWithFormat:@"%@ retweeted", tweet.user.name];
        tweet = tweet.retweetedStatus;
    } else {
        self.retweetedView.hidden = YES;
        self.imageTopConstraint.constant = 8;
    }
    
    self.avatarView.image = nil;
    [self.avatarView setImageWithURL:[NSURL URLWithString:tweet.user.profileImageUrl]];
    self.authorLabel.text = tweet.user.name;
    self.userLabel.text = [NSString stringWithFormat:@"@%@", tweet.user.screenname];
    self.timeLabel.text = [self relativeTimeStamp:tweet.createdAt];
    self.tweetLabel.attributedText = tweet.attributedText;
    self.tweetLabel.userInteractionEnabled = YES;


    [self.tweetLabel sizeToFit];
    [self setFavoriteDetails];
    [self setRetweetDetails];

}



- (NSString *)relativeTimeStamp:(NSDate *)date {
    NSString *timestamp = @"";
    int minutesSince = (int)[date timeIntervalSinceNow]*-1/60;
    if (minutesSince < 60) {
        timestamp = [NSString stringWithFormat:@"%dm", minutesSince];
    } else if (minutesSince < 60*24) {
        timestamp = [NSString stringWithFormat:@"%dh", minutesSince/60];
    } else if (minutesSince < 60*24*7) {
        timestamp = [NSString stringWithFormat:@"%dd", minutesSince/60/24];
    } else {
        timestamp = [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
    }
    return timestamp;
}


@end
