//
//  AppDelegate.m
//  GoldenField
//
//  Created by Chan on 2018/5/4.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "AppDelegate.h"
#import "MainVC.h"
#import "GuideHelpView.h"
#import "AppDelegate+Configuration.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "TouchVC.h"
#import <WXApiObject.h>
#import <WXApi.h>
#import <CommonCrypto/CommonDigest.h>
#import "ScreenShotView.h"
#import <UserNotifications/UserNotifications.h>
#import "LaunchVC.h"

@interface AppDelegate () <UNUserNotificationCenterDelegate,CircleViewDelegate,WXApiDelegate,WeiboSDKDelegate,UNUserNotificationCenterDelegate> {
    UIAlertController *_alertVC;
    NSMutableString *_messageStr;
    UIBackgroundTaskIdentifier _bgTaskId;
}
@end

@implementation AppDelegate

// MARK: - 程序入口
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    /*_window = [UIWindow new];
    _window.frame = [UIScreen mainScreen].bounds;
    _window.backgroundColor = [UIColor whiteColor];
    _window.rootViewController = [MainVC new];
    [_window makeKeyAndVisible];*/
    _window = InsertWindow([MainVC new]);
    //新手引导页
    if (DEBUG) {
        NSLog(@"DebugMode");
    } else {
        NSLog(@"ReleaseMode");
    }
    [self configureGuide];
    [self configureShare];
    [self configureCommonPushWithLanunchOptions:launchOptions];
//    [self verifyTouch];
    //注册http和https
    [NSURLProtocol wk_registerScheme:@"http"];
    [NSURLProtocol wk_registerScheme:@"https"];
//    [NSURLProtocol registerClass:[URLProtocol class]];

    /*UIView *subView = ({
     UIView*newView = [UIView new];
     newView.backgroundColor = kColorOrange;
     newView.clipToBounds = YES;
     newView.layer.cornerRadius = 5.0;
     newView;
     });*/
    [self checkUpdateInfo];
    
    _lockView = InsertView(_window, _window.bounds, kColorLightGray);
   PCCircleView *_gestureView = [[PCCircleView alloc] initWithType:CircleViewTypeVerify clip:YES arrow:YES];
    _gestureView.delegate = self;
    _gestureView.frame = CGRectMake(20, kScreenHeight / 2 - ((kScreenWidth - 40)/2), kScreenWidth - 40, kScreenWidth - 40);
    _tip = InsertLabel(_lockView, CGRectMake(0, _gestureView.top - 50, kScreenWidth, 30), 1, @"", kFontSize(15), kApperanceColor, NO);
    _tip.text = @"手势解锁";
    [_lockView addSubview:_gestureView];
    [_window sendSubviewToBack:_lockView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(snapShotAction) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
//    [[[NSThread alloc] initWithTarget:self selector:@selector(threadAction) object:nil] start];
    
    //远程推送打开
    if (launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]) {
        NSDictionary *info = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
        NSLog(@"remoteNoti = %@",info);
    } else if (launchOptions[UIApplicationLaunchOptionsLocalNotificationKey]) {
        //本地推送打开App
        UILocalNotification* localNoti = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
        NSLog(@"localNoti = %@",localNoti.userInfo);
    } else {
     
    }
    
    //配置推送
    [self configurePushWithApplication:application];
    //测试推送
    /*dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self fireNotificationWithContent:@{@"title":@"Chan",
                                            @"content":@"Chan",
                                            @"category":@"com.Chan.notificationCate"
                                            }];
    });*/
    
    return YES;
}

