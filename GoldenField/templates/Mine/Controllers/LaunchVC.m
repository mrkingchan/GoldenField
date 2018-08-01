//
//  LaunchVC.m
//  GoldenField
//
//  Created by Macx on 2018/7/17.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "LaunchVC.h"

@interface LaunchVC ()

@end

@implementation LaunchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setLaunchImage];
}

- (void)setLaunchImage {
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *imagePath = [NSString stringWithFormat:@"%@/launchImage.png",documentPath];
    _launchImageView.image = [[UIImage alloc] initWithContentsOfFile:imagePath];
    @weakify(self);
    [UIView animateWithDuration:2.0 animations:^{
        @strongify(self);
        self->_launchImageView.transform = CGAffineTransformMakeScale(1.3,1.3);
    } completion:^(BOOL finished) {
        [self->_launchImageView removeFromSuperview];
    }];
}

@end
