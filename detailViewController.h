//
//  detailViewController.h
//  BigToeTimer
//
//  Created by 肖准 on 7/13/16.
//  Copyright © 2016 xiaozhun. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger,PlanType){
    
    PlanTypeLimited,   //限时
    PlanTypeAllDay    //全天
};

@interface detailViewController : UIViewController
@property(nonatomic,assign )PlanType plantype;
@end
