//
//  FriendCircleCell.h
//  GoldenField
//
//  Created by Chan on 2018/5/8.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscoveryModel.h"
#import "BoxView.h"

@class DiscoveryCell;
@class DiscoveryModel;

@protocol DisCoveryCellDelegate

- (void)disCoveryCell:(DiscoveryCell *)cell avatarSelected:(DiscoveryModel *)model;

@end

@interface DiscoveryCell : UITableViewCell

@property(nonatomic,strong)DiscoveryModel *model;

@property(nonatomic,strong)BoxView *containerView;

- (void)setCellWithData:(DiscoveryModel *)model;

+ (CGFloat)cellHeightWithModel:(DiscoveryModel *)model;

+ (NSString *)cellIdentifier;

@property(nonatomic,weak)id <DisCoveryCellDelegate>delegate;


@end

