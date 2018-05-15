//
//  BaseVC.m
//  GoldenField
//
//  Created by Chan on 2018/5/4.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "BaseTableVC.h"

@interface BaseTableVC ()

@end

@implementation BaseTableVC

#pragma mark  -- lifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArray = [NSMutableArray new];
    _tableView = InsertTableView(self.view, CGRectMake(0,0, kScreenWidth, self.view.height), self, self, UITableViewStylePlain, UITableViewCellSeparatorStyleNone);
    [self setShowRefreshHeader:NO];
    [self setShowRefreshFooter:NO];
    [NSThread detachNewThreadSelector:@selector(checkInterNet) toTarget:self withObject:nil];
}

- (void)checkInterNet {
    while (true) {
        [self netWorkChangWithNetWorkWithStatus:[AFNetworkReachabilityManager sharedManager].networkReachabilityStatus];
    }
}

- (void)netWorkChangWithNetWorkWithStatus:(AFNetworkReachabilityStatus)status {
    if (status == AFNetworkReachabilityStatusNotReachable) {
        self.netWorkErrorView.top = 0;
    } else {
        self.netWorkErrorView.top = -35;
    }
    _tableView.top = self.netWorkErrorView.bottom;
    _tableView.height = self.view.height - self.netWorkErrorView.bottom;
}
#pragma mark  -- Getter &Setter Method
-(void)setShowRefreshFooter:(BOOL)showRefreshFooter {
    _showRefreshFooter = showRefreshFooter;
    if (showRefreshFooter) {
        [_tableView addLegendFooterWithRefreshingBlock:^{
            dispatch_async(dispatch_get_main_queue(), ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
                [self loadingStartBgClear];
#pragma clang diagnostic pop
            });
            [self tableViewFooterRefreshAction];
            [self refreshDoneActionIsHeader:NO reloadData:YES];
        }];
    } else {
        [_tableView setValue:nil forKey:@"footer"];
    }
}

- (void)setShowRefreshHeader:(BOOL)showRefreshHeader {
    _showRefreshHeader = showRefreshHeader;
    if (showRefreshHeader) {
        [_tableView addLegendHeaderWithRefreshingBlock:^{
            dispatch_async(dispatch_get_main_queue(), ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
                [self loadingStartBgClear];
#pragma clang diagnostic pop

            });
            [self tableViewHeaderRefreshAction];
            [self refreshDoneActionIsHeader:YES reloadData:YES];
        }];
    } else {
        [_tableView setValue:nil forKey:@"header"];
    }
}

- (void)refreshDoneActionIsHeader:(BOOL)isHeader reloadData:(BOOL)refreshData {
    if (isHeader) {
        [_tableView.header endRefreshing];
    } else {
        [_tableView.footer  endRefreshing];
    }
    
    if (refreshData) {
//        @weakify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
//            @strongify(self);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
                [self loadingSuccess];
                [self->_tableView reloadData];
#pragma clang diagnostic pop
            });
        });
    }
}

#pragma mark  -- 交给子类去重写
- (void)tableViewHeaderRefreshAction {
    puts(__func__);
}

-(void)tableViewFooterRefreshAction {
    puts(__func__);
}

#pragma mark  -- UITableViewDataSource&Delegate
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark  -- memerory management
- (void)dealloc {
    if (self.tableView) {
        self.tableView.delegate = nil;
        self.tableView.dataSource = nil;
    }
    if (self.dataArray) {
        self.dataArray = nil;
    }
}
@end