// MARK: - iOS10之后的本地推送
- (void)fireNotificationWithContent:(NSDictionary *)content {
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        __weak typeof(self) weaksSelf  = self;
        [center requestAuthorizationWithOptions:UNAuthorizationOptionAlert|UNAuthorizationOptionSound|UNAuthorizationOptionBadge
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                  if (!granted) {
                                      AppDelegate *strongSelf = weaksSelf;
                                      //swift的桥接文件，自动转换成OC的语法
                                      [self InsertAlerController:@"请前往设置打开通知权限" messageStr:nil alertStyle:UIAlertControllerStyleAlert button1Title:@"前往" button1Action:^(NSString * _Nonnull positiveStr) {
                                          
                                      } button2Title:@"取消"
                                                   button2Action:^(NSString * _Nonnull cancelStr) {
                                                       
                                                   } targetController: strongSelf->_window.rootViewController
                                       ];
                                  } else {
                                      
                                  }
                              }];
        
        //推送内容
        UNMutableNotificationContent *notiContent = [UNMutableNotificationContent new];
        notiContent.sound = [UNNotificationSound defaultSound];
        notiContent.title = content[@"title"];
        //附件
        notiContent.attachments = @[[UNNotificationAttachment attachmentWithIdentifier:@"Chan"
                                                                                   URL:[[NSBundle mainBundle]URLForResource:@"pushAttach" withExtension:@"png"] options:nil error:nil]];
        notiContent.badge = [NSNumber numberWithInteger:100];
        notiContent.userInfo = content;
        notiContent.subtitle = content[@"content"];
        notiContent.body = content[@"content"];
        
        //类别
        NSMutableArray *cates = [NSMutableArray new];
        for (int i = 0 ; i < 3; i  ++) {
            if (i == 0) {
                UNTextInputNotificationAction *inputAction = [UNTextInputNotificationAction actionWithIdentifier:@"inputIndentifier" title:@"输入" options:UNNotificationActionOptionForeground textInputButtonTitle:@"回复" textInputPlaceholder:@"请回复"];
                [cates addObject:inputAction];
            } else {
                UNNotificationAction *action = [UNNotificationAction actionWithIdentifier:[NSString stringWithFormat:@"actionIdentifier:%i",i] title: [NSString stringWithFormat:@"%@",i == 1 ? @"提交":@"取消"] options:i== 1 ? UNNotificationActionOptionAuthenticationRequired: UNNotificationActionOptionDestructive];
                [cates addObject:action];
            }
        }
        
        //类别
        UNNotificationCategory *cate = [UNNotificationCategory categoryWithIdentifier:@"com.Chan.notificationCate"
                                                                              actions:cates intentIdentifiers:@[@"1",@"2",@"3"] options:  UNNotificationCategoryOptionCustomDismissAction];
        [center setNotificationCategories:[NSSet setWithObject:cate]];
        
        //触发器
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.1 repeats:NO];
        notiContent.categoryIdentifier = @"com.Chan.notification";
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"Chan"
                                                                              content:notiContent trigger:trigger];
        
        //触发通知请求
        [center addNotificationRequest:request
                 withCompletionHandler:^(NSError * _Nullable error) {
                     if (!error) {
                         NSLog(@"触发通知成功!");
                     }
                 }];
        
    } else {
        UILocalNotification *localNotification = [UILocalNotification new];
        if (@available(iOS 8.2, *)) {
            localNotification.alertTitle = content[@"title"];
        } else {
        }
        localNotification.alertBody = content[@"content"];
        localNotification.alertLaunchImage = @"AppIcon";
    }
}

- (void)threadAction {
    while (true) {
        puts(__func__);
    }
}

// MARK: - 检测到截屏的事件响应
- (void)snapShotAction {
    NSLog(@"检测到截屏");
    UIImage *screeenShotImage = [UIImage imageWithData:[self dataWithScreenshotInPNGFormat]];
    //将图片写入沙盒
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSData *imageData = UIImagePNGRepresentation(screeenShotImage);
    //时间戳
    NSString *fileName = [NSString stringWithFormat:@"screenShot%0.f.png",[[NSDate date] timeIntervalSince1970]];
    
    [imageData  writeToFile:[documentPath stringByAppendingPathComponent:fileName] atomically:NO];
    
    [ScreenShotView screenShotViewWithScreenImage:screeenShotImage
                                         complete:^(UIImage *image) {
                                             
                                         }];
}

