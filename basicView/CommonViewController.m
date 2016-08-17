//
//  OSCObjsViewController.m
//  iosapp
//
//  Created by chenhaoxiang on 10/27/14.
//  Copyright (c) 2014 oschina. All rights reserved.
//

#import "CommonViewController.h"
#import "LastCell.h"
#import <MBProgressHUD.h>

@interface CommonViewController (){
    BOOL _temp_isRefreshAfterInit;
}

@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSDate *lastRefreshTime;

@end


@implementation CommonViewController


- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _objects = [NSMutableArray new];
        _page = 0;
        _needRefreshAnimation = YES;
        _shouldFetchDataAfterLoaded = YES;
        _temp_isRefreshAfterInit = YES;
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //tableview 不扩展 只在bar和navigation之间显示 默认UIRectEdgeAll
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {self.edgesForExtendedLayout= UIRectEdgeNone;
    }

    self.tableView.backgroundColor = [UIColor themeColor];
    
    
    //tableview的footerview 显示当前展示内容的状态
    _lastCell = [[LastCell alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 44)];
    [_lastCell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fetchMore)]];
    _lastCell.textLabel.textColor = [UIColor titleColor];
    self.tableView.tableFooterView = _lastCell;
    
    //下拉刷新的view
    self.tableView.mj_header = ({
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        header;
    });
    
    _label = [UILabel new];
    _label.numberOfLines = 0;
    _label.lineBreakMode = NSLineBreakByWordWrapping;
    _label.font = [UIFont boldSystemFontOfSize:14];
    
    
    /*** 自动刷新 ***/
    if (_needAutoRefresh) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
        _lastRefreshTime = [_userDefaults objectForKey:_kLastRefreshTime];
        
        if (!_lastRefreshTime) {
            _lastRefreshTime = [NSDate date];
            [_userDefaults setObject:_lastRefreshTime forKey:_kLastRefreshTime];
        }
    }
    
    
    //_manager = [AFHTTPRequestOperationManager OSCManager];
    _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    _manager = [AFHTTPSessionManager manager];
    /**
     *  可以接受的类型
     */
   // _manager.responseSerializer = [AFHTTPRequestSerializer serializer];
    
    if (!_shouldFetchDataAfterLoaded) {return;}
    if (_needRefreshAnimation) {
        [self.tableView.mj_header beginRefreshing];
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y-self.refreshControl.frame.size.height)
                                animated:YES];
    }
    
    if (_needCache) {
        _manager.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    }
    [self fetchObjectsOnPage:0 refresh:YES];
    _temp_isRefreshAfterInit = _isRefreshAfterInit ;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_needAutoRefresh) {
        NSDate *currentTime = [NSDate date];
        if ([currentTime timeIntervalSinceDate:_lastRefreshTime] > _refreshInterval) {
            _lastRefreshTime = currentTime;
            
            [self refresh];
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"dawnAndNight" object:nil];
}



-(void)dawnAndNightMode:(NSNotification *)center
{
    _lastCell.textLabel.backgroundColor = [UIColor themeColor];
    _lastCell.textLabel.textColor = [UIColor titleColor];

}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.tableView.separatorColor = [UIColor separatorColor];
    
    return _objects.count;
}



#pragma mark - 刷新

- (void)refresh
{
    
    if(_temp_isRefreshAfterInit){
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _manager.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
        [self fetchObjectsOnPage:0 refresh:YES];
    });
    
    //刷新时，增加另外的网络请求功能
    if (self.anotherNetWorking) {
        self.anotherNetWorking();
    }
    }else{
        
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
        }
    }
}


#pragma mark - 上拉加载更多

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height - 150)) {        
        [self fetchMore];
    }
}

- (void)fetchMore
{
    if (!_lastCell.shouldResponseToTouch) {return;}
    
    _lastCell.status = LastCellStatusLoading;
    _manager.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    [self fetchObjectsOnPage:++_page refresh:NO];
}


#pragma mark - 请求数据

- (void)fetchObjectsOnPage:(NSUInteger)page refresh:(BOOL)refresh
{
   
    [[XZHttp sharedInstance] getWithURLString:self.generateURL(page) parameters:nil success:^(id responseObject) {
        //获得服务器传入的数据
        NSArray* objectJson = [self parseJson:responseObject];
        NSInteger count = [objectJson count];

        if(refresh){
            _page = 0;
            [_objects removeAllObjects];
            if(_didRefreshSucceed){
                _didRefreshSucceed();
                
            }
        }
        
        for(NSObject* item in objectJson){
            if([_objects containsObject:item]){
                continue;
            }else {
                [_objects addObject:item];
            }
            
        }
        
        if (_needAutoRefresh) {
            [_userDefaults setObject:_lastRefreshTime forKey:_kLastRefreshTime];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.tableWillReload) {self.tableWillReload(count);}
            else {
                if (_page == 0 && count == 0) {
                    _lastCell.status = LastCellStatusEmpty;
                } else if (count == 0 || (_page == 0 && count < 20)) {
                    _lastCell.status = LastCellStatusFinished;
                } else {
                    _lastCell.status = LastCellStatusMore;
                }
            }
            
            if (self.tableView.mj_header.isRefreshing) {
                [self.tableView.mj_header endRefreshing];
            }
            
            [self.tableView reloadData];
        });
        
        
    } failure:^(NSError *error) {
        
  
        [Utils showHUDWithError:error];
        
        _lastCell.status = LastCellStatusError;
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
        }
        [self.tableView reloadData];
        
    }];
  
}


-(NSArray*)parseJson:(id) responseObject{
    NSAssert(false, @"Over ride in subclasses");
    return nil;
}

@end
