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

- (BOOL)isLoggedIn
{
    return self.userID && self.accessToken && self.expirationDate;
}

- (BOOL)isAuthorizeExpired
{
    NSDate *now = [NSDate date];
    return ([now compare:self.expirationDate] == NSOrderedDescending);
}

- (BOOL)isAuthValid
{
    return ([self isLoggedIn] && ![self isAuthorizeExpired]);
}

- (void)removeAuthData
{
    self.accessToken = nil;
    self.userID = nil;
    self.expirationDate = nil;
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray* sinaweiboCookies = [cookies cookiesForURL:
                                 [NSURL URLWithString:@"https://open.weibo.cn"]];
    for (NSHTTPCookie* cookie in sinaweiboCookies){
        [cookies deleteCookie:cookie];
    }
}

@end
