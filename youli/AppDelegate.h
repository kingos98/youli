//
//  AppDelegate.h
//  youli
//
//  Created by jun on 9/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define kWIDTH  [UIScreen mainScreen].bounds.size.width
#define kHEIGHT [UIScreen mainScreen].bounds.size.height

#define kDocuments [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

#define kAppKey             @"3967452029"
#define kAppSecret          @"207640bd3c7f1e5d13fee2149e07d561"
#define kAppRedirectURI     @"http://www.sina.com"

#ifndef kAppKey
#error
#endif

#ifndef kAppSecret
#error
#endif

#ifndef kAppRedirectURI
#error
#endif

@class IndexController;
@class PersonalController;
@class SinaWeibo;

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    SinaWeibo *sinaweibo;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) IndexController *indexController;
@property (strong, nonatomic) PersonalController *personalController;
@property (readonly, nonatomic) SinaWeibo *sinaweibo;

@end
