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
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArray = [NSMutableArray new];
    _tableView = InsertTableView(self.view, CGRectMake(0,0, self.view.width, self.view.height), self, self, 0, 0);
    [self setShowRefreshHeader:NO];
    [self setShowRefreshFooter:NO];
}

#pragma mark  -- Getter &Setter Method
-(void)setShowRefreshFooter:(BOOL)showRefreshFooter {
    _showRefreshFooter = showRefreshFooter;
    if (showRefreshFooter) {
        @weakify(self);
        [_tableView addLegendFooterWithRefreshingBlock:^{
            @strongify(self);
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
        @weakify(self);
        [_tableView addLegendHeaderWithRefreshingBlock:^{
            @strongify(self);
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
        @weakify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            [self->_tableView reloadData];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    puts(__func__);
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