- (NSData *)dataWithScreenshotInPNGFormat {
    CGSize imageSize = CGSizeZero;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation))
        imageSize = [UIScreen mainScreen].bounds.size;
    else
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft) {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        }else if (orientation == UIInterfaceOrientationLandscapeRight) {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
        {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        }
        else
        {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return UIImagePNGRepresentation(image);
}
- (void)configureShare {
    [[UMSocialManager defaultManager] setUmSocialAppkey:kUmengAppKey];
    //分享
    //微信
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession
                                          appKey:kWeChatAppKey
                                       appSecret:kWechatAppSecretKey
                                     redirectURL:kBaseURL];
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatTimeLine
                                          appKey:kWeChatAppKey
                                       appSecret:kWechatAppSecretKey
                                     redirectURL:kBaseURL];
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatFavorite
                                          appKey:kWeChatAppKey
                                       appSecret:kWechatAppSecretKey
                                     redirectURL:kBaseURL];
    
    //QQ
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ
                                          appKey:kQQAppKey
                                       appSecret:kQQAppSecretKey
                                     redirectURL:kBaseURL];
    //QQ空间
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Qzone
                                          appKey:kQQZoneKey
                                       appSecret:kQQZoneSecretKey
                                     redirectURL:kBaseURL];
}
// MARK: - CircleViewDeletate

- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteLoginGesture:(NSString *)gesture result:(BOOL)equal {
    if (type == CircleViewTypeVerify) {
        if (equal) {
            [_window sendSubviewToBack:_lockView];
        } else {
            [_lockView.layer shake];
            _tip.text = @"请重新输入!";
        }
    }
}

- (void)circleView:(PCCircleView *)view type:(CircleViewType)type connectCirclesLessThanNeedWithGesture:(NSString *)gesture {
    NSLog(@"连接点少于需要!");
    _tip.text = @"连接点至少为4个!";
    [_lockView.layer shake];
}
/*
// MARK: - verifyTouchID
-(void)verifyTouch {
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
                    NSLog(@"TouchID 验证成功");
//                    [self->_window sendSubviewToBack:self->_touchIDView];
                });
            } else if(error){
//                [self->_window bringSubviewToFront:self->_touchIDView];
                switch (error.code) {
                    case LAErrorAuthenticationFailed:{
                        dispatch_main_async_safe(^{
                        NSLog(@"TouchID 验证失败");
                        });
                        break;
                    }
                    case LAErrorUserCancel:{
                        dispatch_main_async_safe(^{
                            NSLog(@"TouchID 被用户手动取消");
                        });
                    }
                        break;
                    case LAErrorUserFallback:{
                        dispatch_main_async_safe(^{
                            NSLog(@"用户不使用TouchID,选择手动输入密码");
                        });
                    }
                        break;
                    case LAErrorSystemCancel:{
                        dispatch_main_async_safe(^{
                            NSLog(@"TouchID 被系统取消 (如遇到来电,锁屏,按了Home键等)");
                        });
                    }
                        break;
                    case LAErrorPasscodeNotSet:{
                        dispatch_main_async_safe(^{
                            NSLog(@"TouchID 无法启动,因为用户没有设置密码");
                        });
                    }
                        break;
                    case LAErrorTouchIDNotEnrolled:{
                        dispatch_main_async_safe(^{
                            NSLog(@"TouchID 无法启动,因为用户没有设置TouchID");
                        });
                    }
                        break;
                    case LAErrorTouchIDNotAvailable:{
                        dispatch_main_async_safe(^{
                            NSLog(@"TouchID 无效");
                        });
                    }
                        break;
                    case LAErrorTouchIDLockout:{
                        dispatch_main_async_safe(^{
                            NSLog(@"TouchID 被锁定(连续多次验证TouchID失败,系统需要用户手动输入密码)");
                        });
                    }
                        break;
                    case LAErrorAppCancel:{
                        dispatch_main_async_safe(^{
                            NSLog(@"当前软件被挂起并取消了授权 (如App进入了后台等)");
                        });
                    }
                        break;
                    case LAErrorInvalidContext:{
                        dispatch_main_async_safe(^{
                            NSLog(@"当前软件被挂起并取消了授权 (LAContext对象无效)");
                        });
                    }
                        break;
                    default:
                        break;
                }
            }
        }];
    } else {
        NSLog(@"当前设备不支持TouchID");
    }
}
 */

