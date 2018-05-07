//
//  BaseVC.h
//  GoldenField
//
//  Created by Macx on 2018/5/4.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"

@interface BaseTableVC : BaseVC <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,assign) BOOL showRefreshHeader;

@property(nonatomic,assign) BOOL showRefreshFooter;

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *dataArray;


#pragma mark  -- 交给子类去重写
- (void)tableViewHeaderRefreshAction;

-(void)tableViewFooterRefreshAction;


@end
