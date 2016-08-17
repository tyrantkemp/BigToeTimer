//
//  LocalNotificationsManager.h
//  BigToeTimer
//
//  Created by 肖准 on 7/19/16.
//  Copyright © 2016 xiaozhun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalNotificationsManager : NSObject
+ (void)addLocalNotificationWithFireDate:(NSDate *)date

                              activityId:(NSString*)aid

                           activityTitle:(NSString *)title;



+ (BOOL)removeLocalNotificationWithActivityId:(NSString*)aid ;//取消提醒
@end
