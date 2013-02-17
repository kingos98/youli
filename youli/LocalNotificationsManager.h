//
//  LocalNotificationsManager.h
//  youli
//
//  Created by ufida on 13-2-17.
//
//

#import <Foundation/Foundation.h>

@interface LocalNotificationsManager : NSObject

-(void)addLocalNotificationWithFireDate:(NSDate *)date activityId:(NSInteger)aid activityTitle:(NSString *)title;

-(BOOL)removeLocalNotificationWithActivityId:(NSInteger)aid;
@end
