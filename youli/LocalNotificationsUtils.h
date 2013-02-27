//
//  LocalNotificationsManager.h
//  youli
//
//  Created by ufida on 13-2-17.
//
//

#import <Foundation/Foundation.h>

@interface LocalNotificationsUtils : NSObject

+(void)addLocalNotificationWithFireDate:(NSDate *)date activityId:(NSString *)alertname activityTitle:(NSString *)title;

+(BOOL)removeLocalNotificationWithActivityName:(NSString *)alertname;

+(BOOL)checkIsExistLocalNotificationWithActivityName:(NSString *)alertname;

+(BOOL)removeLocalNotificationWithActivityId:(NSInteger)aid;

+(BOOL)checkIsExistLocalNotificationWithActivityId:(NSInteger)alertaid;

+(void)removeAllLocalNotification;
@end
