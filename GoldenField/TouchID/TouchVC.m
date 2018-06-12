//
//  TouchVC.m
//  GoldenField
//
//  Created by Chan on 2018/5/22.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "TouchVC.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "MainVC.h"
@interface TouchVC () {
    UIImageView *_touchIcon;
    UILabel *_tip;
}

@end

@implementation TouchVC

// MARK: - viewController LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorWhite;
    _touchIcon = InsertImageView(self.view, CGRectMake(kScreenWidth / 2 - 30, self.view.height / 2 - 30, 60, 60), kIMAGE(@"touch"));
    _touchIcon.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchAction)];
    [_touchIcon addGestureRecognizer:tap];
    
    _tip = InsertLabel(self.view, CGRectMake(0, _touchIcon.top - 60, kScreenWidth, 40), 1, @"点击指纹图标，按住home键解锁", kFontSize(15), kColorRed, NO);
    _tip.numberOfLines = 0;
}

// MARK: - touchAction
- (void)touchAction {
    if (NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_8_0) {
        NSLog(@"系统版本不支持TouchID");
        return;
    }
    LAContext *context = [LAContext new];
    context.localizedFallbackTitle = @"输入密码";
    if (@available(iOS 10.0, *)) {
        context.localizedCancelTitle = @"取消";
    } else {
        // Fallback on earlier versions
    }
    
    NSError *error = nil;
    @weakify(self);
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        //可以验证指纹
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"通过Home键验证已有手机指纹" reply:^(BOOL success, NSError * _Nullable error) {
            @strongify(self);
            if (success) {
                //验证成功
                dispatch_main_async_safe(^{
                self->_tip.text = @"TouchID 验证成功";
                    [UIApplication sharedApplication].keyWindow.rootViewController = [MainVC new];
                });
            } else if(error){
                NSString *tipStr = @"";
                
                switch (error.code) {
                    case LAErrorAuthenticationFailed:{
                           tipStr =  @"TouchID 验证失败";
                        break;
                    }
                    case LAErrorUserCancel:{
                           tipStr = @"TouchID 被用户手动取消";
                    }
                        break;
                    case LAErrorUserFallback:{
                        
                        tipStr = @"用户不使用TouchID,选择手动输入密码";
                    }
                        break;
                    case LAErrorSystemCancel:{
                           tipStr = @"TouchID 被系统取消 (如遇到来电,锁屏,按了Home键等)";
                    }
                        break;
                    case LAErrorPasscodeNotSet:{
                           tipStr = @"TouchID 无法启动,因为用户没有设置密码";
                    }
                        break;
                    case LAErrorTouchIDNotEnrolled:{
                           tipStr = @"TouchID 无法启动,因为用户没有设置TouchID";
                    }
                        break;
                    case LAErrorTouchIDNotAvailable:{
                           tipStr = @"TouchID 无效";
                    }
                        break;
                    case LAErrorTouchIDLockout:{
                           tipStr = @"TouchID被锁定(请锁定屏幕,输入您手机的密码,然后再试一次！)";
                    }
                        break;
                    case LAErrorAppCancel: {
                           tipStr = @"当前软件被挂起并取消了授权 (如App进入了后台等)";
                    }
                        break;
                    case LAErrorInvalidContext:{
                       tipStr = @"当前软件被挂起并取消了授权 (LAContext对象无效)";
                    }
                        break;
                    default:
                        break;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                   self-> _tip.text = tipStr;
                    [self.view.layer shake];
                });
            }
        }];
    } else {
        NSLog(@"当前设备不支持TouchID");
    }
}

// MARK: - memory management
- (void)dealloc {
    if (_tip) {
        _tip = nil;
    }
    if (_touchIcon) {
        _touchIcon = nil;
    }
}
@end
