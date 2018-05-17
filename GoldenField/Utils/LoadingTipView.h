//
//  LoadingTipView.h
//  GoldFullOfField
//
//  Created by Macx on 2018/5/15.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingTipView : UIView

+ (LoadingTipView *)shareInstance;

/*+ (LoadingTipView  *)loading;

+ (LoadingTipView *)loadFail;

+ (LoadingTipView *)loadSucess;
 */

- (void)loading;
- (void)loadingFail;
- (void)loadSucess;

@end
