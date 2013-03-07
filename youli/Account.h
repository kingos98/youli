//
//  Account.h
//  youli
//
//  Created by sjun on 3/6/13.
//
//

#import <Foundation/Foundation.h>

@interface Account : NSObject

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSDate *expirationDate;
@property (nonatomic, copy) NSString *refreshToken;

+ (Account *)getInstance;
- (BOOL)isLoggedIn;
- (BOOL)isAuthorizeExpired;
- (BOOL)isAuthValid;

@end
