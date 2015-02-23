//
//  TwitterClient.h
//  Twitter
//
//  Created by Helen Kuo on 2/19/15.
//  Copyright (c) 2015 Helen Kuo. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"
#import "Tweet.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager
+ (TwitterClient *)sharedInstance;

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion;
- (void)openURL:(NSURL *)url;

- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSMutableArray *tweets, NSError *error))completion;
- (void)toggleFavoriteTweetWithId:(NSInteger)tweetId on:(BOOL)on;
- (void)retweet:(Tweet *)tweet;
- (void)undoRetweet:(Tweet *)tweet;
-(void)postStatus:(NSString *)status replyTo:(Tweet *)tweet completion:(void (^)(Tweet *tweet, NSError *error))completion;
@end
