//
//  TweetCell.h
//  Twitter
//
//  Created by Helen Kuo on 2/21/15.
//  Copyright (c) 2015 Helen Kuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@class TweetCell;

@protocol TweetCellDelegate <NSObject>

- (void)didTapReply:(TweetCell *)cell;

@end

@interface TweetCell : UITableViewCell

@property (nonatomic, strong) Tweet *tweet;
@property (nonatomic, weak) id<TweetCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;

@end
