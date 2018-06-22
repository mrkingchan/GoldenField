//
//  MineVC.m
//  GoldenField
//
//  Created by Chan on 2018/5/4.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "MineVC.h"
#import "SettingVC.h"
#import "CodeVerifyVC.h"

@interface MineVC () <UITableViewDelegate,UITableViewDataSource> {
    UITableView *_tableView;
}

@end

@implementation MineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    /*_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    _tableView.tableFooterView = [UIView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    @weakify(self);
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        @strongify(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self->_tableView.header endRefreshing];
        });
    }];
    [self.view addSubview:_tableView];
     */
    self.showRefreshHeader = YES;
    self.showRefreshFooter = YES;
    [self tableViewHeaderRefreshAction];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"setting" style:UIBarButtonItemStylePlain target:self action:@selector(buttonAction:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"验证码" style:UIBarButtonItemStylePlain target:self action:@selector(codeAction) ];
}

- (void)codeAction {
    [self.navigationController pushViewController:[CodeVerifyVC new] animated:YES];
}

- (void)buttonAction:(id)sender {
    SettingVC *VC = [SettingVC new];
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)tableViewHeaderRefreshAction {
    [super tableViewHeaderRefreshAction];
    for (int i = 0; i < 10; i ++) {
        [self.dataArray addObject:[NSString stringWithFormat:@"HeaderData - %i", i + 1]];
    }
}

-(void)tableViewFooterRefreshAction {
    [super tableViewFooterRefreshAction];
    for (int i = 0; i < 10; i ++) {
        [self.dataArray  addObject:[NSString stringWithFormat:@"FooterData - %i",i + 1]];
    }
}

// MARK:  -- UITableViewDataSource&Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell  class])];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self verifyLogin:^{

    }];
}
@end

