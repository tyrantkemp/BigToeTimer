//
//  m_date.m
//  BigToeTimer
//
//  Created by 肖准 on 7/12/16.
//  Copyright © 2016 xiaozhun. All rights reserved.
//

#import "m_date.h"

@implementation m_date
+ (instancetype)timeModelWithTime:(NSInteger)time endtime:(NSInteger)endTime{
    m_date *model = [self new];
    
    NSDate* now = [NSDate date];
    model.isDone = NO;
    model.startTime = time;
    model.m_countNum = endTime -[now minuteTime];
    model.endTime = endTime;
    return model;
}

- (void)countDown {
    if(_m_countNum<=0){
        
    }else {
        _m_countNum -=1;
    }
}


@end
