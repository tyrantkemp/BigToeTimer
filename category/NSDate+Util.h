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

#pragma mark - 转换成 2016年7月13日 格式时间显示
-(NSString*)currentTimeStringYMD;

#pragma mark - 转换成  7月13日 格式时间显示
-(NSString*)currentTimeStringMD;

#pragma mark - 转换成  2016年7月 格式时间显示
-(NSString*)currentTimeStringYM;


-(NSInteger)secondTime;

-(NSInteger)minuteTime;




-(BOOL)isBiggerThan:(NSDate*)date;


-(NSDate*)dateBysubtractingDate:(NSDate*)date;

@end