// MARK:  -- checkUpdateInfo
- (void)checkUpdateInfo {
    __weak typeof(self)weakSelf = self;
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",kAppID]] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        AppDelegate *strongSelf = weakSelf;
        if (!error) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            if ([dic[@"results"] count]) {
                NSDictionary *results = dic[@"results"][0];
                //App更新
                if ([results[@"version"] floatValue] > [AppVersion floatValue]) {
                    NSString *messageStr = [[results[@"releaseNotes"]  componentsSeparatedByString:@"。"]firstObject];
                    NSArray *titleArray = [messageStr componentsSeparatedByString:@"\n"];
                    NSMutableString *newStr = [NSMutableString new];
                    [newStr appendString:@" \n"];
                    for (NSString *subStr in titleArray) {
                        [newStr appendFormat:@"%@\n",subStr];
                    }
                    strongSelf->_messageStr = newStr;
                    //更新弹框
                    strongSelf->_alertVC = [UIAlertController alertControllerWithTitle:@"应用有新版本" message:newStr preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        //更新跳转 这里跳转的url是中文转码的url
                        NSString *downloadURL = @"https://itunes.apple.com/us/app/%E4%BA%BA%E6%89%8D%E8%B5%A2%E8%A1%8C/id1334606367?l=zh&ls=1&mt=8";
                        NSURL *appStoreURL = [NSURL URLWithString:downloadURL];
                        if ([[UIApplication sharedApplication] canOpenURL:appStoreURL]) {
                            //跳转appstore
                            [[UIApplication sharedApplication] openURL:appStoreURL];
                        }
                    }];
                    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"下次" style:UIAlertActionStyleDefault handler:nil];
                    [strongSelf->_alertVC addAction:action1];
                    [strongSelf-> _alertVC addAction:action2];
                    [strongSelf runtimeProperty];
                    dispatch_main_async_safe(^{
                        [[UIApplication sharedApplication].keyWindow.rootViewController  presentViewController:strongSelf->_alertVC animated:YES completion:nil];
                    });
                }
            }
        } else {
            NSLog(@"update Error = %@",error.localizedDescription);
        }
    }]resume];
}

