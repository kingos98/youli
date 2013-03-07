//
//  Account.m
//  youli
//
//  Created by sjun on 3/6/13.
//
//

#import "Account.h"

static Account *instance = nil;

@implementation Account

+ (Account *)getInstance{
    if (instance == nil)
    {
        instance = [[Account alloc] init];
    }
    return instance;
}

/**
 * @description 判断是否登录
 * @return YES为已登录；NO为未登录
 */
- (BOOL)isLoggedIn
{
    return self.userID && self.accessToken && self.expirationDate;
}

/**
 * @description 判断登录是否过期
 * @return YES为已过期；NO为未为期
 */
- (BOOL)isAuthorizeExpired
{
    NSDate *now = [NSDate date];
    return ([now compare:self.expirationDate] == NSOrderedDescending);
}


/**
 * @description 判断登录是否有效，当已登录并且登录未过期时为有效状态
 * @return YES为有效；NO为无效
 */
- (BOOL)isAuthValid
{
    return ([self isLoggedIn] && ![self isAuthorizeExpired]);
}

@end
