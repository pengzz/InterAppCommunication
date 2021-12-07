//
//  IACClient+UniversalLink.h
//  IACSample
//
//  Created by pzz on 2021/11/23.
//  Copyright © 2021 zz. All rights reserved.
//

#import "IACClient+UniversalLink.h"
#import <objc/runtime.h>

@implementation IACClient (UniversalLink)

- (void)setHost:(NSString *)host {
    objc_setAssociatedObject(self, @selector(host), host, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSString *)host {
    return (NSString *)objc_getAssociatedObject(self, @selector(host));
}

- (BOOL)isHttps {
    return [self.URLScheme.lowercaseString isEqualToString:@"https"];
}

@end
