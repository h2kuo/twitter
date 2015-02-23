//
//  Tweet.m
//  Twitter
//
//  Created by Helen Kuo on 2/20/15.
//  Copyright (c) 2015 Helen Kuo. All rights reserved.
//

#import "Tweet.h"
#import <UIKit/UIKit.h>

@implementation Tweet
- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];
        self.text = dictionary[@"text"];
        NSString *createdAtString = dictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        self.createdAt = [formatter dateFromString:createdAtString];
        self.favoriteCount = [dictionary[@"favorite_count"] integerValue];
        self.retweetCount = [dictionary[@"retweet_count"] integerValue];
        self.tweetId = [dictionary[@"id"] integerValue];
        self.isFavorited = [dictionary[@"favorited"] boolValue];
        self.isRetweeted = [dictionary[@"retweeted"] boolValue];
        self.retweetId = -1;
        if (dictionary[@"retweeted_status"] != nil) {
            self.retweetedStatus = [[Tweet alloc] initWithDictionary:dictionary[@"retweeted_status"]];
        }
        self.urls = [NSArray arrayWithArray:dictionary[@"entities"][@"urls"]];
        self.media = [NSArray arrayWithArray:dictionary[@"entities"][@"media"]];
        self.attributedText = [self replaceUrls];
    }
    return self;
}

-(NSMutableAttributedString *)replaceUrls {
    NSString *text = [self.text copy];
    for (NSDictionary *url in self.urls) {
        text = [text stringByReplacingOccurrencesOfString:url[@"url"] withString:url[@"display_url"]];
    }
    for (NSDictionary *media in self.media) {
        text = [text stringByReplacingOccurrencesOfString:media[@"url"] withString:media[@"display_url"]];
    }
    NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:text];
    [attrText beginEditing];
    for (NSDictionary *url in self.urls) {
        NSRange range =[text rangeOfString:url[@"display_url"]];
        //[attrText addAttribute:NSLinkAttributeName value:url[@"expanded_url"] range:range];
        [attrText addAttribute:NSForegroundColorAttributeName
                       value:[UIColor colorWithRed:0.333 green:0.675 blue:0.933 alpha:1]
                       range:range];

    }
    for (NSDictionary *media in self.media) {
        NSRange range =[text rangeOfString:media[@"display_url"]];
        //[attrText addAttribute:NSLinkAttributeName value:media[@"expanded_url"] range:range];
        [attrText addAttribute:NSForegroundColorAttributeName
                         value:[UIColor colorWithRed:0.333 green:0.675 blue:0.933 alpha:1]
                         range:range];
    }
    [attrText endEditing];
    return attrText;
}

+ (NSMutableArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [NSMutableArray array];
    for (NSDictionary *dictionary in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:dictionary]];
    }
    return tweets;
}

@end
