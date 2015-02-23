//
//  Tweet.h
//  Twitter
//
//  Created by Helen Kuo on 2/20/15.
//  Copyright (c) 2015 Helen Kuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) User *user;
@property (nonatomic, assign) NSInteger retweetCount;
@property (nonatomic, assign) NSInteger favoriteCount;
@property (nonatomic, assign) NSInteger tweetId;
@property (nonatomic, assign) BOOL isFavorited;
@property (nonatomic, assign) BOOL isRetweeted;
@property (nonatomic, assign) NSInteger retweetId;
@property (nonatomic) Tweet *retweetedStatus;
@property (nonatomic) NSArray *urls;
@property (nonatomic) NSArray *media;
@property (nonatomic) NSMutableAttributedString *attributedText;

- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (NSMutableArray *)tweetsWithArray:(NSArray *)array;

@end