// MARK:  -- runtime method to change the UIAlertController property
- (void)runtimeProperty {
    unsigned int count = 0;
    Ivar *property = class_copyIvarList([UIAlertController class], &count);
    for (int i = 0; i < count; i++) {
        Ivar var = property[i];
        const char *name = ivar_getName(var);
        const char *type = ivar_getTypeEncoding(var);
        NSLog(@"%s =====property========== %s",name,type);
    }
    Ivar message = property[2];
    
    NSMutableAttributedString *newStr = [[NSMutableAttributedString alloc]initWithString:_messageStr attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.firstLineHeadIndent = 30;
    paragraph.paragraphSpacing = 7.0;
    paragraph.alignment = 0;
    [newStr setAttributes:@{NSParagraphStyleAttributeName:paragraph,NSFontAttributeName:[UIFont systemFontOfSize:14],} range:NSMakeRange(0, _messageStr.length)];
    object_setIvar(_alertVC, message, newStr);
    //    object_setIvar(_alert, message, paragraph);
}

/**
 构建viewController

 @param className 类名
 @param titleStr 标题
 @param normalImage 正常image
 @param selectedImage 选中image
 @return viewController
 */
-(UIViewController *)viewControllerWithClass:(_Nonnull Class)className
                                    title:(NSString *)titleStr
                                 normalImage:(UIImage *)normalImage
                               selectedImage:(UIImage *)selectedImage {
    UIViewController *viewController = [className new];
    viewController.title = titleStr;
    if (kiOSVersion >=7.0) {
        UITabBarItem  *item = [[UITabBarItem alloc] initWithTitle:titleStr
                                                            image:[normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        viewController.tabBarItem = item;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [viewController.tabBarItem setFinishedSelectedImage:[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] withFinishedUnselectedImage:[normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
#pragma clang diagnostic pop
    }
    return viewController;
}

- (void)loadDataWithParamters:(id)paramters httpMethod:(NSString *)methodStr sucess:(void (^)(id responseData))sucess failure:(void (^)(NSString *))failure {
    
    if (isTrueEnviroment) {
        //发布
        //使用HttpClient
        [NetTool innerRequestWithHttpMethod:POST
                                     urlStr:kBaseURL
                                     params:paramters
                                     target:[UIApplication sharedApplication].keyWindow.rootViewController
                                     sucess:^(id responseObject) {
                                         
                                     }
                                    failure:^(NSString *errorStr) {
                                        
                                    }];
    } else {
        //使用默认session
        [[[NSURLSession sharedSession] dataTaskWithURL:kURL(kBaseURL)
                                     completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                         if (!error) {
                                             id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                                             if (json) {
                                                 if (sucess) {
                                                     sucess(json);
                                                 }
                                             }
                                         } else {
                                             NSString *errorStr = error.localizedDescription;
                                             if (failure) {
                                                 failure(errorStr);
                                             }
                                         }
                                     }]resume];
    }
}
// MARK:  -- 推送设置
- (void)configureCommonPushWithLanunchOptions:(NSDictionary*)launchOptions {
    //推送
    UMessageRegisterEntity *entity = [UMessageRegisterEntity new];
    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionSound|UMessageAuthorizationOptionAlert;
    if (@available(iOS 10.0, *)) {
        [UNUserNotificationCenter currentNotificationCenter].delegate=self;
    }
    
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        //授权
        if (granted) {
            
        } else {
            
        }
    }];
}

// MARK:  -- 引导页
- (void)configureGuide {
    NSMutableArray *images = [NSMutableArray new];
    for (int i = 0; i < 3; i ++) {
        NSString *imageName = [NSString stringWithFormat:@"%i",i +1];
        /*UIImage *image = kIMAGE(imageName);
        [images addObject:image];*/
        [images addObject:imageName];
    }
    if ([kUserDefaultValueForKey(@"guidePass") integerValue]!=1) {
        [GuideHelpView guidehelpViewWithImageArray:images complete:^{
            kUserDefaultSetValue(@"guidePass", @(0));
            kSynchronize;
            [AdvertiseView advertiseVieWithURL:kBaseURL showSeconds:4.0];
        }];
    }
}

// MARK:  -- 交互推送
- (void)configureInteractPushWithLaunchOptions:(NSDictionary *)launchOptions  {
    UMessageRegisterEntity * entity = [UMessageRegisterEntity new];
    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionAlert|UMessageAuthorizationOptionSound;
    if (kiOSVersion>=8 && kiOSVersion<10) {
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title=@"打开应用";
        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2_identifier";
        action2.title=@"忽略";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        UIMutableUserNotificationCategory *actionCategory1 = [[UIMutableUserNotificationCategory alloc] init];
        actionCategory1.identifier = @"category1";//这组动作的唯一标示
        [actionCategory1 setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        NSSet *categories = [NSSet setWithObjects:actionCategory1, nil];
        entity.categories = categories;
    }
    //如果要在iOS10显示交互式的通知，必须注意实现以下代码
    if (kiOSVersion>=10) {
        UNNotificationAction *action1_ios10 = [UNNotificationAction actionWithIdentifier:@"action1_identifier" title:@"打开应用" options:UNNotificationActionOptionForeground];
        UNNotificationAction *action2_ios10 = [UNNotificationAction actionWithIdentifier:@"action2_identifier" title:@"忽略" options:UNNotificationActionOptionForeground];
        
        //UNNotificationCategoryOptionNone
        //UNNotificationCategoryOptionCustomDismissAction  清除通知被触发会走通知的代理方法
        //UNNotificationCategoryOptionAllowInCarPlay       适用于行车模式
        UNNotificationCategory *category1_ios10 = [UNNotificationCategory categoryWithIdentifier:@"category1" actions:@[action1_ios10,action2_ios10]   intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
        NSSet *categories = [NSSet setWithObjects:category1_ios10, nil];
        entity.categories=categories;
    }
    [UNUserNotificationCenter currentNotificationCenter].delegate=self;
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
    }];
}

// MARK: - 配置推送
- (void)configurePushWithApplication:(UIApplication *)application {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        //iOS10特有
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        // 必须写代理，不然无法监听通知的接收与点击
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                // 点击允许
                NSLog(@"注册成功");
                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                    NSLog(@"%@", settings);
                }];
            } else {
                // 点击不允许
                NSLog(@"注册失败");
            }
        }];
    }else if ([[UIDevice currentDevice].systemVersion floatValue] >8.0){
        //iOS8 - iOS10
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:nil]];
        
    }else if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0) {
        //iOS8系统以下
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
    }
    // 注册获得device Token
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"remote: %@", userInfo);
    //回调
    completionHandler(UIBackgroundFetchResultNewData);
    //语音播报
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:userInfo[@"aps"][@"alert"]];
    AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc] init];
    [synth speakUtterance:utterance];
}

