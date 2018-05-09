//
//  BaseModel.h
//  GoldenField
//
//  Created by Chan on 2018/5/9.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject <NSCoding>

#pragma mark  -- 子类继承与BaseModel
-(id)modelToJson;

-(id)jsonToModel:(NSDictionary*)json;

@end
