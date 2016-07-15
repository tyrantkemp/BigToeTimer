//
//  NSDate+Util.m
//  iosapp
//
//  Created by AeternChan on 10/15/15.
//  Copyright © 2015 oschina. All rights reserved.
//

#import "NSDate+Util.h"
#import "NSDateFormatter+Singleton.h"


static NSString * const kKeyYears = @"years";
static NSString * const kKeyMonths = @"months";
static NSString * const kKeyDays = @"days";
static NSString * const kKeyHours = @"hours";
static NSString * const kKeyMinutes = @"minutes";


@implementation NSDate (Util)

+ (instancetype)dateFromString:(NSString *)string
{
    return [[NSDateFormatter sharedInstance] dateFromString:string];
}

- (NSString *)weekdayString
{
    switch (self.weekday) {
        case 1: return @"星期天";
        case 2: return @"星期一";
        case 3: return @"星期二";
        case 4: return @"星期三";
        case 5: return @"星期四";
        case 6: return @"星期五";
        case 7: return @"星期六";
        default: return @"";
    }
}


-(NSString*)currentTimeStringHMS{
    
    return  [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)[self hour],(long)[self minute],(long)[self second]];

}

-(NSString*)currentTimeStringHM{
    
    return  [NSString stringWithFormat:@"%02ld:%02ld",(long)[self hour],(long)[self minute]];
    
}


-(NSInteger)secondTime{
    
    return  [self hour]*60*60+[self minute]*60+[self second];
    
    
}
-(NSInteger)minuteTime{
    return  [self hour]*60+[self minute];
}


-(BOOL)isBiggerThan:(NSDate*)date{
    
    double sub = [self timeIntervalSinceDate:date];
    if(sub>0){
        return  YES;
    }else{
        return  NO;
    }
    
}

-(NSDate*)dateBysubtractingDate:(NSDate*)date{
    NSTimeInterval sub = [self timeIntervalSinceDate:date];
    if(sub<=0){
        return nil;
    }else {
        return  [NSDate dateWithYear:0 month:0 day:0 hour:0 minute:0 second:sub];
    }
}
@end
