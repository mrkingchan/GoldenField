//
//  ProductVC.m
//  GoldenField
//
//  Created by Macx on 2018/5/4.
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
    for (int i = 0; i < 30; i ++) {
        [self.dataArray addObject:@(i)];
    }
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
