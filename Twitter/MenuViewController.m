//
//  MenuViewController.m
//  Twitter
//
//  Created by Helen Kuo on 2/25/15.
//  Copyright (c) 2015 Helen Kuo. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuCell.h"

@interface MenuViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *menuOptions;
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.menuOptions = [NSArray arrayWithObjects:@"Profile", @"Timeline", @"Mentions", nil];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MenuCell" bundle:nil] forCellReuseIdentifier:@"MenuCell"];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    cell.menuLabel.text = self.menuOptions[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.frame.size.height / 6;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate didSelectMenuItem:indexPath.row];
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
