//
//  CommonViewController.h
//
//
//  Created by xiaozhun on 06/05/16.
//

#import <UIKit/UIKit.h>

#import <AFNetworking.h>
#import <MJRefresh.h>
#import "UIColor+Util.h"
#import "LastCell.h"


@interface CommonViewController : UITableViewController

//@property (nonatomic, copy) void (^parseExtraInfo)(ONOXMLDocument *);
@property (nonatomic, copy) NSString * (^generateURL)(NSUInteger page);
@property (nonatomic, copy) void (^tableWillReload)(NSUInteger responseObjectsCount);
@property (nonatomic, copy) void (^didRefreshSucceed)();

@property Class objClass;


@property (nonatomic, assign) BOOL isRefreshAfterInit;  //在初始化后下拉是否刷新
@property (nonatomic, assign) BOOL shouldFetchDataAfterLoaded; //初始化后立马抓取数据
@property (nonatomic, assign) BOOL needRefreshAnimation;  //是否有下拉刷新动画
@property (nonatomic, assign) BOOL needCache;
@property (nonatomic, strong) NSMutableArray *objects;
@property (nonatomic, assign) int allCount;
@property (nonatomic, strong) LastCell *lastCell;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) NSUInteger page;

@property (nonatomic, assign) BOOL needAutoRefresh;  //是否自动刷新（即每次进入viewwillapper都会根据间隔时间自动刷新）
@property (nonatomic, copy) NSString *kLastRefreshTime; 
@property (nonatomic, assign) NSTimeInterval refreshInterval;

@property (nonatomic, copy) void (^anotherNetWorking)();

-(NSArray*)parseJson:(id) responseObject;
- (void)fetchMore;
- (void)refresh;

@end
