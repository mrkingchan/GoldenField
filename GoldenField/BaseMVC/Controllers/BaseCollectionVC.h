//
//  BaseCollectionVC.h
//  GoldenField
//
//  Created by Chan on 2018/5/7.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseCollectionVC : BaseVC <UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)NSMutableArray * _Nullable dataArray;

@property(nonatomic,strong)UICollectionView  *collectionView;

@property(nonatomic,assign) BOOL showRefreshHeader;

@property(nonatomic,assign) BOOL showRefreshFooter;

@property(nonatomic,assign) CGSize itemSize;

@property(nonatomic,assign) CGFloat minimumInteritemSpacing;

@property(nonatomic,assign) CGFloat minimumLineSpacing;

// MARK:  -- 交给子类去重写     
- (void)refreshHeaderAction;

- (void)refreshFooterAction;

// MARK:  -- initialized method
- (instancetype)initWithItemSize:(CGSize)itemsize cellClass:(nonnull Class)cellClass;

@end
