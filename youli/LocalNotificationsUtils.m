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
-(void)addLocalNotificationWithFireDate:(NSDate *)date activityId:(NSString *)alertname activityTitle:(NSString *)title
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
    [notification release];

    NSLog(@"add notice");
}

//取消提醒
-(BOOL)removeLocalNotificationWithActivityId:(NSString *)alertname
{
    UIApplication *application = [UIApplication sharedApplication];
    
    NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    for (UILocalNotification *obj in localNotifications) {
        
        NSString *activityId = [obj.userInfo objectForKey:@"activityid"];
        
        if (alertname == activityId) {
            
            [application cancelLocalNotification:obj];
            
            return true;
        }
    }
    
    NSLog(@"remove notice");
    
    return false;
}

@end
