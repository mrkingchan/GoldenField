//
//  FriendCircleCell.h
//  GoldenField
//
//  Created by Macx on 2018/5/8.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DisoveryModel.h"
#import "BoxView.h"

@class DiscoveryCell;
@class DisoveryModel;

@protocol DisCoveryCellDelegate

- (void)disCoveryCell:(DiscoveryCell *)cell avatarSelected:(DisoveryModel *)model;

@end

@interface DiscoveryCell : UITableViewCell

@property(nonatomic,strong)DisoveryModel *model;

@property(nonatomic,strong)BoxView *containerView;

- (void)setCellWithData:(DisoveryModel *)model;

+ (CGFloat)cellHeightWithModel:(DisoveryModel *)model;

+ (NSString *)cellIdentifier;

@property(nonatomic,weak)id <DisCoveryCellDelegate>delegate;


@end