// MARK:  -- touchPress
-(void)buildShorcutItems API_AVAILABLE(ios(9.0)){
    NSMutableArray *items = [NSMutableArray new];
    NSArray *types = @[@(UIApplicationShortcutIconTypeDate),
                       @(UIApplicationShortcutIconTypeHome),
                       @(UIApplicationShortcutIconTypeTask),
                       @(UIApplicationShortcutIconTypeLocation),
                       @(UIApplicationShortcutIconTypeLove)];
    for (int i = 0 ; i < 5; i ++) {
        UIApplicationShortcutIcon *icon = [UIApplicationShortcutIcon iconWithType:[types[i] integerValue]];
        UIApplicationShortcutItem *item = [[UIApplicationShortcutItem alloc] initWithType:@"" localizedTitle:[NSString stringWithFormat:@"title%i",i  + 1] localizedSubtitle:[NSString stringWithFormat:@"subTitle%i",i + 1] icon:icon userInfo:@{@"item":@(i)}];
        [items addObject:item];
    }
    [UIApplication sharedApplication].shortcutItems = items;
}

// MARK:  -- UNUserNotificationCenterDelegate ios10 以上的推送接收方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler  API_AVAILABLE(ios(10.0)){
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //APNS走远程推送
        [UMessage setAutoAlert:NO];
        //应用处于前台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
    } else {
        //应用处于前台时的本地推送接受
    }
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    NSLog(@"notiUserInfo = %@",userInfo);
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        [UMessage didReceiveRemoteNotification:userInfo];
    } else if ([response.notification.request.trigger isKindOfClass:[UNTimeIntervalNotificationTrigger class]]){
        //定时推送
        //应用处于后台时的本地推送接受
        //判断点击按钮
        NSString *actionIdentifier = response.actionIdentifier;
        puts(__func__);
        NSLog(@"你点击的是%@",actionIdentifier);
        //根据idnntifier来判断点击的是哪个按钮
        if ([actionIdentifier isEqualToString:@"inputIndentifier"]) {
            //输入
        } else if ([actionIdentifier isEqualToString:@"actionIdentifier:1"]) {
            //提交
        } else if ([actionIdentifier isEqualToString:@"actionIdentifier2"]) {
            //取消
        }
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [UMessage registerDeviceToken:deviceToken];
    NSString *token = [[NSString alloc] initWithData:deviceToken encoding:NSUTF8StringEncoding];
    if (DEBUG) {
        NSLog(@"token = %@",token);
    }
}

