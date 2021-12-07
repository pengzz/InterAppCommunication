//
//  IACManager+UniversalLink.m
//  IACSample
//
//  Created by pzz on 2021/11/23.
//  Copyright © 2021 zz. All rights reserved.
//

#import "IACManager+UniversalLink.h"
#import <objc/runtime.h>

@implementation IACManager (UniversalLink)

#pragma mark - URL相关

- (void)setHost:(NSString *)host {
    objc_setAssociatedObject(self, @selector(host), host, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSString *)host {
    return (NSString *)objc_getAssociatedObject(self, @selector(host));
}

- (BOOL)isHttps {
    return [self.callbackURLScheme.lowercaseString isEqualToString:@"https"];
}

#pragma mark - 键值处理

/// 键值修正
- (NSString *)kReal:(NSString *)key {
    NSString* (^block)(NSString *, NSString *) = ^(NSString *targetStr, NSString *defaultStr) {
        return targetStr.length ? targetStr :defaultStr;
    };
    if ([self isHttps]) {
        // x-callback-url strings
        if ([key isEqualToString:_kXCUPrefix]) { // 前缀：则先不处理，后面特别处理「键值移除」。
            return key;
        }
        if ([key isEqualToString:_kXCUHost]) {
            return self.host; // 注意这里用当前自身host
        }
        if ([key isEqualToString:_kXCUSource]) { return block(self.x_source, key); }
        if ([key isEqualToString:_kXCUSuccess]) { return block(self.x_success, key); }
        if ([key isEqualToString:_kXCUError]) { return block(self.x_error, key); }
        if ([key isEqualToString:_kXCUCancel]) { return block(self.x_cancel, key); }
        if ([key isEqualToString:_kXCUErrorCode]) { return block(self.error_Code, key); }
        if ([key isEqualToString:_kXCUErrorMessage]) { return block(self.errorMessage, key); }
    }
    if ([self isHttps]) {
        // IAC strings
        if ([key isEqualToString:_kIACPrefix]) { // 前缀：则先不处理，后面特别处理「键值移除」。
            return key;
        }
        if ([key isEqualToString:_kIACResponse]) { return block(self.IACRequestResponse, key); }
        if ([key isEqualToString:_kIACRequest]) { return block(self.IACRequestID, key); }
        if ([key isEqualToString:_kIACResponseType]) { return block(self.IACResponseType, key); }
        if ([key isEqualToString:_kIACErrorDomain]) { return block(self.errorDomain, key); }
    }
    return key;
}

/// 所有内部字段键值集
- (NSArray<NSString *> *)allInnerKeys {
    NSMutableArray *mArr = [[NSMutableArray alloc] init];
    [mArr addObject:kXCUPrefix];
    [mArr addObject:kXCUHost];
    [mArr addObject:kXCUSource];
    [mArr addObject:kXCUSuccess];
    [mArr addObject:kXCUError];
    [mArr addObject:kXCUCancel];
    [mArr addObject:kXCUErrorCode];
    [mArr addObject:kXCUErrorMessage];
    [mArr addObject:kIACPrefix];
    [mArr addObject:kIACResponse];
    [mArr addObject:kIACRequest];
    [mArr addObject:kIACResponseType];
    [mArr addObject:kIACErrorDomain];
    return mArr;
}

#pragma mark - 一些属性定制

/// 以下为需要高度定制时使用传值，需对IAC源码有高度认识，请勿随意修改。且修改后需要主体与客体都修改保持一致才正常。
// x-callback-url strings
st_property_object_method(NSString, x_source);
st_property_object_method(NSString, x_success);
st_property_object_method(NSString, x_error);
st_property_object_method(NSString, x_cancel);
st_property_object_method(NSString, error_Code);   // 参数集parameters中的kXCUErrorCode取值字段
st_property_object_method(NSString, errorMessage); // 参数集parameters中的kXCUErrorMessage取值字段
// IAC strings
st_property_object_method(NSString, IACRequestResponse);
st_property_object_method(NSString, IACRequestID);
st_property_object_method(NSString, IACResponseType);
st_property_object_method(NSString, errorDomain);

/// 自定义打开URL方法block
- (void)setCustomOpenURLBlock:(void (^)(IACManager * _Nonnull, void (^ _Nonnull)(NSURL * _Nullable), NSURL * _Nullable, NSString * _Nullable, NSDictionary * _Nullable))customOpenURLBlock {
    objc_setAssociatedObject(self, @selector(customOpenURLBlock), customOpenURLBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void (^)(IACManager * _Nonnull, void (^ _Nonnull)(NSURL * _Nullable), NSURL * _Nullable, NSString * _Nullable, NSDictionary * _Nullable))customOpenURLBlock {
    return objc_getAssociatedObject(self, @selector(customOpenURLBlock));
}

#pragma mark - 其它

@end




/*
 一些知识
 一：An app can respond to multiple url schemes and the app can use different IACManagers for each one
 二：The host URL subcomponent of external apps.
 IACClient: 中的URLScheme属性，是一个客体（Client）要向外部主力方APP发送请求时，外部主体方（Host）的scheme。
 IACManager:中的callbackURLScheme属性是自己APP的Scheme。若自己是发起方即客体时，是从外部（Host）回响唤起到客体时，客体方（client）的scheme；若自己是回应方时，是主体的将能做出响应的自己的Scheme。
 注：请求时：主链中前头为IACClient中的URLScheme，三个回响子链中为IACManager中的callbackURLScheme；回应时：链接中判断IACManager中的callbackURLScheme。
 注：以上两个URLScheme的小写为'https'时为使用 「Universal Link」通用链接模式。
 三：
 IACManager中的两个错域字段：
 //extern NSString * const IACErrorDomain;
 //extern NSString * const IACClientErrorDomain;
 IACErrorDomain为IAC程序代码本身内部错误，为不能执行x-callback时产生的错误，即Host无法handleOpenURL处理某个链接要回传其kXCUError子链时所使用的程序内部错误域。
 IACClientErrorDomain为Response回响子链到客体时，失败errorCalback处理时，当发现没有kIACErrorDomain字段时缺省使用的错误域字段。
 四：
 // 示例代码：
 //zzz-test2://x-callback-url/cList?&x-source=ZZZAPP&
 //{
 //    "x-cancel" = "zzz://x-callback-url/IACRequestResponse?&IACRequestID=C354B308-6C01-4C9C-8222-E12AAD27DFD0&IACResponseType=2&";
 //    "x-error" = "zzz://x-callback-url/IACRequestResponse?&IACRequestID=C354B308-6C01-4C9C-8222-E12AAD27DFD0&IACResponseType=1&";
 //    "x-success" = "zzz://x-callback-url/IACRequestResponse?&IACRequestID=C354B308-6C01-4C9C-8222-E12AAD27DFD0&IACResponseType=0&";
 //}
 五：
 // action:action为链接url.path部分（除去第一个斜线）。即：NSString *action = [[url path] substringFromIndex:1];
 六：
 注意：使用通用链接方式时，必须外部另外先判断对方APP的scheme能否打开，本库类中的通用链接去canOpenURL会始终返回YES。
 七：
 注意：通用链接是保证链接的接受者是正规军，不被其它者截获。
 注意：当使用'openURL:options:completionHandler:'打开目标通用链接时，需在options字典中增加字段UIApplicationOpenURLOptionUniversalLinksOnly且值为@(YES)，以保证只打开通用链接APP而不可跳浏览器。
 八：
 
 */
