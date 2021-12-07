//
//  IACClient+UniversalLink.h
//  IACSample
//
//  Created by pzz on 2021/11/23.
//  Copyright © 2021 zz. All rights reserved.
//

#import "IACClient.h"

NS_ASSUME_NONNULL_BEGIN

/// 「Universal Link」相关新增
@interface IACClient (UniversalLink)

#pragma mark - 「Universal Link」相关新增

/// 外部APP的host
/// @note
/// 使用「Universal Link」模式时必传，需设置外部APP的host域名。
@property (copy, nonatomic) NSString * _Nullable host;

/// 是否是「Universal Link」模式
/// @note
/// 请务必先设置URLScheme，因为它就是根据传入的URLScheme来判断的。
- (BOOL)isHttps;

@end

NS_ASSUME_NONNULL_END
