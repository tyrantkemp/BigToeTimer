//
//  r_plan.h
//  BigToeTimer
//
//  Created by 肖准 on 7/14/16.
//  Copyright © 2016 xiaozhun. All rights reserved.
//

#import <Realm/Realm.h>

@interface r_plan : RLMObject
@property(nonatomic,assign)NSInteger planId;
@property(nonatomic,strong)NSString* content;
@property(nonatomic,strong)NSString* startTime;
@property(nonatomic,strong)NSString* endTime;
@property(nonatomic,assign)NSInteger plantype;
@property(nonatomic,assign)CGFloat ration;
@end

// This protocol enables typed collections. i.e.:
// RLMArray<r_plan>
RLM_ARRAY_TYPE(r_plan)
