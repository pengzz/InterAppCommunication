//
//  IACManager+UniversalLink.h
//  IACSample
//
//  Created by pzz on 2021/11/23.
//  Copyright © 2021 zz. All rights reserved.
//

#import "IACManager.h"

// 宏定义
#define st_property_object(__type, __name) \
property (nonatomic, strong, setter=set__##__name:, getter=__##__name) __type* __name;
//
#define st_property_object_method(__type, __name) \
- (__type *)__##__name \
{\
return objc_getAssociatedObject(self, #__name);\
}\
\
- (void)set__##__name:(__type *)__##__name \
{\
objc_setAssociatedObject(self, #__name, __##__name, OBJC_ASSOCIATION_RETAIN_NONATOMIC);\
}

// 以下静态定义值必须保持与原实现类中一致
NS_ASSUME_NONNULL_BEGIN
// x-callback-url strings
static NSString * const _kXCUPrefix        = @"x-";
static NSString * const _kXCUHost          = @"x-callback-url";
static NSString * const _kXCUSource        = @"x-source";
static NSString * const _kXCUSuccess       = @"x-success";
static NSString * const _kXCUError         = @"x-error";
static NSString * const _kXCUCancel        = @"x-cancel";
static NSString * const _kXCUErrorCode     = @"error-Code";
static NSString * const _kXCUErrorMessage  = @"errorMessage";
// IAC strings
static NSString * const _kIACPrefix       = @"IAC";
static NSString * const _kIACResponse     = @"IACRequestResponse";
static NSString * const _kIACRequest      = @"IACRequestID";
static NSString * const _kIACResponseType = @"IACResponseType";
static NSString * const _kIACErrorDomain  = @"errorDomain";
NS_ASSUME_NONNULL_END

// 宏定义：简化书写
#define kReal(key)  [self kReal:_##key]
// x-callback-url strings
#define kXCUPrefix        kReal(kXCUPrefix)
#define kXCUHost          kReal(kXCUHost)
#define kXCUSource        kReal(kXCUSource)
#define kXCUSuccess       kReal(kXCUSuccess)
#define kXCUError         kReal(kXCUError)
#define kXCUCancel        kReal(kXCUCancel)
#define kXCUErrorCode     kReal(kXCUErrorCode)
#define kXCUErrorMessage  kReal(kXCUErrorMessage)
// IAC strings
#define kIACPrefix       kReal(kIACPrefix)
#define kIACResponse     kReal(kIACResponse)
#define kIACRequest      kReal(kIACRequest)
#define kIACResponseType kReal(kIACResponseType)
#define kIACErrorDomain  kReal(kIACErrorDomain)


NS_ASSUME_NONNULL_BEGIN

/// 「Universal Link」相关新增
@interface IACManager (UniversalLink)

#pragma mark - 「Universal Link」相关新增

/// 当前自身host
/// @note
/// 使用「Universal Link」模式时必传，需设置自己APP的host域名。iOS10及以后才能保证UniversalLinksOnly。
@property (copy, nonatomic) NSString * _Nullable host;

/// 是否是「Universal Link」模式
/// @note
/// 请务必先设置callbackURLScheme，因为它就是根据传入的callbackURLScheme来判断的。
- (BOOL)isHttps;

#pragma mark - 键值处理
/// 键值修正
- (NSString *)kReal:(NSString *)key;
/// 所有内部字段键值集
- (NSArray<NSString *> *)allInnerKeys;

#pragma mark - 一些属性定制
/// 以下为需要高度定制时使用传值，需对IAC源码有高度认识，请勿随意修改。且修改后需要主体与客体都修改保持一致才正常。
// x-callback-url strings
@st_property_object(NSString, x_source);
@st_property_object(NSString, x_success);
@st_property_object(NSString, x_error);
@st_property_object(NSString, x_cancel);
@st_property_object(NSString, error_Code);   // 参数集parameters中的kXCUErrorCode取值字段
@st_property_object(NSString, errorMessage); // 参数集parameters中的kXCUErrorMessage取值字段
// IAC strings
@st_property_object(NSString, IACRequestResponse);
@st_property_object(NSString, IACRequestID);
@st_property_object(NSString, IACResponseType);
@st_property_object(NSString, errorDomain);

/// 自定义打开URL方法block
/// @note
/// 注意：iOS10及以后才能保证UniversalLinksOnly即'仅打开通用链接'的功能。
/// 该block回调内容处理请务必注意处理以下：1.判断是否为通用链接，2.openURL
/// 注意：当使用'openURL:options:completionHandler:'打开通用链接时，需在options字典中增加字段UIApplicationOpenURLOptionUniversalLinksOnly且值为@(YES)，以保证只打开通用链接APP而不可跳浏览器。
@property(nonatomic, copy) void (^customOpenURLBlock)(IACManager * _Nonnull manager, void (^ _Nonnull original_openURL)(NSURL * _Nullable), NSURL * _Nullable url, NSString * _Nullable action, NSDictionary * _Nullable parameters);

@end

NS_ASSUME_NONNULL_END
