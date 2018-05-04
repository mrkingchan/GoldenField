//
//  HomeVC.m
//  GoldenField
//
//  Created by Macx on 2018/5/4.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "HomeVC.h"
#import "FreshFishCell.h"

@interface HomeVC () <UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate> {
    UIBarButtonItem *_scan;
    SDCycleScrollView *_bannerView;
    UITableView *_tableView;
}

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"一亩黄金";
    _bannerView = [SDCycleScrollView  cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 200) delegate:self placeholderImage:kIMAGE(@"guide_1")];
    
    _bannerView.imageURLStringsGroup = @[@"guide_1",@"guide_2",@"guide_3",@"guide_1",@"guide_2",@"guide_3"];
    
    //tableView初始化
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.view.height) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FreshFishCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[FreshFishCell cellIdentifier]];
    [self.view addSubview:_tableView];
    _tableView.tableHeaderView = _bannerView;
    _tableView.backgroundColor = [UIColor whiteColor];
    
    @weakify(self);
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        @strongify(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self->_tableView.header endRefreshing];
        });
    }];
}

#pragma mark  -- UITableViewDataSource&Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FreshFishCell *cell = [tableView dequeueReusableCellWithIdentifier:[FreshFishCell cellIdentifier]];
    cell.backgroundColor = indexPath.section == 0 ? [UIColor orangeColor]:indexPath.section == 1?[UIColor blueColor]: indexPath.section  == 2 ?[UIColor redColor]:[UIColor blackColor];
    /*if (!cell) {
        cell = [[FreshFishCell alloc] initWithStyle:0 reuseIdentifier:[FreshFishCell cellIdentifier]];
    }*/
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0 :10;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    WebVC *nextVC = [[WebVC alloc] initWithUrlString:@"http://www.baidu.com"];
    [self.navigationController pushViewController:nextVC animated:YES];
}
@end
