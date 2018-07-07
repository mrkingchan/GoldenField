//
//  CodeVerifyVC.m
//  GoldenField
//
//  Created by Macx on 2018/6/1.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "CodeVerifyVC.h"
#import "NNValidationCodeView.h"

@interface CodeVerifyVC () {
    NNValidationCodeView *_codeView;
}

@end

@implementation CodeVerifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"验证码";
    
    //codeView
    _codeView = [[NNValidationCodeView alloc] initWithFrame:CGRectMake(40,kScreenHeight / 2 - 25,kScreenWidth - 80 ,50) andLabelCount:6 andLabelDistance:10];
    _codeView.changedColor = [UIColor orangeColor];
    __weak typeof(self)weakSelf = self;
    _codeView.codeBlock = ^(NSString *codeString) {
        __strong CodeVerifyVC *strongSelf = weakSelf;
        if (codeString.length == 6) {
            //6位验证码
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }
    };
    [self.view addSubview:_codeView];
}
@end
