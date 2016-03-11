//
//  NSInvocation+PCInvocation.h
//
//  Created by lyricdon on 15/9/11.
//  Copyright © 2015年 Modern Mobile Digital Media Company Limited. All rightsreserved.
//

#import <Foundation/Foundation.h>

@interface NSInvocation (PCInvocation)

+ (NSInvocation *)invocationWithTarget:(id)_target andSelector:(SEL)_selector;
+ (NSInvocation *)invocationWithTarget:(id)_target andSelector:(SEL)_selector andArguments:(void *)_addressOfFirstArgument, ...;
- (void)invokeOnMainThreadWaitUntilDone:(BOOL)wait;

@end
