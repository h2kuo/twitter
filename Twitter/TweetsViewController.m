//
//  TweetsViewController.m
//  Twitter
//
//  Created by Helen Kuo on 2/21/15.
//  Copyright (c) 2015 Helen Kuo. All rights reserved.
//

#import "TweetsViewController.h"
#import "User.h"
#import "Tweet.h"
#import "TwitterClient.h"
#import "TweetCell.h"
#import "TweetDetailController.h"
#import "ComposeViewController.h"
#import "ProfileViewController.h"

@interface TweetsViewController () <UITableViewDataSource, UITableViewDelegate, ComposeViewControllerDelegate, TweetCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tweets;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic, assign) BOOL isFetchingData;
@property (nonatomic, assign) BOOL isHome;


@end

@implementation TweetsViewController

-(id)initWithHome:(BOOL)isHome {
    self = [super init];
    if (self) {
        self.isHome = isHome;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"view did load");
    [self callTwitterClientWithParams:nil completion:^(NSMutableArray *tweets, NSError *error) {
        if (error) {
            NSLog(@"%@", error.description);
            self.tweets = self.isHome ? [[User currentUser] tweets] : [[User currentUser] mentions];
        } else {
            self.tweets = tweets;
            [self saveTweets];
        }
        [self.tableView reloadData];
    }];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.333 green:0.675 blue:0.933 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    
    self.title = self.isHome ? @"Home" : @"Mentions";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(onLogout)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(onCreate)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    self.isFetchingData = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onLogout {
    [User logout];
}

- (void) saveTweets {
    if (self.isHome) {
        [[User currentUser] setTweets:self.tweets];
    } else {
        [[User currentUser] setMentions:self.tweets];
    }
}

- (void)callTwitterClientWithParams:(NSDictionary *)params completion:(void (^)(NSMutableArray *tweets, NSError *error))completion {
    if (self.isHome) {
        [[TwitterClient sharedInstance] homeTimelineWithParams:params completion:completion];
    } else {
        [[TwitterClient sharedInstance] mentionsTimelineWithParams:params completion:completion];
    }
}

- (void)fetchMoreData {
    if (!self.isFetchingData) {
        self.isFetchingData = YES;
        Tweet *oldestTweet = self.tweets[self.tweets.count - 1];
        NSDictionary *params = @{@"max_id" : @(oldestTweet.tweetId - 1), @"count" : @20};
        [self callTwitterClientWithParams:params completion:^(NSArray *tweets, NSError *error) {
            if (error) {
                NSLog(@"%@", error.description);
                return;
            }
            [self.tweets addObjectsFromArray:tweets];
            [self saveTweets];
            [self.tableView reloadData];
            self.isFetchingData = NO;
        }];
    }
}

- (void)onRefresh {
    NSLog(@"refresh");
    [self callTwitterClientWithParams:nil completion:^(NSMutableArray *tweets, NSError *error) {
        if (error) {
            NSLog(@"%@", error.description);
            [self.refreshControl endRefreshing];
            return;
        }
        self.tweets = tweets;
        [self saveTweets];
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }];
}

- (void)onCreate {
    ComposeViewController *vc = [[ComposeViewController alloc] init];
    vc.delegate = self;
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
}

#pragma mark - Table methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    cell.tweet = self.tweets[indexPath.row];
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onProfileTap:)];
    tapped.numberOfTapsRequired = 1;
    [cell.avatarView addGestureRecognizer:tapped];
    cell.avatarView.tag = indexPath.row;
    if (indexPath.row == self.tweets.count - 1 && self.tweets.count >= 20) {
        NSLog(@"indexPath %ld", indexPath.row);
        [self fetchMoreData];
    }
    cell.delegate = self;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    TweetDetailController *vc = [[TweetDetailController alloc] init];
    vc.tweet = self.tweets[indexPath.row];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void) onProfileTap:(UITapGestureRecognizer *)sender {
    Tweet *tweet = (Tweet *)self.tweets[sender.view.tag];
    User *user = tweet.retweetedStatus == nil ? tweet.user : tweet.retweetedStatus.user;
    [self.navigationController pushViewController:[[ProfileViewController alloc] initWithUser:user] animated:YES];
}

-(void)composeViewController:(ComposeViewController *)composeViewController didPostStatus:(Tweet *)tweet {
    [self.tweets insertObject:tweet atIndex:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathWithIndex:0]] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)didTapReply:(TweetCell *)cell {
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[[ComposeViewController alloc] initWithTweetToReplyTo:cell.tweet]] animated:YES completion:nil];
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
