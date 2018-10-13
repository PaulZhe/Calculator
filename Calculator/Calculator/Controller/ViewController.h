//
//  ViewController.h
//  Calculator
//
//  Created by 小哲的DELL on 2018/9/27.
//  Copyright © 2018年 小哲的DELL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalculatorView.h"
#import "Stack.h"

@interface ViewController : UIViewController

@property(nonatomic, strong) UITextView *textView;
@property(nonatomic, strong) CalculatorView *calculatorView;
@property(nonatomic, strong) Stack *stack;
@property(nonatomic, strong) NSMutableString *textString;

@end

