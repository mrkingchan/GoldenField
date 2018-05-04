//
//  FreshFishCell.m
//  GoldenField
//
//  Created by Macx on 2018/5/4.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "FreshFishCell.h"

@interface FreshFishCell() {
    UIImageView *_vip;
}
@end

@implementation FreshFishCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    //vip
    _vip = [[UIImageView alloc] init];
    [self addSubview:_vip];
    [_vip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(10);
        make.top.equalTo(self.mas_top).with.offset(10);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
}

+ (NSString *)cellIdentifier {
    return NSStringFromClass([self class]);
}

@end
