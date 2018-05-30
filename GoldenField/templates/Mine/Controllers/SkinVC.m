//
//  SkinVC.m
//  GoldenField
//
//  Created by Macx on 2018/5/30.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "SkinVC.h"

@interface SkinVC () {
    NSInteger _currentIndex;
}

@end

@implementation SkinVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"皮肤中心";
    [self.dataArray addObjectsFromArray:@[@"默认模式",@"夜间模式",@"模式1",@"模式2"]];
    _currentIndex = 0;
}

// MARK: - UITableViewDataSource &Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:NSStringFromClass(self.class)];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    if (indexPath.row == _currentIndex) {
        cell.accessoryType=  UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _currentIndex = indexPath.row;
    [tableView reloadData];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     [[ThemManager shareManager]setThemType:indexPath.row];
}
@end
