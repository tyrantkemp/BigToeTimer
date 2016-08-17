//
//  planMJ.h
//  BigToeTimer
//
//  Created by 肖准 on 7/11/16.
//  Copyright © 2016 xiaozhun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface planMJ : NSObject
@property(nonatomic,assign)NSInteger planId;
@property(nonatomic,strong)NSString* planName;
@property(nonatomic,strong)NSString* content;
@property(nonatomic,assign)NSInteger startTime;
@property(nonatomic,strong)NSString* createTime;
@property(nonatomic,assign)NSInteger endTime;
@property(nonatomic,assign)NSInteger plantype;
@property(nonatomic,assign)double ration;
@property(nonatomic,assign)NSInteger remain;
@property(nonatomic,assign)BOOL isPassed;
@end
