//
//  LoginVC.m
//  GoldenField
//
//  Created by Chan on 2018/5/4.
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
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 2.0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        
    });
    dispatch_resume(timer);
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
