//
//  AnalyTableViewCell.h
//  BigToeTimer
//
//  Created by 肖准 on 7/18/16.
//  Copyright © 2016 xiaozhun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnalyTableViewCell : UITableViewCell


@property(nonatomic,strong)UIImageView* iconIV;
@property(nonatomic,strong) UILabel* titleLB;


-(void)loadData:(NSString*)imgUrl title:(NSString*)title;

@end
