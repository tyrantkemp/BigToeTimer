//
//  MenuView.h
//  qunxin_edu
//
//  Created by 肖准 on 6/28/16.
//  Copyright © 2016 肖准. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuView : UIView


@property(nonatomic,strong)UITableView* leftTableView;
@property(nonatomic,strong)UITableView* rightTableView;

@property(nonatomic,copy)void (^didselectAtrowWithId)(NSString* Id,NSString* name);

@end
