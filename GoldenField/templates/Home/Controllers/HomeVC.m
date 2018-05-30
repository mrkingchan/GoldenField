//
//  HomeVC.m
//  GoldenField
//
//  Created by Chan on 2018/5/4.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "HomeVC.h"
#import "FreshFishCell.h"
#import "ScanVC.h"

@interface HomeVC () <UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate> {
    UIBarButtonItem *_scan;
    SDCycleScrollView *_bannerView;
    UITableView *_tableView;
}

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"一亩黄金";
    _bannerView = [SDCycleScrollView  cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 200) delegate:self placeholderImage:kIMAGE(@"1")];
    _bannerView.imageURLStringsGroup = @[@"1",@"2",@"3",@"1",@"2",@"3"];
    /*//tableView初始化
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.view.height) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FreshFishCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[FreshFishCell cellIdentifier]];
    [self.view addSubview:_tableView];
    _tableView.tableHeaderView = _bannerView;
    _tableView.backgroundColor = [UIColor whiteColor];
    
    ///下拉刷新
    @weakify(self);
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        @strongify(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self->_tableView.header endRefreshing];
        });
    }];*/
    self.showRefreshHeader = YES;
    self.tableView.tableHeaderView = _bannerView;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FreshFishCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[FreshFishCell cellIdentifier]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:kIMAGE(@"scan")   style:UIBarButtonItemStylePlain target:self action:@selector(buttonAction:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"share" style:UIBarButtonItemStylePlain target:self action:@selector(share)];
}

- (void)share {
    NSMutableArray *titles = [NSMutableArray new];
    NSMutableArray *images = [NSMutableArray new];
    for (int i = 0; i < 8; i ++) {
        [titles addObject:@"微信朋友圈"];
        [images  addObject:kIMAGE(@"friendCircle")];
    }
    /*[SharePanel sharePanelWithTitleArray:titles
                              ImageArray:images complete:^(NSString *selctedItem, NSInteger index) {
                                  
                                  if (DEBUG) {
                                      NSLog(@"你点击的是%@ index = %zd",selctedItem,index);
                                  }
                                  UMSocialPlatformType type  = 0;
                                  switch (index) {
                                      case 0:
                                          type = UMSocialPlatformType_WechatSession;
                                          break;
                                      case 1:
                                          type = UMSocialPlatformType_WechatTimeLine;
                                          break;
                                      case 2:
                                          type = UMSocialPlatformType_QQ;
                                          break;
                                      default:
                                          break;
                                  }
                                  
                                  UMSocialMessageObject *messageObject = [UMSocialMessageObject new];
                                  messageObject.text = @"xxx";
                                  messageObject.shareObject = [UMShareObject shareObjectWithTitle:@"xxx" descr:@"xxx" thumImage:kIMAGE(@"tabbar_1")];
                                  
                                  [[UMSocialManager defaultManager] shareToPlatform:type
                                                                      messageObject:messageObject currentViewController:self
                                                                         completion:^(id result, NSError *error) {
                                                                             if (error) {
                                                                                 
                                                                             } else {
                                                                                 if ([result isKindOfClass:[UMSocialShareResponse class]]) {
                                                                                     //分享结果
                                                                                     NSLog(@"shareResult = %@",((UMSocialShareResponse *) result).message);
                                                                                     
                                                                                 }
                                                                             }
                                                                         }];
                              }];*/
    
    [ShareView shareView:titles imageArray:images complete:^(NSString * _Nonnull selctedItem, NSInteger index) {
        
    }];
    
    /*
    //友盟的分享面板
    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
    NSMutableArray *items = [NSMutableArray new];
    //预定义平台设置 要上架App必须要进行这项设置
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        [items addObject:@(UMSocialPlatformType_WechatFavorite)];
        [items addObject:@(UMSocialPlatformType_WechatTimeLine)];
        [items addObject:@(UMSocialPlatformType_WechatSession)];
    }
    [UMSocialUIManager setPreDefinePlatforms:items];
    
    [UMSocialUIManager  showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        
    }];*/
    
}
#pragma mark  -- private Method
- (void)buttonAction:(id)sender {
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"simulator can't support Camera!");
#elif TARGET_OS_IPHONE
    [self.navigationController pushViewController:[ScanVC new] animated:YES];
#endif
    
}

#pragma mark  -- UITableViewDataSource&Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FreshFishCell *cell = [tableView dequeueReusableCellWithIdentifier:[FreshFishCell cellIdentifier]];
    cell.backgroundColor = kRandomColor;
    /*if (!cell) {
        cell = [[FreshFishCell alloc] initWithStyle:0 reuseIdentifier:[FreshFishCell cellIdentifier]];
    }*/
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0 :10;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    WebVC *nextVC = [[WebVC alloc] initWithUrlString:@"http://www.baidu.com"];
    [self.navigationController pushViewController:nextVC animated:YES];
}

#pragma mark  -- memerory management
- (void)dealloc {
    if (self.tableView) {
        self.tableView.delegate = nil;
        self.tableView.dataSource = nil;
        self.tableView = nil;
    }
    if (self.dataArray) {
        self.dataArray = nil;
    }
}
@end
