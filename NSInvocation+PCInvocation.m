//
//  NSInvocation+PCInvocation.m
//
//  Created by lyricdon on 15/9/11.
//  Copyright © 2015年 Modern Mobile Digital Media Company Limited. All rights reserved.
//

#import "NSInvocation+PCInvocation.h"

@implementation NSInvocation (PCInvocation)

+ (NSInvocation *)invocationWithTarget:(id)_target andSelector:(SEL)_selector
{
    // 签名
    NSMethodSignature *methodSig = [_target methodSignatureForSelector:_selector];

    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
    [invocation setTarget:_target];
    [invocation setSelector:_selector];
    return invocation;
}

+ (NSInvocation *)invocationWithTarget:(id)_target andSelector:(SEL)_selector andArguments:(void *)_addressOfFirstArgument, ...
{
    NSMethodSignature *methodSig = [_target methodSignatureForSelector:_selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
    [invocation setTarget:_target];
    [invocation setSelector:_selector];
    
    //获得参数个数
    NSInteger numArgs = [methodSig numberOfArguments];
    //atIndex的下标必须从2开始。原因：0 1 两个参数已经被target 和selector占用
    if (2 < numArgs) {
        /*
         VA_LIST 是在C语言中解决变参问题的一组宏，所在头文件：#include <stdarg.h>
         VA_START宏，获取可变参数列表的第一个参数的地址（ap是类型为va_list的指针，v是可变参数最左边的参数）
         VA_ARG宏，获取可变参数的当前参数，返回指定类型并将指针指向下一参数（t参数描述了当前参数的类型）
         VA_END宏，清空va_list可变参数列表
         */
        
        /*
         用法：
         （1）首先在函数里定义一具VA_LIST型的变量，这个变量是指向参数的指针；
         （2）然后用VA_START宏初始化刚定义的VA_LIST变量；
         （3）然后用VA_ARG返回可变的参数，VA_ARG的第二个参数是你要返回的参数的类型（如果函数有多个可变参数的，依次调用VA_ARG获取各个参数）；
         （4）最后用VA_END宏结束可变参数的获取。
         */
        va_list varargs;
        
        va_start(varargs, _addressOfFirstArgument);
        [invocation setArgument:_addressOfFirstArgument atIndex:2];
        
        for (int argIndex = 3; argIndex < numArgs; argIndex++) {
            void *argp = va_arg(varargs, void *);
            [invocation setArgument:argp atIndex:argIndex];
        }
        
        va_end(varargs);
    }
    return invocation;
}

- (void)invokeOnMainThreadWaitUntilDone:(BOOL)wait
{
    [self performSelectorOnMainThread:@selector(invoke) withObject:nil waitUntilDone:wait];
}

@end
