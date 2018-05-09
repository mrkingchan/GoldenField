//
//  FriendCircleCell.m
//  GoldenField
//
//  Created by Macx on 2018/5/8.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "DiscoveryCell.h"
#import "BoxView.h"

@interface DiscoveryCell() {
    UILabel *_content;
    UIView *_separatorView;
    UIImageView *_header;
}
@end

@implementation DiscoveryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}

-(void)setUI {
    
    _header = InsertImageView(self, CGRectMake(5, 20, 30, 30), kIMAGE(@"AppIcon"));
    _header.clipsToBounds = YES;
    _header.layer.cornerRadius = _header.height / 2.0;
    _header.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonAction:)];
    [_header addGestureRecognizer:tap];
    
    _content = InsertLabel(self, CGRectZero, 0, @"", kFontSize(13), kColorBlack, NO);
    _content.numberOfLines = 0;

    _containerView = [[BoxView alloc] initWithFrame:CGRectMake(40, 0, kScreenWidth - 80,0)];
    [self addSubview:_containerView];
    
    _separatorView = InsertView(self, CGRectZero, kColorLightGray);
    
}

#pragma mark  -- private Method
-(void)buttonAction:(UITapGestureRecognizer *)tap {
    if ([tap.view isEqual:_header]) {
//        if (_delegate && [_delegate respondsToSelector:@selector(disCoveryCell:avatarSelected:)]) {
        if (_delegate) {
            [_delegate disCoveryCell:self avatarSelected:_model];
        }
    }
}

-(void)setCellWithData:(DisoveryModel *)model {
    _model = model;
    _content.frame = CGRectMake(40, 10, kScreenWidth - 80, 60);
    _content.text = model.contentStr;
    _containerView.top = _content.bottom + 10;
    _containerView.height = [BoxView boxHeightWithPictureArray:model.pictureItems];
    _separatorView.frame = CGRectMake(0, _containerView.bottom + 8, kScreenWidth, 2);
    [_containerView setBoxViewWithData:model.pictureItems];
}

+(CGFloat)cellHeightWithModel:(DisoveryModel *)model {
    return  60  + 10 + [BoxView boxHeightWithPictureArray:model.pictureItems] + 10 + 10;
}

+ (NSString *)cellIdentifier {
    return NSStringFromClass([self class]);
}

@end
