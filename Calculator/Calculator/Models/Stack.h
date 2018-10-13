//
//  Stack.h
//  Calculator
//
//  Created by 小哲的DELL on 2018/9/28.
//  Copyright © 2018年 小哲的DELL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stack : NSObject{
    NSMutableArray *numberStack;
    NSMutableArray *symbolStack;
    int numberTop;
    int symbolTop;
    int flag; //1时为运算符，0时为数字，2为左右括号，3为=，4为AC
}

@property(nonatomic, strong) NSMutableArray *numberStack;
@property(nonatomic, strong) NSMutableArray *symbolStack;
@property(nonatomic) int numberTop;
@property(nonatomic) int symbolTop;
@property(nonatomic) int flag;   //1+-*/,2(),3=,4AC,0数,5小数点
@property(nonatomic) int over;  //判断运算是否出错,1正常，0出错
@property(nonatomic) int pointFlag; //为0时没有小数点，wei1时有小数点
@property(nonatomic) int k;     //k为小数点后位数
@property(nonatomic) int last;  //上一个是字符还是数字，1+-*/,2(),3=,4AC,0数

- (void)initStack;
- (void)inStack:(NSString *) str;
- (int)isSymbol:(NSString *) str;

@end
