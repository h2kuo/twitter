//
//  ProfileCell.m
//  Twitter
//
//  Created by Helen Kuo on 2/28/15.
//  Copyright (c) 2015 Helen Kuo. All rights reserved.
//

#import "ProfileCell.h"
#import "UIImageView+AFNetworking.h"
#import "UIColor+fromHex.h"

@interface ProfileCell ()
@property (weak, nonatomic) IBOutlet UIImageView *profileView;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *numTweetsLabel;
@property (weak, nonatomic) IBOutlet UILabel *numFollowingLabel;
@property (weak, nonatomic) IBOutlet UILabel *numFollowersLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptionLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLeftConstraint;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameRightConstraint;
@property (weak, nonatomic) IBOutlet UIView *descriptionView;
@end

@implementation ProfileCell

- (void)awakeFromNib {
    // Initialization code
    self.profileView.layer.cornerRadius = 5;
    self.profileView.clipsToBounds = YES;
    self.profileView.layer.borderWidth = 3;
    self.profileView.layer.masksToBounds = YES;
    self.profileView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.descriptionLabel.preferredMaxLayoutWidth = self.frame.size.width - 15 - 8;
}

-(void)setUser:(User *)user {
    _user = user;
    self.profileView.image = nil;
    [self.profileView setImageWithURL:[NSURL URLWithString:user.profileImageUrl]];
    self.authorLabel.text = user.name;
    self.userLabel.text = [NSString stringWithFormat:@"@%@", user.screenname];
    self.numTweetsLabel.text = [NSNumberFormatter localizedStringFromNumber:@(user.numTweets) numberStyle:NSNumberFormatterDecimalStyle];
    self.numFollowersLabel.text = [NSNumberFormatter localizedStringFromNumber:@(user.numFollowers) numberStyle:NSNumberFormatterDecimalStyle];
    self.numFollowingLabel.text = [NSNumberFormatter localizedStringFromNumber:@(user.numFollowing) numberStyle:NSNumberFormatterDecimalStyle];
    if (![user.userDescription isEqualToString:@""]) {
        self.descriptionLabel.text = user.userDescription;
        [self.descriptionLabel sizeToFit];
        self.pageControl.numberOfPages = 2;
    } else {
        self.pageControl.numberOfPages = 1;
    }
}
- (IBAction)onPageControlChanged:(UIPageControl *)sender {
    if (sender.currentPage == 1) {
        [UIView animateWithDuration:.5 animations:^{
            self.descriptionLeftConstraint.constant = -1*self.frame.size.width;
            self.nameLeftConstraint.constant = -1*self.frame.size.width;
            self.nameRightConstraint.constant = 1*self.frame.size.width;
            [self layoutIfNeeded];
            
        }];
    } else {
        [UIView animateWithDuration:.5 animations:^{
            self.descriptionLeftConstraint.constant = 0;
            self.nameLeftConstraint.constant = 0;
            self.nameRightConstraint.constant = 0;
            [self layoutIfNeeded];
        }];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.descriptionLabel.preferredMaxLayoutWidth = self.frame.size.width - 15 - 8;
}

@end
