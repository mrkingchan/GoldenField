//
//  NNValidationCodeView.m
//  NNValidationCodeView
//
//  Created by edz on 2017/7/17.
//  Copyright © 2017年 刘朋坤. All rights reserved.
//

#import "NNValidationCodeView.h"
#define NNCodeViewHeight self.frame.size.height

@interface NNValidationCodeView()<UITextFieldDelegate>

/// 存放 label 的数组
@property (nonatomic, strong) NSMutableArray *labelArr;
/// label 的数量
@property (nonatomic, assign) NSInteger labelCount;
/// label 之间的距离
@property (nonatomic, assign) CGFloat labelDistance;
/// 输入文本框
@property (nonatomic, strong) NNTextField *codeTextField;

@end

@implementation NNValidationCodeView

// MARK: - initialized Method
- (instancetype)initWithFrame:(CGRect)frame
                andLabelCount:(NSInteger)labelCount
             andLabelDistance:(CGFloat)labelDistance {
    self = [super initWithFrame:frame];
    if (self) {
         _labelArr = [NSMutableArray array];
        self.backgroundColor = [UIColor whiteColor];
        self.labelCount = labelCount;
        self.labelDistance = labelDistance;
        self.changedColor = [UIColor redColor];
        self.defaultColor = [UIColor blackColor];
        [self setUI];
    }
    return self;
}

// MARK: - setUI
- (void)setUI {
    _codeTextField = [[NNTextField alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, NNCodeViewHeight)];
    _codeTextField.backgroundColor = [UIColor clearColor];
    _codeTextField.textColor = [UIColor clearColor];
    _codeTextField.tintColor = [UIColor clearColor];
    _codeTextField.delegate = self;
    _codeTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    _codeTextField.layer.borderColor = [[UIColor grayColor] CGColor];
    [_codeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:_codeTextField];
    
    
    CGFloat labelX;
    CGFloat labelY = 0;
    
    CGFloat labelWidth = _codeTextField.frame.size.width / self.labelCount;
    CGFloat sideLength = labelWidth < NNCodeViewHeight ? labelWidth : NNCodeViewHeight;
    for (int i = 0; i < self.labelCount; i++) {
        if (i == 0) {
            labelX = 0;
        } else {
            labelX = i * (sideLength + self.labelDistance);
        }
        //创建N个圆形label
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, sideLength, sideLength)];
        [self addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.borderColor = [UIColor blackColor].CGColor;
        label.layer.borderWidth = 1;
        label.layer.cornerRadius = sideLength / 2;
        [self.labelArr addObject:label];
    }
}

// MARK: - UITextFieldDelegate
- (void)textFieldDidChange:(UITextField *)textField {
    NSInteger i = textField.text.length;
    if (i == 0) {
        ((UILabel *)[self.labelArr objectAtIndex:0]).text = @"";
        ((UILabel *)[self.labelArr objectAtIndex:0]).layer.borderColor = _defaultColor.CGColor;
    } else {
        ((UILabel *)[self.labelArr objectAtIndex:i - 1]).text = [NSString stringWithFormat:@"%C", [textField.text characterAtIndex:i - 1]];
        ((UILabel *)[self.labelArr objectAtIndex:i - 1]).layer.borderColor = _changedColor.CGColor;
        ((UILabel *)[self.labelArr objectAtIndex:i - 1]).textColor = _changedColor;
        if (self.labelCount > i) {
            ((UILabel *)[self.labelArr objectAtIndex:i]).text = @"";
            ((UILabel *)[self.labelArr objectAtIndex:i]).layer.borderColor = _defaultColor.CGColor;
        }
    }
    if (self.codeBlock) {
        self.codeBlock(textField.text);
    }
}

// MARK: - 允许TextField编辑
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        //不能再输入
        [textField resignFirstResponder];
        return NO;
    } else if (string.length == 0) {
        return YES;
    } else if (textField.text.length >= self.labelCount) {
        //不准再输入
        return NO;
    } else {
        return YES;
    }
}

@end

@implementation NNTextField

/// 重写 UITextFiled 子类, 解决长按复制粘贴的问题
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}

@end
