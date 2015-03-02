//
//  MenuViewController.h
//  Twitter
//
//  Created by Helen Kuo on 2/25/15.
//  Copyright (c) 2015 Helen Kuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuViewController;

@protocol MenuControllerDelegate <NSObject>

-(void)didSelectMenuItem:(NSInteger)index;

@end

@interface MenuViewController : UIViewController

@property (nonatomic, weak) id<MenuControllerDelegate> delegate;

@end
