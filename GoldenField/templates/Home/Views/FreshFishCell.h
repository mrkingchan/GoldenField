//
//  FreshFishCell.h
//  GoldenField
//
//  Created by Chan on 2018/5/4.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FreshFishCell : UITableViewCell

-(void)setCellWithData:(id)model;

+ (NSString *)cellIdentifier;

@end
