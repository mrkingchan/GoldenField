//
//  GestureSettingVC.m
//  GoldenField
//
//  Created by Macx on 2018/5/22.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "GestureSettingVC.h"

@interface GestureSettingVC ()<CircleViewDelegate> {
    PCCircleView *_lockView;
    UILabel *_tip;
}

@end

@implementation GestureSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置手势密码";
    self.view.backgroundColor = kColorLightGray;
    BOOL isVerify = [PCCircleViewConst getGestureWithKey:gestureFinalSaveKey].length > 0;
    _lockView = [[PCCircleView alloc] initWithType:isVerify? CircleViewTypeVerify: CircleViewTypeSetting clip:YES arrow:YES];
    _lockView.frame = CGRectMake(20, kScreenHeight / 2 - ((kScreenWidth - 40)/2), kScreenWidth - 40, kScreenWidth - 40);
    _lockView.delegate = self;
    [self.view addSubview:_lockView];
    
     _tip = InsertLabel(self.view, CGRectMake(0, _lockView.top - 50, kScreenWidth, 30), 1, @"", kFontSize(15), kApperanceColor, NO);
    _tip.text =  @"设置手势密码";
}

- (void)circleView:(PCCircleView *)view type:(CircleViewType)type connectCirclesLessThanNeedWithGesture:(NSString *)gesture {
    NSLog(@"手势少于需要数量!");
    _tip.text = @"手势少于需要数量!";
    [_lockView.layer shake];
}

- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteSetFirstGesture:(NSString *)gesture {
    NSLog(@"请继续输入!");
    _tip.text = @"请继续输入!";
}

- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteSetSecondGesture:(NSString *)gesture result:(BOOL)equal {
    if (equal) {
        NSLog(@"手势设置成功");
        _tip.text =@"手势设置成功";
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        _tip.text = @"与上次密码不一致!";
        [view.layer shake];
    }
}

- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteLoginGesture:(NSString *)gesture result:(BOOL)equal {
    if (type == CircleViewTypeVerify) {
        if (equal) {
         _tip.text = @"请重新设置密码!";
            _lockView.type = CircleViewTypeSetting;
            
            //清空以前设置过的手势密码
            kUserDefaultSetValue(gestureOneSaveKey, @"");
            kUserDefaultSetValue(gestureFinalSaveKey, @"");
            kSynchronize;
            
        }else {
            _tip.text = @"请重新输入!";
            [_lockView.layer shake];
        }
    } else if (type == CircleViewTypeSetting) {
        if (equal) {
            _tip.text = @"密码设置成功!";
        } else {
            _tip.text = @"请重新输入!";
            [_lockView.layer shake];
        }
    }
}
@end
