//
//  LocalNotificationsManager.m
//  BigToeTimer
//
//  Created by 肖准 on 7/19/16.
//  Copyright © 2016 xiaozhun. All rights reserved.
//

#import "LocalNotificationsManager.h"

@implementation LocalNotificationsManager
+ (void)addLocalNotificationWithFireDate:(NSDate *)date//设置提醒

                              activityId:(NSString*)aid

                           activityTitle:(NSString *)title {
    
  //  NSDate *t = [NSDate dateWithTimeIntervalSinceNow:7200.0f];
    // 2*60*60 2h
    
    //NSComparisonResult result = [t compare:date];
    
  //  if (result == -1) {
        
        UILocalNotification *notification=[[UILocalNotification alloc] init];
        
        notification.fireDate = date;
        
        notification.timeZone = [NSTimeZone defaultTimeZone];
        
       // notification.applicationIconBadgeNumber = 1;
        
        notification.soundName = UILocalNotificationDefaultSoundName;
        
        notification.alertBody = [NSString stringWithFormat:@"%@",title];
        
        NSDictionary *dic =
        
        [NSDictionary dictionaryWithObjectsAndKeys:aid, @"activityid", nil];
        
        notification.userInfo = dic;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        
        
        
 //   }
    
}

+ (BOOL)removeLocalNotificationWithActivityId:(NSString*)aid //取消提醒

{
    
    UIApplication *application = [UIApplication sharedApplication];
    
    NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    for (UILocalNotification *obj in localNotifications) {
        
        NSString* activityId = [obj.userInfo objectForKey:@"activityid"];
        
        if ([aid isEqualToString:activityId]) {
            
            [application cancelLocalNotification:obj];
            
            return YES;
            
        }
        
    }
    
    return NO;
    
}
@end
