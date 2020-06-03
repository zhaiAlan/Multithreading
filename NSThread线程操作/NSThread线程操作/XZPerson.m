//
//  XZPerson.m
//  NSThread线程操作
//
//  Created by Alan on 6/2/20.
//  Copyright © 2020 zhaixingzhi. All rights reserved.
//

#import "XZPerson.h"

@implementation XZPerson
- (void)study:(id)time{
    for (int i = 0; i<[time intValue]; i++) {
        NSLog(@"%@ 开始学习了 %d分钟",[NSThread currentThread],i);
    }
}

@end
