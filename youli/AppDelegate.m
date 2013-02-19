//
//  AppDelegate.m
//  youli
//
//  Created by jun on 9/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define BIRTHDAY_ALERT  @"BirthdayAlert"


#import "AppDelegate.h"
#import "IndexController.h"
#import "PersonalController.h"
#import "SinaWeibo.h"

#import "LocalNotificationsUtils.h"

@implementation AppDelegate

@synthesize sinaweibo;
@synthesize personalController = _personalController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    IndexController *indexController = [[IndexController alloc] init];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:indexController];
	self.window.rootViewController = self.navigationController;
	[self.window makeKeyAndVisible];
    
    sinaweibo = [[SinaWeibo alloc] initWithAppKey:kAppKey appSecret:kAppSecret appRedirectURI:kAppRedirectURI andDelegate:_personalController];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
    if ([sinaweiboInfo objectForKey:@"AccessTokenKey"] && [sinaweiboInfo objectForKey:@"ExpirationDateKey"] && [sinaweiboInfo objectForKey:@"UserIDKey"])
    {
        sinaweibo.accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
        sinaweibo.expirationDate = [sinaweiboInfo objectForKey:@"ExpirationDateKey"];
        sinaweibo.userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
    }
	return YES;
}

- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notif
{
//    NSLog(@"didReceiveLocalNotification");
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    
//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval: 1
//                                             target: self
//                                           selector: @selector(handleTimer:)
//                                           userInfo: nil
//                                            repeats: YES];

    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self.sinaweibo applicationDidBecomeActive];
    
//    LocalNotificationsUtils *localNotificationsUtils=[[LocalNotificationsUtils alloc]init];
//    [localNotificationsUtils removeLocalNotificationWithActivityId:BIRTHDAY_ALERT];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [self.sinaweibo handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [self.sinaweibo handleOpenURL:url];
}

-(void) handleTimer: (NSTimer *) timer
{
    NSCalendar *calendar=[NSCalendar currentCalendar];

    unsigned unitFlags1=NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *comp=[calendar components:unitFlags1 fromDate:[NSDate date]];

    NSLog(@"%d:%d:%d",comp.hour,comp.minute,comp.second);
}

@end
