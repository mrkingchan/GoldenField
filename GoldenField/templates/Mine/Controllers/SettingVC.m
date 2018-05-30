//
//  SettingVC.m
//  GoldenField
//
//  Created by Chan on 2018/5/22.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "SettingVC.h"
#import "GestureSettingVC.h"
#import "SkinVC.h"

@interface SettingVC ()

@end

@implementation SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    [self.dataArray addObject:@"手势密码"];
    [self.dataArray addObject:@"皮肤设置"];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        //手势
        [self.navigationController pushViewController:[GestureSettingVC new] animated:YES];
    } else if (indexPath.row == 1 ) {
        //皮肤
        [self.navigationController pushViewController:[SkinVC new] animated:YES];
        
    }
}

@end
