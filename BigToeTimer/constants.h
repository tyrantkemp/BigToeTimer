//
//  constants.h
//  qunxin_edu
//
//  Created by 肖准 on 6/7/16.
//  Copyright © 2016 肖准. All rights reserved.
//

#ifndef constants_h
#define constants_h

#define viewwith self.view.frame.size.width
#define viewheight self.view.frame.size.height
#define screenwith [[UIScreen  mainScreen ] bounds].size.width
#define screenheight [[UIScreen  mainScreen ] bounds].size.height


//#define Local

#ifdef Local
#define MAIN @"http://tyrantkemp.imwork.net:14635"
#define IP @"http://tyrantkemp.imwork.net:14635"

#else
#define MAIN @"https://118.192.142.24:8443/BigToe"
#define IP @"https://118.192.142.24:8443"

#endif

//计划表
#define LIST @"/plan"
#define PLAN_CREATE @"/createplan"
#define PLAN_DELETE @"/deleteplan"
#define PLAN_DONE @"/doneplan"
#define LIST_ALL_DATA @"/getAllPlans"
#define PLAN_GET_ONE @"/getPlanById"
#define PLAN_GET_MONTH @"/getPlansByMonthAndUserId"
#define PLAN_GET_LINE_CHART @"/getPlansToLine"

#define PLAN_GETBY_TYPE_AND_DATE @"/getPlansByType"


//app 注册 登录 等
#define AUTH @"/auth"
#define APP_LOGIN @"/applogin"
#define APP_REGISTER @"/registerAction"
#define ADVISE @"/advise"


//登陆
//#ifdef Local
//#define ACCOUNT_LOGIN @"/camp-front/apploginAction.html"
//#else
//#define ACCOUNT_LOGIN @"/front/apploginAction.html"
//#endif

//tag
#define DINNER_MONTH_VIP 1001
#define DINNER_YEAE_VIP 1001

#define PAY_WAY_ZHIFU 2001
#define PAY_WAY_WECHAT 2002




//消息
#define QUIT_REGISTER @"quit_register"
#define QUIT_REGISTER_TO_SETTING @"QUIT_REGISTER_TO_SETTING"
#define NOTIFICATION_TIME_CELL @"NOTIFICATION_TIME_CELL"


#define PLAN_NEW @"PLAN_NEW"

#define PLAN_EDIT @"PLAN_EDIT"

//常用方法
//GCD - 在Main线程上运行
#define kDISPATCH_MAIN_THREAD(mainQueueBlock) dispatch_async(dispatch_get_main_queue(), mainQueueBlock);
//GCD - 开启异步线程
#define kDISPATCH_GLOBAL_QUEUE_DEFAULT(globalQueueBlock) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), globalQueueBlocl);

//获取view的frame
#define kGetViewWidth(view)  view.frame.size.width
#define kGetViewHeight(view) view.frame.size.height
#define kGetViewX(view)      view.frame.origin.x
#define kGetViewY(view)      view.frame.origin.y


#endif /* constants_h */
