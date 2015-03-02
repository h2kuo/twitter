//
//  TwitterClient.m
//  Twitter
//
//  Created by Helen Kuo on 2/19/15.
//  Copyright (c) 2015 Helen Kuo. All rights reserved.
//

#import "TwitterClient.h"
#import "Tweet.h"

NSString * const kTwitterConsumerKey = @"nPz0onrTI6CTe0Qr4kKKujEpZ";
NSString * const kTwitterConsumerSecret = @"gHcNwzuowba54MD7zGRTxdTDie5uoz7NeLneqLmwB71goWgjJ0";
NSString * const kTwitterBaseUrl = @"https://api.twitter.com";

@interface TwitterClient()
@property (nonatomic, strong) void (^loginCompletion)(User *user, NSError *error);

@end

@implementation TwitterClient

+ (TwitterClient *)sharedInstance {
    static TwitterClient *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:kTwitterBaseUrl] consumerKey:kTwitterConsumerKey consumerSecret:kTwitterConsumerSecret];
        }
    });
    
    return instance;
}
- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion {
    self.loginCompletion = completion;
    
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"cptwitterdemo://oauth"] scope:nil success:^(BDBOAuth1Credential *requestToken) {
        NSLog(@"got the request token");
        
        NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
        [[UIApplication sharedApplication] openURL:authURL];
    } failure:^(NSError *error) {
        NSLog(@"failed to get the request token");
        self.loginCompletion(nil, error);
    }];
    
}

- (void)openURL:(NSURL *)url {
    
    [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuth1Credential credentialWithQueryString:url.query] success:^(BDBOAuth1Credential *accessToken) {
        NSLog(@"got the access token");
        [self.requestSerializer saveAccessToken:accessToken];
        
        [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            User *user = [[User alloc] initWithDictionary:responseObject];
            [User setCurrentUser:user];
            NSLog(@"current user: %@", user.name);
            self.loginCompletion(user, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"FAILED getting current user");
            self.loginCompletion(nil, error);
        }];
    } failure:^(NSError *error) {
        NSLog(@"failed to get the access token");
        self.loginCompletion(nil, error);
    }];
}

- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSMutableArray *tweets, NSError *error))completion {
    [self GET:@"1.1/statuses/home_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *tweets = [Tweet tweetsWithArray:responseObject];
        completion(tweets, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

- (void)mentionsTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSMutableArray *tweets, NSError *error))completion {
    NSLog(@"mentions");
    [self GET:@"1.1/statuses/mentions_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *tweets = [Tweet tweetsWithArray:responseObject];
        completion(tweets, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

- (void)userTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSMutableArray *tweets, NSError *error))completion {
    [self GET:@"1.1/statuses/user_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *tweets = [Tweet tweetsWithArray:responseObject];
        completion(tweets, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

- (void)toggleFavoriteTweetWithId:(NSInteger)tweetId on:(BOOL)on {
    NSString *endpoint = [NSString stringWithFormat:@"1.1/favorites/%s.json", on ? "create" : "destroy"];
    NSLog(@"endpoint %@", endpoint);
    NSDictionary *params = @{@"id" : @(tweetId)};
    [self POST:endpoint parameters:params success:nil failure:nil];
}

- (void)retweet:(Tweet *)tweet {
    NSString *endpoint = [NSString stringWithFormat:@"1.1/statuses/retweet/%ld.json", (long)tweet.tweetId];
    NSLog(@"endpoint %@", endpoint);
    [self POST:endpoint parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        tweet.retweetId = [responseObject[@"id"] integerValue];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         tweet.retweetId = -1;
        NSLog(@"error retweeting %@", error.description);
    }];
}

-(void)undoRetweet:(Tweet *)tweet {
    if (tweet.retweetId != -1) {
        NSString *endpoint = [NSString stringWithFormat:@"1.1/statuses/destroy/%ld.json", (long)tweet.retweetId];
        NSLog(@"endpoint %@", endpoint);
        [self POST:endpoint parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            tweet.retweetId = -1;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error undoing retweet %@", error.description);
        }];
    }
}

-(void)postStatus:(NSString *)status replyTo:(Tweet *)tweet completion:(void (^)(Tweet *tweet, NSError *error))completion {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:status forKey:@"status"];
    if (tweet != nil) {
        [params setObject:@(tweet.tweetId) forKey:@"in_reply_to_status_id"];
    }
    [self POST:@"1.1/statuses/update.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response object %@", responseObject);
        Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
        completion(tweet, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error tweeting %@", error.description);
        completion(nil, error);
    }];
}

@end