///ios10以下的消息接收
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [UMessage didReceiveRemoteNotification:userInfo];
    if (DEBUG) {
        NSLog(@"接收到的推送消息体:%@",userInfo);
    }
}

// MARK: -处理三方跳转
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if ([url.host rangeOfString:@"safePay"].length) {
       //支付宝支付
        return YES;
    } else if (@available(iOS 9.0, *)) {
        if ([options[UIApplicationOpenURLOptionsSourceApplicationKey] isEqualToString:@"com.tecent.xin"] && [url.absoluteString rangeOfString:@"pay"].length) {
            //微信支付
            return YES;
        }else if ([url.absoluteString rangeOfString:kWeChatAppKey].length) {
            //微信分享
            return [WXApi handleOpenURL:url delegate:self];
        } else if ([url.absoluteString rangeOfString:kSinaAppKey].length) {
            //新浪
            return [WeiboSDK handleOpenURL:url delegate:self];
        }
    } else {
        
    }
    return YES;
}

- (void)viewDidLoadMethod {
    NSString *cmdStr = NSStringFromSelector(_cmd);
    if ([cmdStr rangeOfString:@"location"].location!= NSNotFound) {
        
    }
}
// MARK: - decrepted Method
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if ([url.host rangeOfString:@"safePay"].length) {
        return YES;
    } else if ([url.absoluteString rangeOfString:@"pay"].length) {
        //微信支付
        return [WXApi handleOpenURL:url delegate:self];
    } else if ([url.absoluteString rangeOfString:kWeChatAppKey].length) {
        //分享
        return [WXApi handleOpenURL:url delegate:self];
    } else if ([url.absoluteString rangeOfString:kSinaAppKey].length) {
        //新浪微博分享
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    return YES;
}

// MARK: - 3D Touch Action点击事件
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler  API_AVAILABLE(ios(9.0)){
    if (DEBUG) {
        NSLog(@"您点击的是%@",shortcutItem.localizedTitle);
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
//    [AdvertiseView advertiseVieWithURL:@"http://www.baidu.com" showSeconds:4.0];
    
    //支持touchID
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_8_0 && [[LAContext new] canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]) {
        application.keyWindow.rootViewController = [TouchVC new];
    }
    //手势解锁
    if ([PCCircleViewConst getGestureWithKey:gestureFinalSaveKey].length) {
        //有手势
        [_window bringSubviewToFront:_lockView];
    }
}

// MARK: - WXApiDelegate
-(void) onResp:(BaseResp*)resp {
    if ([resp isKindOfClass:[WXNontaxPayResp class]]) {
        WXNontaxPayResp *payResp = (WXNontaxPayResp *)resp;
        if (payResp.errCode == 0 ) {
            //errcode: 0成功支付 -2取消支付 -1其他原因
            if (DEBUG) {
                NSLog(@"支付结果:%@",payResp.errStr);
            }
            //通知支付的页面 方便其返回并刷新订交易单页面的状态
            [[NSNotificationCenter defaultCenter] postNotificationName:kWeChatPaySucessNotification object:nil];
        }
    }
}

// MARK: - WeiboSDKDelegate,因为都是requiredMethod 为避免警告，这连个代理方法最好bestAttemptContent最好都写上
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    if (response.statusCode == 0) {
        iToastText(@"分享成功！");
    } else {
        iToastText(@"分享失败！");
    }
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
}

