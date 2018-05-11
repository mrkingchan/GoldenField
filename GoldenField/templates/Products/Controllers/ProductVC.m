//
//  ProductVC.m
//  GoldenField
//
//  Created by Chan on 2018/5/4.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "ProductVC.h"

@interface ProductVC ()

@end

@implementation ProductVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.itemSize = CGSizeMake((kScreenWidth - 15) / 4.0, (kScreenWidth - 15) / 4.0);
    [self setShowRefreshFooter:YES];
    [self setShowRefreshHeader:YES];
    [self refreshHeaderAction];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"refresh" style:UIBarButtonItemStylePlain target:self action:@selector(loadData)];
}

#pragma mark  -- loadData
- (void)loadData {
    [self loadingStartBgClear];
    [NetTool innerRequestWithHttpMethod:POST
                                 urlStr:@"xxxxx"
                                 params:nil
                                 target:self
                                 sucess:^(id responseObject) {
                                     [self loadingSuccess];
                                 } failure:^(NSString *errorStr) {
                                     [self loadingFailWithTitle:errorStr];
                                 }];
}

-(void)refreshClick {
    [self loadData];
}

#pragma mark  -- 上下拉刷新
- (void)refreshHeaderAction {
    for ( int i = 0; i  < 10; i ++) {
        [self.dataArray addObject:@(i)];
    }
}

- (void)refreshFooterAction {
    for (int i = 0; i  < 10; i ++) {
        [self.dataArray addObject:@(i)];
    }
}

#pragma mark  -- UIColletioncViewDataSource&Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    cell.backgroundColor = kRandomColor;
    return cell;
}
@end
