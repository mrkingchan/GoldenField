//
//  LoginVC.m
//  GoldenField
//
//  Created by Chan on 2018/5/4.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "LoginVC.h"

@interface LoginVC () {
    UITextField *_inputs[2];
}

@end

@implementation LoginVC

-(instancetype)initWithLoginCompleteBlock:(void (^)(void))complete {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _complete = complete;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorOrange;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"暂不登录" style:UIBarButtonItemStylePlain target:self action:@selector(buttonAction:)];
    self.navigationItem.title = @"登录";
    //登录完成以后在数据库中存登录的用户信息 并将该用户的登录信息置为YES
    for (int i = 0; i < 2; i ++) {
        _inputs[i] = InsertTextFieldWithTextColor(self.view, self, CGRectMake(20, i == 0 ?50 :40 + 50 + 20, kScreenWidth - 40, 40), i == 0 ? @"":@"", kFontSize(14), 0, 1, [UIColor blackColor]);
        _inputs[i].backgroundColor = [UIColor whiteColor];
        _inputs[i].clipsToBounds = YES;
        _inputs[i].layer.cornerRadius = 5.0;
        _inputs[i].layer.borderColor = [UIColor blackColor].CGColor;
        _inputs[i].layer.borderWidth = 1.5;
    }
}

- (void)buttonAction:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    @weakify(self);
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        @strongify(self);
        if (self->_complete) {
            self->_complete();
        }
    }];
}
@end
