//
//  Stack.m
//  Calculator
//
//  Created by 小哲的DELL on 2018/9/28.
//  Copyright © 2018年 小哲的DELL. All rights reserved.
//

#import "Stack.h"
#include "stdlib.h"

@implementation Stack

- (void)initStack{
    self.symbolStack = [[NSMutableArray alloc] init];
    self.numberStack = [[NSMutableArray alloc] init];
    self.symbolTop = -1;
    self.numberTop = -1;
    self.flag = -1;
    self.over = 1;
    self.pointFlag = 0;
    self.k = 0;
    self.last = -1;
}

- (NSString *)compare:(NSString *)str1 :(NSString *)str2
{
    //判断两符号的优先关系
    char t1 = '\0', t2 = '\0';
    NSString *str;
    if ([str1 isEqualToString:@"+"]) t1 = '+';
    if ([str1 isEqualToString:@"-"]) t1 = '-';
    if ([str1 isEqualToString:@"×"]) t1 = '*';
    if ([str1 isEqualToString:@"÷"]) t1 = '/';
    if ([str1 isEqualToString:@"("]) t1 = '(';
    if ([str1 isEqualToString:@")"]) t1 = ')';
    if ([str2 isEqualToString:@"+"]) t2 = '+';
    if ([str2 isEqualToString:@"-"]) t2 = '-';
    if ([str2 isEqualToString:@"×"]) t2 = '*';
    if ([str2 isEqualToString:@"÷"]) t2 = '/';
    if ([str2 isEqualToString:@"("]) t2 = '(';
    if ([str2 isEqualToString:@")"]) t2 = ')';
    switch(t2)
    {
        case '+':
        case '-':
            if(t1=='('||t1=='=')
                str = @"<";
            else
                str = @">";
            break;
        case '*':
        case '/':
            if(t1=='*'||t1=='/'||t1==')')
                str = @">";
            else
                str = @"<";
            break;
        case '(':
            if(t1==')')
            {
                str = @"=";
            }
            else
                str = @">";
            break;
//        case ')':
//            switch(t1)
//        {
//            case '(':
//                str = @"=";
//                break;
//            case '=':
//                printf("ERROR2\n");
//            default:
//                str = @">";
//        }
//            break;
//        case '=':
//            switch(t1)
//        {
//            case '=':
//                str = @"=";
//                break;
//            case '(':
//                printf("ERROR3\n");
//            default:
//                str = @">";
//        }
    }
    return str;
}

- (BOOL)isNumberEmpty{
    if (self.numberTop == -1) {
        return YES;
    } else{
        return NO;
    }
}

- (int)isSymbol:(NSString *) str{
    if ( [str isEqualToString:@"+"] || [str isEqualToString:@"-"] || [str isEqualToString:@"×"] || [str isEqualToString:@"÷"]) {
        self.flag = 1;
    } else if ( [str isEqualToString:@"("] || [str isEqualToString:@")"] ){
        self.flag = 2;
    } else if( [str isEqualToString:@"AC"] ){
        self.flag = 4;
    } else if ( [str isEqualToString:@"="] ){
        self.flag = 3;
    } else if ( [str isEqualToString:@"."] ){
        self.flag = 5;
    } else{
        self.flag = 0;
    }
    return self.flag;
}

- (float)operate:(float)n1 :(NSString *)sym :(float)n2{
    char t;
    float  c;
    if ([sym isEqualToString:@"+"]) t = '+';
    if ([sym isEqualToString:@"-"]) t = '-';
    if ([sym isEqualToString:@"×"]) t = '*';
    if ([sym isEqualToString:@"÷"]) t = '/';
    switch(t)
    {
        case'+':
            c=n1+n2;
            break;
        case'-':
            c=n1-n2;
            break;
        case'*':
            c=n1*n2;
            break;
        case'/':
            c=n1/n2;
    }
    return c;
}

- (void)pushSymbolStack:(NSString *)str{
    [self.symbolStack addObject:str];
    self.symbolTop++;
}

- (NSString *)popSymbolStack{
    NSString *lastSymbol = self.symbolStack[self.symbolTop];
    [self.symbolStack removeLastObject];
    self.symbolTop--;
    return lastSymbol;
}

- (float)popNumberStack{
    float t = [self.numberStack[self.numberTop] floatValue];
    [self.numberStack removeLastObject];
    self.numberTop--;
    return t;
}

