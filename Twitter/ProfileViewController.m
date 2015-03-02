//
//  ProfileViewController.m
//  Twitter
//
//  Created by Helen Kuo on 2/28/15.
//  Copyright (c) 2015 Helen Kuo. All rights reserved.
//

#import "ProfileViewController.h"
#import "User.h"
#import "ProfileCell.h"
#import "UIImageView+AFNetworking.h"
#import "UIColor+fromHex.h"
#import "TwitterClient.h"
#import "TweetCell.h"
#import "TweetDetailController.h"
#import "ComposeViewController.h"

NSInteger const kHeaderHeight = 100;

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, TweetCellDelegate>
@property (nonatomic) User *user;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIImageView *headerView;
@property (strong, nonatomic) UIImage *originalImage;
@property (nonatomic) NSArray *tweets;
@end

@implementation ProfileViewController

-(id)initWithUser:(User *)user {
    self = [super init];
    if (self) {
        self.user = user;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSDictionary *params = @{@"screen_name" : self.user.screenname};
    [[TwitterClient sharedInstance] userTimelineWithParams:params completion:^(NSMutableArray *tweets, NSError *error) {
        if (error) {
            NSLog(@"%@", error.description);
        }
        self.tweets = tweets;
        [self.tableView reloadData];
    }];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"ProfileCell" bundle:nil] forCellReuseIdentifier:@"ProfileCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];
    self.tableView.estimatedRowHeight = 100;
    
    UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -kHeaderHeight, self.tableView.bounds.size.width, kHeaderHeight)];
    headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    headerView.contentMode = UIViewContentModeScaleAspectFill;
    if (self.user.profileBannerUrl != nil) {
        [headerView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/600x200", self.user.profileBannerUrl]]];
    } else {
        NSLog(@"%@",self.user.profileBackgroundColor);
        [headerView setBackgroundColor:[UIColor colorWithHexString:self.user.profileBackgroundColor]];
    }
    [self.tableView insertSubview:headerView atIndex:0];
    
    self.headerView = headerView;
    self.tableView.contentInset = UIEdgeInsetsMake(kHeaderHeight, 0, 0, 0);
    self.tableView.contentOffset = CGPointMake(0, -kHeaderHeight);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateHeaderView {
    CGRect headerRect = CGRectMake(0, -kHeaderHeight, self.tableView.bounds.size.width, kHeaderHeight);
    if (self.tableView.contentOffset.y < -kHeaderHeight) {
        headerRect.origin.y = self.tableView.contentOffset.y;
        headerRect.size.height = -self.tableView.contentOffset.y;
    }
    self.headerView.frame = headerRect;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateHeaderView];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return self.tweets.count;
    } else {
        return 1;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ProfileCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ProfileCell"];
        cell.user = self.user;
        return cell;
    } else {
        TweetCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
        cell.tweet = self.tweets[indexPath.row];
        UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onProfileTap:)];
        tapped.numberOfTapsRequired = 1;
        [cell.avatarView addGestureRecognizer:tapped];
        cell.avatarView.tag = indexPath.row;
        cell.delegate = self;
        return cell;
    }
}

-(void) onProfileTap:(UITapGestureRecognizer *)sender {
    Tweet *tweet = (Tweet *)self.tweets[sender.view.tag];
    User *user = tweet.retweetedStatus == nil ? tweet.user : tweet.retweetedStatus.user;
    [self.navigationController pushViewController:[[ProfileViewController alloc] initWithUser:user] animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return;
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    TweetDetailController *vc = [[TweetDetailController alloc] init];
    vc.tweet = self.tweets[indexPath.row];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:vc animated:YES];
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
