//
//  LocalNotificationsManager.h
//  youli
//
//  Created by ufida on 13-2-17.
//
//

#import <Foundation/Foundation.h>

@interface LocalNotificationsUtils : NSObject

-(void)addLocalNotificationWithFireDate:(NSDate *)date activityId:(NSString *)alertname activityTitle:(NSString *)title;

-(BOOL)removeLocalNotificationWithActivityId:(NSString *)alertname;
@end
