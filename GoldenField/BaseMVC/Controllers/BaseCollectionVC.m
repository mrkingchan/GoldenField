//
//  BaseCollectionVC.m
//  GoldenField
//
//  Created by Macx on 2018/5/7.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "BaseCollectionVC.h"

@interface BaseCollectionVC () {
    
}

@end

@implementation BaseCollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray new];
}

- (void)setItemSize:(CGSize)itemSize {
    _itemSize = itemSize;
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = self.itemSize;
    layout.minimumInteritemSpacing = self.minimumInteritemSpacing == 0 ? 5.0 :self.minimumInteritemSpacing;
    layout.minimumLineSpacing = self.minimumLineSpacing == 0 ? 5.0 :self.minimumLineSpacing;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[UICollectionViewCell  class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    //默认为NO 具体的子类中重写设置
    [self setShowRefreshHeader:NO];
    [self setShowRefreshFooter:NO];
}

#pragma mark  --Setter &Getter
-(void)setShowRefreshFooter:(BOOL)showRefreshFooter {
    _showRefreshFooter = showRefreshFooter;
    if (_showRefreshFooter) {
        @weakify(self);
        [_collectionView addLegendFooterWithRefreshingBlock:^{
            @strongify(self);
            [self refreshFooterAction];
            //停止上拉 reloadData
            [self refreshDoneisHeader:NO];
        }];
    } else {
        [_collectionView setValue:nil forKey:@"footer"];
    }
}


-(void)setShowRefreshHeader:(BOOL)showRefreshHeader {
    _showRefreshHeader = showRefreshHeader;
    if (_showRefreshHeader) {
        @weakify(self);
        [_collectionView addLegendHeaderWithRefreshingBlock:^{
            @strongify(self);
            [self refreshHeaderAction];
            //停止下拉 并刷新
            [self refreshDoneisHeader:YES];
        }];
    } else {
        [_collectionView setValue:nil forKey:@"header"];
    }
}

#pragma mark  -- 交给子类去重写

-(void)refreshHeaderAction {
    
}

- (void)refreshFooterAction {
    
}

- (void)refreshDoneisHeader:(BOOL)isHeader {
    if (isHeader) {
        [_collectionView.header  endRefreshing];
    } else {
        [_collectionView.footer endRefreshing];
    }
    @weakify(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        @strongify(self);
        [self->_collectionView reloadData];
    });
}

#pragma mark  -- UICollectionViewDataSource&Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return  1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    return cell;
}

@end
