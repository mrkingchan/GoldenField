//
//  DiscoveryVC.m
//  GoldenField
//
//  Created by Chan on 2018/5/4.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "DiscoveryVC.h"
#import "DiscoveryModel.h"
#import "DiscoveryCell.h"

@interface DiscoveryVC () <BoxViewDelegate,DisCoveryCellDelegate> {
    NSInteger _currentPage;
}

@end

@implementation DiscoveryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showRefreshHeader = YES;
    self.showRefreshFooter = YES;
    self.tableView.backgroundColor = kColorLightGray;
    for (int i = 0; i < 10 ; i ++) {
        /*DiscoveryModel *model = [DiscoveryModel new];
        model.contentStr = [NSString stringWithFormat:@"XXXXHIHILHTIG4TIBTIBTUIBTI%i",i];
        NSMutableArray *temArray = [NSMutableArray new];
        for (int index = 0; index < 9; index ++) {
            [temArray addObject:[NSString stringWithFormat:@"guide_%i",index %2 == 0 ? 1:2]];
        }
        model.pictureItems = temArray;
        [self.dataArray addObject:model];*/
        NSMutableDictionary *json = [NSMutableDictionary new];
        [json setObject:[NSString stringWithFormat:@"XXXXHIHILHTIG4TIBTIBTUIBTI%i",i] forKey:@"contentStr"];
        NSMutableArray *temArray = [NSMutableArray new];
        for (int index = 0; index < 9; index ++) {
            [temArray addObject:[NSString stringWithFormat:@"%i",index %2 == 0 ? 1:2]];
        }
        [json  setObject:temArray forKey:@"pictureItems"];
        DiscoveryModel *model = [DiscoveryModel jsonToModel:json];
//        [model saveToDB];
        [self.dataArray addObject:model];
    }
    /*NSMutableArray *dbArray = [DiscoveryModel searchWithWhere:nil];
    if (DEBUG) {
        NSLog(@"dataBasePath = %@,dataArray = %@",[[DiscoveryModel class]downloadPath],dbArray);
    }*/
}

#pragma mark  -- 上下拉刷新的方法 交给子类去重写
- (void)tableViewHeaderRefreshAction {
    puts(__func__);
    [self loadingStart];
}

- (void)tableViewFooterRefreshAction {
    _currentPage ++;
    [self loadingStart];
    for (int i = 0; i < 10 ; i ++) {
        /*DiscoveryModel *model = [DiscoveryModel new];
        model.contentStr = [NSString stringWithFormat:@"XXXXHIHILHTIG4TIBTIBTUIBTI%i",i];
        NSMutableArray *temArray = [NSMutableArray new];
        for (int index = 0; index < 9; index ++) {
            [temArray addObject:[NSString stringWithFormat:@"guide_%i",index %2 == 0 ? 1:2]];
        }
        model.pictureItems = temArray;
        [self.dataArray addObject:model];*/
        
        NSMutableDictionary *json = [NSMutableDictionary new];
        [json setObject:[NSString stringWithFormat:@"XXXXHIHILHTIG4TIBTIBTUIBTI%i",i] forKey:@"contentStr"];
        NSMutableArray *temArray = [NSMutableArray new];
        for (int index = 0; index < 9; index ++) {
            [temArray addObject:[NSString stringWithFormat:@"guide_%i",index %2 == 0 ? 1:2]];
        }
        [json  setObject:temArray forKey:@"pictureItems"];
        DiscoveryModel *model = [DiscoveryModel jsonToModel:json];
        [self.dataArray addObject:model];
    }
}

- (void)loadDataWithPage:(NSInteger)page {
    @weakify(self);
    [NetTool innerRequestWithHttpMethod:POST
                                 urlStr:kBaseURL
                                 params:@{@"page":@(_currentPage)} target:self
                                 sucess:^(id responseObject) {
                                     @strongify(self);
                                     ///... add dataSource & reload tableView
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         [self.tableView reloadData];
                                     });
                                 } failure:^(NSString *errorStr) {
                                     
                                 }];
}

#pragma mark  -- UITableViewDataSource&Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DiscoveryCell *cell = [tableView dequeueReusableCellWithIdentifier:[DiscoveryCell cellIdentifier]];
    if (!cell) {
        cell = [[DiscoveryCell alloc] initWithStyle:0 reuseIdentifier:[DiscoveryCell cellIdentifier]];
    }
    cell.containerView.delegate = self;
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setCellWithData:self.dataArray[indexPath.row]];
    cell.containerView.complete = ^(NSInteger index, NSArray *itmes) {
        NSLog(@"index = %zd",index);
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [DiscoveryCell cellHeightWithModel:self.dataArray[indexPath.row]];
}

#pragma mark  -- BoxViewDelegate
- (void)boxView:(id)boxView selectedIndex:(NSInteger)index items:(NSArray *)items{
    puts(__func__);
}

#pragma mark  -- DisCoveryCellDelegate
- (void)disCoveryCell:(DiscoveryCell *)cell avatarSelected:(DiscoveryModel *)model {
    puts(__func__);
    NSLog(@"click model = %@",[model modelToJson]);
}

#pragma mark  -- memerory management
-(void)dealloc {
    if (self.tableView) {
        self.tableView.dataSource = nil;
        self.tableView.delegate = nil;
        self.tableView = nil;
    }
    if (self.dataArray) {
        self.dataArray = nil;
    }
}

@end
