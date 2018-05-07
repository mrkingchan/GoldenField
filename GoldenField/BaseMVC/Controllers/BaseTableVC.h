//
//  BaseVC.h
//  GoldenField
//
//  Created by Macx on 2018/5/4.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableVC : UIViewController <UITableViewDataSource,UITableViewDelegate>


/**
 验证登录

 @param complete 验证登录
 */
- (void)verifyLogin:(void(^)(void))complete;

@property(nonatomic,assign) BOOL showRefreshHeader;

@property(nonatomic,assign) BOOL showRefreshFooter;

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *dataArray;


#pragma mark  -- 交给子类去重写
- (void)tableViewHeaderRefreshAction;

-(void)tableViewFooterRefreshAction;


@end
