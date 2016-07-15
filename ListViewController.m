//
//  ListViewController.m
//  BigToeTimer
//
//  Created by 肖准 on 7/11/16.
//  Copyright © 2016 xiaozhun. All rights reserved.
//

#import "ListViewController.h"
#import "planMJ.h"
#import "planTableViewCell.h"
#import <SWTableViewCell.h>
#import "MBProgressHUD.h"

#import "m_date.h"
#import "planMJ.h"
static NSString * cellId = @"ListViewcell";

@interface ListViewController ()<SWTableViewCellDelegate>{
    
    NSMutableArray* _limitArr;
    NSMutableArray* _alldayArr;
    CGFloat _cellheight;
    
    NSMutableArray* _limitdateArray;
    NSMutableArray* _alldaydataArray;
    NSTimer* _timer;
}
@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation ListViewController
-(instancetype)init{
    self = [super init];
    if(self){
        _limitArr = [NSMutableArray new];
        _alldayArr = [NSMutableArray new];
        _limitdateArray = [NSMutableArray new];
        _alldaydataArray = [NSMutableArray new];
        
        
        _cellheight = 100;
        __weak ListViewController * corpctl = self;
        
        self.generateURL = ^NSString*(NSUInteger page){
            NSString* url =[NSString stringWithFormat:@"%@%@%@?userId=%@", MAIN, LIST,LIST_ALL_DATA,[NSString stringWithFormat:@"%lld",[Config getOwnID]]];
            NSLog(@"url:%@",url);
            return url;
            
        };
        
        self.tableWillReload = ^(NSUInteger count){
           
            corpctl.lastCell.status = LastCellStatusEmpty;
        };
        
        self.objClass = [planMJ class];
        //self.shouldFetchDataAfterLoaded = NO;
        self.needAutoRefresh = NO;
        self.isRefreshAfterInit  =NO;
       // self.refreshInterval = 21600;
        //self.kLastRefreshTime = @"CorporationRefreshInterval";
    }
    
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //注册cell
  
    [self.tableView registerClass:[planTableViewCell class] forCellReuseIdentifier:cellId];
    //注册消息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(planCreate:) name:PLAN_NEW object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(PlanEdit:) name:PLAN_EDIT object:nil];
    
    
    NSString* year = [NSString stringWithFormat:@"%ld年",(long)[[NSDate new] year]];
    NSString* month = [NSString stringWithFormat:@"%ld月",(long)[[NSDate new] month]];
    NSString* day = [NSString stringWithFormat:@"%ld日",(long)[[NSDate new] day]];

    self.navigationItem.title = [NSString stringWithFormat:@"%@%@%@",year,month,day];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"前一天" style:UIBarButtonItemStylePlain target:self action:@selector(preday)];
//
//    for (int i=0; i<5; i++) {
//        m_date *date = [m_date timeModelWithTime:[NSDate dateWithYear:0 month:0 day:0 hour:0 minute:0 second:((i+1)*60)]];
//        
//        [_dateArray addObject:date];
//        
//    }
    

    
}


- (void)createTimer {
    _timer = [NSTimer timerWithTimeInterval:60.0 target:self selector:@selector(timerEvent) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)timerEvent {
    for (int count = 0; count < _limitdateArray.count; count++) {
        m_date* date = (m_date*)_limitdateArray[count];
        [date countDown];
    }
    for (int count = 0; count < _alldaydataArray.count; count++) {
        m_date* date = (m_date*)_alldaydataArray[count];
        [date countDown];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TIME_CELL object:nil];
}


-(void)preday{
    NSLog(@"前一天");
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    

}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:PLAN_NEW object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:PLAN_EDIT object:nil];

    
}


#pragma mark - Table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return _limitArr.count;
    }else
        return _alldayArr.count;
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

