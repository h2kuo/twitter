//
//  MenuCell.m
//  Twitter
//
//  Created by Helen Kuo on 2/26/15.
//  Copyright (c) 2015 Helen Kuo. All rights reserved.
//

#import "MenuCell.h"

@implementation MenuCell

- (void)awakeFromNib {
    // Initialization code
    UIView *background = [[UIView alloc] initWithFrame:self.frame];
    [background setBackgroundColor:[UIColor colorWithRed:0.4 green:0.459 blue:0.498 alpha:1]];
    [self setSelectedBackgroundView:background];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
