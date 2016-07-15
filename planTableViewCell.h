//
//  planTableViewCell.h
//  BigToeTimer
//
//  Created by 肖准 on 7/11/16.
//  Copyright © 2016 xiaozhun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SWTableViewCell.h>
#import "planMJ.h"
#import "m_date.h"

@interface planTableViewCell : SWTableViewCell

-(void)loyoutWithDataAndHeight:(planMJ*)plan height:(CGFloat)height;

-(void)loadTime:(id)date indexPath:(NSIndexPath *)indexPath;

@property(nonatomic,assign)BOOL isDisplay;
@property(nonatomic,copy)void (^disableCell)(void);
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,assign)double ration;
@property(nonatomic,strong)planMJ* plan;


@end
