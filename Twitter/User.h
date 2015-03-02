//
//  User.h
//  Twitter
//
//  Created by Helen Kuo on 2/20/15.
//  Copyright (c) 2015 Helen Kuo. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const UserDidLoginNotification;
extern NSString * const UserDidLogoutNotification;

@interface User : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenname;
@property (nonatomic, strong) NSString *profileImageUrl;
@property (nonatomic, strong) NSString *tagline;
@property (nonatomic, strong) NSMutableArray *tweets;
@property (nonatomic, strong) NSMutableArray *mentions;
@property (nonatomic, strong) NSString *profileBannerUrl;
@property (nonatomic, assign) NSInteger numTweets;
@property (nonatomic, assign) NSInteger numFollowers;
@property (nonatomic, assign) NSInteger numFollowing;
@property (nonatomic, strong) NSString *profileBackgroundColor;
@property (nonatomic, strong) NSString *userDescription;

- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (User *)currentUser;
+ (void) setCurrentUser:(User *)currentUser;
+ (void) logout;
@end
