//
//  ComposeViewController.m
//  Twitter
//
//  Created by Helen Kuo on 2/22/15.
//  Copyright (c) 2015 Helen Kuo. All rights reserved.
//

#import "ComposeViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"

@interface ComposeViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (nonatomic) UIBarButtonItem *tweetButton;
@property (nonatomic) UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;
@property (nonatomic) Tweet *tweetToReplyTo;

@end

@implementation ComposeViewController

-(id)initWithTweetToReplyTo:(Tweet *)tweetToReplyTo {
    self = [super init];
    if (self) {
        self.tweetToReplyTo = tweetToReplyTo;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [User currentUser];
    self.avatarView.image = nil;
    [self.avatarView setImageWithURL:[NSURL URLWithString:self.user.profileImageUrl]];
    self.authorLabel.text = self.user.name;
    self.userLabel.text = [NSString stringWithFormat:@"@%@", self.user.screenname];
    self.avatarView.layer.cornerRadius = 3;
    self.avatarView.clipsToBounds = YES;
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(onCancelButton)];
    
    UIBarButtonItem *tweetButton = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(onTweetButton)];
    self.tweetButton = tweetButton;
    tweetButton.enabled = NO;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = @"140";
    label.textColor = [UIColor grayColor];
    [label sizeToFit];
    self.countLabel = label;
    
    UIBarButtonItem *countButton = [[UIBarButtonItem alloc] initWithCustomView:label];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:tweetButton, countButton, nil];
    
    self.textView.delegate = self;
    if (self.tweetToReplyTo != nil) {
        self.hintLabel.hidden = YES;    
        if (self.tweetToReplyTo.retweetedStatus != nil) {
            self.textView.text = [NSString stringWithFormat:@"@%@ @%@ ", self.tweetToReplyTo.retweetedStatus.user.screenname, self.tweetToReplyTo.user.screenname];
        } else {
            self.textView.text = [NSString stringWithFormat:@"@%@ ", self.tweetToReplyTo.user.screenname];
        }
    }
    
    // Do any additional setup after loading the view from its nib.
}

-(void)textViewDidChange:(UITextView *)textView {
    NSUInteger textLength = textView.text.length;
    self.tweetButton.enabled = textLength > 0 && textLength <=140 ? YES : NO;
    self.countLabel.textColor = textLength > 140 ? [UIColor redColor] : [UIColor grayColor];
    self.hintLabel.hidden = textLength > 0 ? YES : NO;
    [self.countLabel setText:[NSString stringWithFormat:@"%d", (int) (140 - textView.text.length)]];
    [self.countLabel sizeToFit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [self.textView becomeFirstResponder];
}

-(void)onCancelButton {
    [self.textView endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onTweetButton {
    
    [[TwitterClient sharedInstance] postStatus:self.textView.text replyTo:self.tweetToReplyTo completion:^(Tweet *tweet, NSError *error) {
        if (tweet != nil) {
            NSLog(@"success! %@", tweet.text);
            [self dismissViewControllerAnimated:YES completion:nil];
            [self.delegate composeViewController:self didPostStatus:tweet];
        } else {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Tweet Failed"
                                  message:@""
                                  delegate:nil
                                  cancelButtonTitle:@"Dismiss"
                                  otherButtonTitles:nil];
            
            [alert show];
        }
    }];
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
