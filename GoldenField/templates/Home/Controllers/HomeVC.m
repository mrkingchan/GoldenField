//
//  HomeVC.m
//  GoldenField
//
//  Created by Chan on 2018/5/4.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "HomeVC.h"
#import "FreshFishCell.h"
#import "ScanVC.h"

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
    /*//tableView初始化
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.view.height) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FreshFishCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[FreshFishCell cellIdentifier]];
    [self.view addSubview:_tableView];
    _tableView.tableHeaderView = _bannerView;
    _tableView.backgroundColor = [UIColor whiteColor];
    
    ///下拉刷新
    @weakify(self);
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        @strongify(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self->_tableView.header endRefreshing];
        });
    }];*/
    self.showRefreshHeader = YES;
    self.tableView.tableHeaderView = _bannerView;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FreshFishCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[FreshFishCell cellIdentifier]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:kIMAGE(@"scan")   style:UIBarButtonItemStylePlain target:self action:@selector(buttonAction:)];
}

#pragma mark  -- private Method
- (void)buttonAction:(id)sender {
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"simulator can't support Camera!");
#elif TARGET_OS_IPHONE
    [self.navigationController pushViewController:[ScanVC new] animated:YES];
#endif
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
    cell.backgroundColor = kRandomColor;
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

#pragma mark  -- memerory management
- (void)dealloc {
    if (self.tableView) {
        self.tableView.delegate = nil;
        self.tableView.dataSource = nil;
        self.tableView = nil;
    }
    if (self.dataArray) {
        self.dataArray = nil;
    }
}
@end
