//
//  LocalNotificationsManager.m
//  youli
//
//  Created by ufida on 13-2-17.
//
//

#define BIRTHDAY_ALERT  @"BirthdayAlert"

#import "LocalNotificationsUtils.h"

@implementation LocalNotificationsUtils

//设置提醒
+(void)addLocalNotificationWithFireDate:(NSDate *)date activityId:(NSString *)alertname activityTitle:(NSString *)title
{
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    notification.fireDate=date;
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.applicationIconBadgeNumber = 1;
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.alertBody = [NSString stringWithFormat:@"%@",title];
    notification.alertAction=@"View";
    notification.hasAction=YES;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:alertname, @"activityid", nil];
    notification.userInfo = dic;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

//取消提醒 by name
+(BOOL)removeLocalNotificationWithActivityName:(NSString *)alertname
{
    UIApplication *application = [UIApplication sharedApplication];
    
    NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    
    for (UILocalNotification *obj in localNotifications) {
        
        NSString *activityName = [obj.userInfo objectForKey:@"activityid"];
        
        if (alertname == activityName) {
            
            [application cancelLocalNotification:obj];
            
            notification.applicationIconBadgeNumber--;

            return YES;
        }
    }
        
    return NO;
}

//判断是否存在该提醒信息
+(BOOL)checkIsExistLocalNotificationWithActivityName:(NSString *)alertname
{
    NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    for (UILocalNotification *obj in localNotifications) {
        
        NSString *activityName = [obj.userInfo objectForKey:@"activityid"];
        
        if (alertname == activityName) {
            
            return YES;
        }
    }
    
    return NO;
}

//取消提醒 by aid
+(BOOL)removeLocalNotificationWithActivityId:(NSInteger)aid
{
    UIApplication *application = [UIApplication sharedApplication];
    
    NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    
    for (UILocalNotification *obj in localNotifications) {
        
        NSInteger activityId = [[obj.userInfo objectForKey:@"activityid"] intValue];
        
        if (aid == activityId) {
            
            [application cancelLocalNotification:obj];
            
            notification.applicationIconBadgeNumber--;
            
            return YES;
            
        }
    }
    
    return NO;
}

//判断是否存在该提醒信息
+(BOOL)checkIsExistLocalNotificationWithActivityId:(NSInteger)alertaid
{
    NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    for (UILocalNotification *obj in localNotifications) {
        
        NSInteger activityId = [[obj.userInfo objectForKey:@"activityid"] intValue];
        
        if (alertaid == activityId) {
                        
            return YES;
            
        }
    }
    
    return NO;
}

//取消所有提醒
+(void)removeAllLocalNotification
{
    UIApplication *application=[UIApplication sharedApplication];
    
    UILocalNotification *notification=[[UILocalNotification alloc] init];

    [application cancelAllLocalNotifications];
    
    notification.applicationIconBadgeNumber=0;
}


@end
