//
//  NSDate+Util.h
//  iosapp
//
//  Created by AeternChan on 10/15/15.
//  Copyright © 2015 oschina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DateTools.h>

@interface NSDate (Util)

+ (instancetype)dateFromString:(NSString *)string;
- (NSString *)weekdayString;

#pragma mark - 转换成 00:00:00 格式时间显示
-(NSString*)currentTimeStringHMS;

#pragma mark - 转换成 00:00 格式时间显示
-(NSString*)currentTimeStringHM;


-(NSInteger)secondTime;

-(NSInteger)minuteTime;


-(BOOL)isBiggerThan:(NSDate*)date;


-(NSDate*)dateBysubtractingDate:(NSDate*)date;

@end
