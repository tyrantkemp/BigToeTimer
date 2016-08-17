//
//  detailViewController.h
//  BigToeTimer
//
//  Created by 肖准 on 7/13/16.
//  Copyright © 2016 xiaozhun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "planMJ.h"

typedef NS_ENUM(NSUInteger,PlanType){
    
    PlanTypeLimited,   //限时
    PlanTypeAllDay    //全天
};

@interface detailViewController : UIViewController
@property(nonatomic,assign )PlanType plantype;
@property(nonatomic,strong)planMJ* plan;
@property(nonatomic,assign)NSInteger editType; //0:正常 1:内容可编辑，可保存 2:全都不能编辑
@end
