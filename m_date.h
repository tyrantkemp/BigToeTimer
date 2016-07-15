//
//  m_date.h
//  BigToeTimer
//
//  Created by 肖准 on 7/12/16.
//  Copyright © 2016 xiaozhun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface m_date : NSObject
@property (nonatomic,assign)         NSInteger       m_countNum;  //结束时间和当前时间之差 如果为nil表示已经超时
@property (nonatomic,assign)         NSInteger       startTime;  //最初时间
@property (nonatomic,assign)         NSInteger      endTime;  //最初时间

+ (instancetype)timeModelWithTime:(NSInteger)time endtime:(NSInteger)endTime;
/**
 *  便利构造器
 *
 *  @param title         标题
 *  @param countdownTime 倒计时
 *
 *  @return 实例对象
 */


/**
 *  计数减1(countdownTime - 1)
 */
- (void)countDown;


@end
