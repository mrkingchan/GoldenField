//
//  BaseScrollVC.m
//  GoldenField
//
//  Created by Chan on 2018/5/8.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "BaseScrollVC.h"
@interface BaseScrollVC () <UITableViewDelegate,UITableViewDataSource> {
    UITableView *_tableView;
}

@end

@implementation BaseScrollVC

#pragma mark  -- ViewController lifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    _tableView = InsertTableView(self.view, CGRectMake(0, 0, self.view.width, self.view.height), self, self, 0, 0);
    _tableView.tableFooterView = [UIView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    //self.view就是一个cell
    self.view = _tableView;
}

#pragma mark  -- UITableViewDataSource&Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell  *cell  = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}

#pragma mark  -- memerory management
- (void)dealloc {
    if (_tableView ) {
        _tableView = nil;
    }
}
@end
