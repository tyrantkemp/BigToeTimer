//
//  DoneListTableViewController.h
//  BigToeTimer
//
//  Created by 肖准 on 7/19/16.
//  Copyright © 2016 xiaozhun. All rights reserved.
//

#import "CommonViewController.h"

@interface DoneListTableViewController : CommonViewController
@property(nonatomic,assign)NSInteger type; //0:日(默认) 1:周 2:日
@property(nonatomic,assign)NSInteger  index; //日期index 0表示当前时间段 1表示想对于当前的上一个时间段 以此类推
@property(nonatomic,assign)NSInteger plantype; //0:时限内完成 1:超时未完成 2:提前完成
@end
