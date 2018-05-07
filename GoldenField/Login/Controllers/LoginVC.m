//
//  LoginVC.m
//  GoldenField
//
//  Created by Macx on 2018/5/4.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "LoginVC.h"

@interface LoginVC ()

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
    self.view.backgroundColor = [UIColor orangeColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"暂不登录" style:UIBarButtonItemStylePlain target:self action:@selector(buttonAction:)];
    self.navigationItem.title = @"登录";
    //登录完成以后在数据库中存登录的用户信息 并将该用户的登录信息置为YES
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