- (void)inStack:(NSString *) str{
    int new;

    self.last = self.flag;
    new = [self isSymbol:str];
    //操作结果：判断c是否为运算符
    if (new == 1) {   //+-*/
        self.flag = 1;
        self.pointFlag = 0;
        self.k = 0;
        if (self.last == 1) {
            [self.symbolStack removeLastObject];
            [self.symbolStack addObject:str];
        } else if (self.last == 2 || self.last == 0 || self.last == 3){
            NSString *judge;
            if (self.symbolTop == -1) {
                [self pushSymbolStack:str];
            } else{
                judge = [self compare:str :self.symbolStack[self.symbolTop]];
                
                if ([judge isEqualToString:@">"]) {
                    [self pushSymbolStack:str];
                }
                if ([judge isEqualToString:@"="]){
                    [self popSymbolStack];
                }
                if ([judge isEqualToString:@"<"]) {
                    do {
                        if ([self.symbolStack[self.symbolTop] isEqualToString:@"("]) {
                            [self pushSymbolStack: str];
                            break;
                        } else{
                            float a, b;
                            a = [self popNumberStack];
                            b = [self popNumberStack];
                            [self pushNumberStack:[self operate:b :[self popSymbolStack] :a] ];
                            if (self.symbolTop == -1) {
                                [self pushSymbolStack:str];
                                break;
                            }
                        }
                    } while ( [judge isEqualToString:@"<"] );
                }
            }
        }
    } else if (new == 2){  //()
        self.flag = 2;
        self.pointFlag = 0;
        self.k = 0;
        NSString *judge;
        if (self.symbolTop == -1) {
            if ([str isEqualToString:@"("]) {
                [self pushSymbolStack:str];
            } else{
                self.over = 0;
                NSLog(@"右括号未匹配");
                
            }
        } else{
            if ([str isEqualToString:@"("]) {
                [self pushSymbolStack:str];
            } else{
                if (self.symbolTop == -1) {
                    self.over = 0;
                     NSLog(@"右括号未匹配2");
                } else{
                    judge = [self compare:str :self.symbolStack[self.symbolTop]];
                    while (![judge isEqualToString:@"="]) {
                        float a, b;
                        if (self.numberTop != -1) {
                            a = [self popNumberStack];
                        } else{
                            self.over = 0;
                            break;
                        }
                        if (self.numberTop != -1) {
                            b = [self popNumberStack];
                        } else{
                            self.over = 0;
                            break;
                        }
                        NSLog(@"%@", self.symbolStack[self.symbolTop]);
                        NSString *strT = [self popSymbolStack];
                        float t =[self operate:b :strT :a];
                        [self pushNumberStack: t];
                        if (self.symbolTop == -1) {
                            self.over = 0;
                            break;
                        }
                        
                        judge = [self compare:str :self.symbolStack[self.symbolTop]];
                    }
                    if ([judge isEqualToString:@"="]) {
                        [self popSymbolStack];
                    }
                }
                
            }
        }
    } else if(new == 4){  //AC
        self.flag = 0;
        self.pointFlag = 0;
        self.k = 0;
        self.last = -1;
        [self.symbolStack removeAllObjects];
        [self.numberStack removeAllObjects];
        self.symbolTop = -1;
        self.numberTop = -1;
        self.over = 1;
    } else if (new == 3){  //=
        self.flag = 3;
        self.pointFlag = 0;
        self.k = 0;
        if (self.symbolTop == -1 && self.numberTop == -1) {
            self.over = 0;
        }
        
        while (self.symbolTop != -1) {
            
            float a, b;
            if (self.numberTop != -1) {
                a = [self popNumberStack];
            } else{
                self.over = 0;
                break;
            }
            if (self.numberTop != -1) {
                b = [self popNumberStack];
            } else{
                self.over = 0;
                break;
            }
            [self pushNumberStack:[self operate:b :[self popSymbolStack] :a] ];
        }
    } else{    //运算数
        
        if ([str isEqualToString:@"."]) {  //小数点
            self.pointFlag = 1;
        } else{                             //数字
            
            float f = [str floatValue];
            if ([self isNumberEmpty]) {
                [self pushNumberStack:f];
            } else{
                if (self.last == 0 || self.last == 5) {
                    if (self.pointFlag == 1) {
                        self.k++;
                    }
                    [self pushAndOperateNumber:f :self.pointFlag :self.k];
                } else{
//                    self.k = 0;
                    [self pushNumberStack:f];
                }
            }
        }
        
    }
}

- (void)pushNumberStack:(float) f{
    NSNumber *number = [NSNumber numberWithFloat:f];
    [self.numberStack addObject:number];
    self.numberTop++;
}

- (void)pushAndOperateNumber:(float) f :(int) pointFlag :(int) k{
    float t;
    t = [self.numberStack[self.numberTop] floatValue];
    [self.numberStack removeLastObject];
    if (pointFlag == 0) {
        f = t * 10 + f;
    } else{
        f = t + f * pow(10, -k);
    }
    NSNumber *number = [NSNumber numberWithFloat:f];
    [self.numberStack addObject:number];
    
}

@end
