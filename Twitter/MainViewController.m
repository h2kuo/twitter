//
//  MainViewController.m
//  Twitter
//
//  Created by Helen Kuo on 2/25/15.
//  Copyright (c) 2015 Helen Kuo. All rights reserved.
//

#import "MainViewController.h"
#import "MenuViewController.h"
#import "TweetsViewController.h"
#import "ProfileViewController.h"

@interface MainViewController () <MenuControllerDelegate>

@property (nonatomic, assign) CGPoint originalCenter;

@property (nonatomic, assign) CGPoint openMenu;
@property (nonatomic, assign) CGPoint closeMenu;
@property (nonatomic, strong) MenuViewController *menuController;
@property (nonatomic, strong) UINavigationController *contentController;
@property (nonatomic, strong) UIPanGestureRecognizer *swipeRecognizer;

@end

@implementation MainViewController
- (id)initWithMenuController:(MenuViewController *)menuViewController contentController:(UINavigationController *)contentController {
    self = [super init];
    if (self) {
        self.menuController = menuViewController;
        self.contentController = contentController;
        self.swipeRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
        [self.contentController.view addGestureRecognizer:self.swipeRecognizer];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addChildViewController:self.menuController];
    [self.view addSubview:self.menuController.view];
    [self.menuController didMoveToParentViewController:self];
    self.menuController.delegate = self;
    
    [self addChildViewController:self.contentController];
    [self.view addSubview:self.contentController.view];
    [self.contentController didMoveToParentViewController:self];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.menuController.view.frame = CGRectMake(0,0,self.view.frame.size.width *3/4, self.view.frame.size.height);
    self.contentController.view.frame = self.view.frame;
    self.closeMenu = self.view.center;
    self.openMenu = CGPointMake(self.view.frame.origin.x + self.view.frame.size.width*1.25, self.view.center.y);
}


-(void)didSelectMenuItem:(NSInteger)index {
    [UIView animateWithDuration:0.3 animations:^{
        self.contentController.view.center = self.closeMenu;
        if (index == 0) {
            [self.contentController setViewControllers:@[[[ProfileViewController alloc] initWithUser:[User currentUser]]]];
        }
        if (index == 1) {
            [self.contentController setViewControllers:@[[[TweetsViewController alloc] initWithHome:YES]]];
        } if (index == 2) {
            [self.contentController setViewControllers:@[[[TweetsViewController alloc] initWithHome:NO]]];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onPan:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.originalCenter = self.contentController.view.center;
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        float x = self.originalCenter.x + [sender translationInView:self.view].x;
        if (x >= self.closeMenu.x && x <= self.openMenu.x) {
            self.contentController.view.center = CGPointMake(x, self.originalCenter.y);
        }
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.2 animations:^{
            self.contentController.view.center = [sender velocityInView:self.view].x > 0 ? self.openMenu : self.closeMenu;
        }];

    }
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
