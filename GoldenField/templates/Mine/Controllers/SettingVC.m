//
//  SettingVC.m
//  GoldenField
//
//  Created by Macx on 2018/5/22.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "SettingVC.h"
#import "GestureSettingVC.h"

@interface SettingVC ()

@end

@implementation SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    [self.dataArray addObject:@"手势密码"];
}

#pragma mark  -- UITableViewDataSource&Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:NSStringFromClass(UITableViewCell.class)];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        GestureSettingVC *VC = [GestureSettingVC new];
        [self.navigationController pushViewController:VC animated:YES];
    }
}
@end
