//
//  userMJ.h
//  qunxin_edu
//
//  Created by 肖准 on 6/29/16.
//  Copyright © 2016 肖准. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface userMJ : NSObject
@property(nonatomic,assign) NSInteger userId;
@property(nonatomic,strong) NSString* userName;
@property(nonatomic,strong)NSString* password;
@property(nonatomic,strong)NSString* email;
@property(nonatomic,strong)NSString* mobile;

@property(nonatomic,strong)NSString* creatTime;
@property(nonatomic,strong)NSString* updateTime;


@end
