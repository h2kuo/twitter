//
//  MainViewController.h
//  Twitter
//
//  Created by Helen Kuo on 2/25/15.
//  Copyright (c) 2015 Helen Kuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"

@interface MainViewController : UIViewController

- (id)initWithMenuController:(MenuViewController *)menuViewController contentController:(UINavigationController *)contentController;
@end