// MARK: -  weChatPayInfo中的数据是调用统一下单API之后返回的数据(这个是后台返回来的数据,一般的签名加密参数大多数后台签名然后返回给移动端使用，这里使用的是移动端自己签名)
- (void)wxPay:(NSDictionary *)weChatPayInfo {
    time_t now;
    time(&now);
    NSString *timestamp = [NSString stringWithFormat:@"%ld",now];
    //随机串
    NSString *noncestr = [self md5:timestamp];
    NSDictionary *dict = @{
                           @"appid":weChatPayInfo[@"appId"],
                           @"noncestr":noncestr,
                           @"package":@"Sign=WXPay",
                           @"partnerid":weChatPayInfo[@"partnerId"],
                           @"prepayid":weChatPayInfo[@"prepayId"],
                           @"timestamp":timestamp
                           };
    NSMutableString *contentString = [NSMutableString string];
    NSArray *keys = [dict allKeys];
    // 按照ASCII码排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    // 拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (![dict[categoryId] isEqualToString:@""]&&![dict[categoryId] isEqualToString:@"key"]&&![dict[categoryId] isEqualToString:@"sign"]) {
            [contentString appendFormat:@"%@=%@&",categoryId,dict[categoryId]];
        }
    }
    // 添加商户key字段
    NSString *secretkey = @"1K2222ILTKCH33CQ4444SI5ZNMTM66VS";
    [contentString appendFormat:@"key=%@",secretkey];
    // sign签名加密
    NSString *md5Sign = [self md5:contentString];
    // 支付参数
   /* PayReq *req = [[PayReq alloc] init];
    req.openID = weChatPayInfo[@"appId"];
    req.partnerId = weChatPayInfo[@"partnerId"];
    req.prepayId = weChatPayInfo[@"prepayId"];
    req.package = @"Sign=WXPay";
    req.nonceStr = noncestr;
    req.timeStamp = [timestamp intValue];
    req.sign = md5Sign;
    [WXApi sendReq:req];*/
}

- (void)applicationWillResignActive:(UIApplication *)application {
    if (_bgTaskId == UIBackgroundTaskInvalid) {
        _bgTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:NULL];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    if (_bgTaskId != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:_bgTaskId];
        _bgTaskId = UIBackgroundTaskInvalid;
    }
}

- (UIBackgroundTaskIdentifier)backgroundPlayerID:(UIBackgroundTaskIdentifier)backTaskId {
    // 1. 设置并激活音频会话类别
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error: nil];
    [session setActive:YES error:nil];
    // 2. 允许应用程序接收远程控制
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    // 3. 设置后台任务ID
    UIBackgroundTaskIdentifier newTaskId = UIBackgroundTaskInvalid;
    newTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    if (newTaskId != UIBackgroundTaskInvalid && backTaskId != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:backTaskId];
    }
    return newTaskId;
}

// MARK: - md5签名加密 不过在App签名加密没有在后台签名安全 这里只是模拟支付签名参数
- (NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr,(unsigned int)strlen(cStr),digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i ++) {
        [output appendFormat:@"%02X",digest[i]];
    }
    return output;
}

// MARK: -  方法交换
+ (void)swizzleClassMethodWithClass:(Class)originClass
                     originSelector:(SEL)originSelector
                    replaceSelector:(SEL)replaceSelector {
    Method originMethod  = class_getInstanceMethod(originClass, originSelector);
    Method replaceMethod = class_getInstanceMethod(originClass, replaceSelector);
    BOOL addSuccess  = class_addMethod(originClass,
                                       replaceSelector,
                                       method_getImplementation(replaceMethod), method_getTypeEncoding(replaceMethod));
    if (addSuccess) {
        class_replaceMethod(originClass,
                            replaceSelector,
                            method_getImplementation(originMethod),
                            method_getTypeEncoding(originMethod));
    } else {
        method_exchangeImplementations(originMethod, replaceMethod);
    }
}

+ (void)swizzleClassMethodWithClass:(Class)originClass
                      originSlector:(SEL)originSelector
                    replaceSelector:(SEL)replacceSelector {
    Method originMethod = class_getClassMethod(originClass, originSelector);
    Method replaceMethod = class_getClassMethod(originClass, replacceSelector);
    
     BOOL addsucces = class_addMethod(originClass,
                                      replacceSelector,
                                      method_getImplementation(replaceMethod),
                                      method_getTypeEncoding(replaceMethod));
    
    if (addsucces) {
        //exchange the Method each other
        class_replaceMethod(originClass, replacceSelector, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
    } else {
        method_exchangeImplementations(originMethod, replaceMethod);
    }
}
@
end