#pragma mark plain格式下headerview 不悬浮
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 30;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return  3;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footview = [UIView new];
    footview.frame = CGRectMake(0, 0, screenwith, 22);
    return footview;

}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerview = [UIView new];
    headerview.frame = CGRectMake(0, 0, screenwith, 44);
    UILabel * titleLB = [UILabel new];
    titleLB.font=[UIFont systemFontOfSize:14];
    titleLB.textColor = [UIColor grayColor];
    [headerview addSubview:titleLB];
    if (section==0) {
        titleLB.text =  [NSString stringWithFormat:@"时限任务: %lu件",(unsigned long)_limitArr.count];// @"时限任务";
    }else if(section ==1){
        titleLB.text =[NSString stringWithFormat:@"全天任务: %lu件",(unsigned long)_alldayArr.count];;
    }
    
    [titleLB zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
    
        layout.leftSpace(10).bottomSpace(4);
        
    }];
    return headerview;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _cellheight;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    planTableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath] ;
    
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
  //  m_date* date = _dateArray[indexPath.row];
    //[cell loadTime:date indexPath:indexPath];
    if(indexPath.section==0 && _limitArr.count>0){
        cell.index = [indexPath row]+1;
        [cell loyoutWithDataAndHeight:_limitArr[indexPath.row] height:_cellheight] ;
        [cell loadTime:_limitdateArray[indexPath.row] indexPath:indexPath];
    }else if(indexPath.section==1 && _alldayArr.count>0){
        cell.index = [indexPath row]+1;
        [cell loyoutWithDataAndHeight:_alldayArr[indexPath.row] height:_cellheight] ;
        [cell loadTime:_alldaydataArray[indexPath.row] indexPath:indexPath];
    }
    
    __weak planTableViewCell* weakcell = cell;
    cell.disableCell = ^(void){
        weakcell.rightUtilityButtons = nil;
    };
    
    return cell;
}
-(NSArray*)rightButtons{
    NSMutableArray* arr = [NSMutableArray new];
   
     [arr sw_addUtilityButtonWithColor:[UIColor colorWithRed:0.936 green:0.000 blue:0.247 alpha:1.000] icon:[UIImage imageNamed:@"wrong"]];
    [arr sw_addUtilityButtonWithColor:[UIColor colorWithRed:0.365 green:0.780 blue:0.145 alpha:1.000] icon:[UIImage imageNamed:@"yes"]];
   

    return arr;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index;
{
    switch (index) {
        case 0:{
            NSLog(@"点击删除");
            UIAlertView * alert = [UIAlertView bk_showAlertViewWithTitle:@"确定取消该任务?" message:nil cancelButtonTitle:@"确定" otherButtonTitles:@[@"算了"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
               
                if(buttonIndex == 0){
                    NSIndexPath * indexpath = [self.tableView indexPathForCell:cell];
                    NSInteger section = indexpath.section;
                    NSInteger row = indexpath.row;
                    if(section == 0){
                        [_limitArr removeObjectAtIndex:row];
                        [_limitdateArray removeObjectAtIndex:row];
                        [self.tableView reloadData];
                    }else if(section == 1){
                        [_alldayArr removeObjectAtIndex:row];
                        [_alldaydataArray removeObjectAtIndex:row];
                        [self.tableView reloadData];
                    }
                    //服务器删除任务
                    NSString * url = [NSString stringWithFormat:@"%@%@%@",MAIN,LIST,PLAN_DELETE];
                    planTableViewCell* plancell = (planTableViewCell*)cell;
                    [[XZHttp sharedInstance]postWithURLString:url parameters:@{@"planName":plancell.plan.planName} success:^(id responseObject) {
                        
                        NSDictionary* res = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                        
                        NSInteger isSuccess = [((NSString*)res[@"isSuccess"]) integerValue];
                        if(isSuccess!=1){
                            NSString* errMeesage = res[@"message"];
                            _hud =[Utils createHUD];
                            _hud.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
                            _hud.mode = MBProgressHUDModeCustomView;
                            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                            _hud.labelText = errMeesage;
                            [_hud hide:YES afterDelay:1];
                        }else {
                            
                        }
                        
                    } failure:^(NSError *error) {
                         [Utils createHUDErrorWithError:error];
                    }];
                }else{
                    [cell hideUtilityButtonsAnimated:YES];
                }
            }];
            alert.delegate = self;
            [alert show];
            
            break;
        }
        case 1:{
            NSLog(@"点击完成");
            
            
            [cell hideUtilityButtonsAnimated:YES];

            break;
        }
        default:
            break;
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell{
    return YES;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    planTableViewCell *tmpCell = (planTableViewCell *)cell;
    tmpCell.isDisplay            = YES;
   
    if(indexPath.section==0){
        [tmpCell loadTime:_limitdateArray[indexPath.row] indexPath:indexPath];

    }else if(indexPath.section==1){
        [tmpCell loadTime:_alldaydataArray[indexPath.row] indexPath:indexPath];

    }
    
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
    
    planTableViewCell *tmpCell = (planTableViewCell *)cell;
    tmpCell.isDisplay = NO;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"section:%d,row:%d",indexPath.section,indexPath.row);
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(NSArray*)parseJson:(id)responseObject{
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
    NSDictionary*data = dict[@"data"];
    _limitArr = [planMJ mj_objectArrayWithKeyValuesArray:data[@"limit"]];
    _alldayArr =[planMJ mj_objectArrayWithKeyValuesArray:data[@"allday"]];
    
    
    if(_limitArr.count>0)
    {
        for (int i=0 ; i<_limitArr.count; ++i) {
            planMJ* plan =_limitArr[i];
          
            m_date* date = [m_date timeModelWithTime:plan.startTime endtime:plan.endTime];
            [_limitdateArray addObject:date];
        }
        
    }
    
    if(_alldayArr.count>0)
    {
        for (int i=0 ; i<_alldayArr.count; ++i) {
            planMJ* plan =_alldayArr[i];
            m_date* date = [m_date timeModelWithTime:plan.startTime endtime:plan.endTime];
            [_alldaydataArray addObject:date];
        }
        
    }
    [self createTimer];

    return nil;
}
    
    
    
#pragma mark - 创建plan 
-(void)planCreate:(NSNotification*)noti{
    planMJ* plan = noti.object;

    if(plan.plantype==0){
        [_limitArr addObject:plan];
        m_date* date = [m_date timeModelWithTime:plan.startTime endtime:plan.endTime];
        [_limitdateArray addObject:date];
    }else if(plan.plantype==1){
        [_alldayArr addObject:plan];
        m_date* date = [m_date timeModelWithTime:plan.startTime endtime:plan.endTime];
        [_alldaydataArray addObject:date];
    }
    [self.tableView reloadData];
    
    NSLog(@"创建plan-刷新table");
    

}

#pragma mark - 修改plan
-(void)PlanEdit:(NSNotification*)noti{
    planMJ* plan = noti.object;
    NSLog(@"修改plan-刷新table");
    
    

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
