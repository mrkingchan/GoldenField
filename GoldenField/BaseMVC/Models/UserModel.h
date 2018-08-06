//
//  UserModel.h
//  GoldenField
//
//  Created by Chan on 2018/5/4.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : BaseModel

@property(nonatomic,assign) BOOL isLogin;

@property(nonatomic,strong)NSString *userName;

@property(nonatomic,strong)NSString *passWord;

@end

