//
//  BaseCollectionVC.h
//  GoldenField
//
//  Created by Macx on 2018/5/7.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseCollectionVC : UIViewController <UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,strong)UICollectionView  *collectionView;

@property(nonatomic,assign) BOOL showRefreshHeader;

@property(nonatomic,assign) BOOL showRefreshFooter;

@property(nonatomic,assign) CGSize itemSize;

@property(nonatomic,assign) CGFloat minimumInteritemSpacing;

@property(nonatomic,assign) CGFloat minimumLineSpacing;

#pragma mark  -- 交给子类去重写     
- (void)refreshHeaderAction;

- (void)refreshFooterAction;


@end
