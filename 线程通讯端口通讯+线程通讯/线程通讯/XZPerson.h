//
//  XZPerson.h
//  线程通讯
//
//  Created by Alan on 6/3/20.
//  Copyright © 2020 zhaixingzhi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XZPerson : NSObject
- (void)personLaunchThreadWithPort:(NSPort *)port;

@end

NS_ASSUME_NONNULL_END
