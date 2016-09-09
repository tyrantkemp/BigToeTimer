//
//  DoneViewController.m
//  BigToeTimer
//
//  Created by 肖准 on 7/18/16.
//  Copyright © 2016 xiaozhun. All rights reserved.
//

#import "DoneViewController.h"
#import "PNChart.h"
#import "DXPopover.h"
#import "MBProgressHUD.h"
#import "DoneListTableViewController.h"

#import <POP/POP.h>

@interface DoneViewController ()<PNChartDelegate,UITableViewDataSource,UITableViewDelegate>{
    UIButton * _detailBtn;
    UILabel* _tipLB;
    NSInteger _index;
    
    UIButton* _preBtn;
    UIButton* _nextBtn;
    
    UIButton* _datePickBtn;
    //UIBarButtonItem* _datePickBtn;

    NSInteger _dateType; //0:日 默认 1：周 2:月
    UIView *_legend;
    
    
}
@property(nonatomic,strong)   PNPieChart *pieChart;
@property (nonatomic, strong) DXPopover *popover;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *configs;

@property(nonatomic,assign)NSInteger  dateindex; //日期index 0表示当前时间段 1表示想对于当前的上一个时间段 以此类推

@end

@implementation DoneViewController
-(instancetype)init{
    
    self = [super init];
    if(self){
        _index = -1;
        _dateType = 0;
        _dateindex = 0;
        
    }
    return  self;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //tableview 不扩展 只在bar和navigation之间显示 默认UIRectEdgeAll
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {self.edgesForExtendedLayout= UIRectEdgeNone;
    }
    
    self.view.backgroundColor = [UIColor colorWithRed:0.902 green:0.902 blue:0.941 alpha:1.000];
    
    //时间单位间隔 默认为日
    NSDate* now = [NSDate date];
    [self setTitleDateDay:now];

    
    //popover 日期选择 弹出
    _datePickBtn = [[UIButton alloc] initWithFrame:CGRectMake(screenwith-50, 2, 50, 40)];
    [_datePickBtn setTitle:@"日" forState:UIControlStateNormal];
    [_datePickBtn addTarget:self
                action:@selector(titleShowPopover)
      forControlEvents:UIControlEventTouchUpInside];
    [_datePickBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.navigationController.navigationBar addSubview:_datePickBtn];

    
//
//    _datePickBtn = [[UIBarButtonItem alloc]initWithTitle:@"日" style:UIBarButtonItemStylePlain target:self action:@selector(titleShowPopover)];
//    self.navigationItem.rightBarButtonItem = _datePickBtn
    
    UITableView *blueView = [[UITableView alloc] init];
    blueView.frame = CGRectMake(0, 0, 100, 150);
    blueView.dataSource = self;
    blueView.delegate = self;
    self.tableView = blueView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self resetPopover];

    self.configs = @[
                     @"日",
                     @"周",
                     @"月"
                     ];
    
    [self initsubviews];
    
    [self initPieChart];
    
}

#pragma mark - popover 弹出视图设置
- (void)resetPopover {
    self.popover = [DXPopover new];
}
- (void)titleShowPopover {
    NSLog(@"选择日期类型");
    [self updateTableViewFrame];
    
    self.popover.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.popover.backgroundColor = [UIColor whiteColor];
    UIView *titleView = _datePickBtn;


    CGPoint startPoint =
    CGPointMake(CGRectGetMidX(titleView.frame), CGRectGetMaxY(titleView.frame) + 20);
    [self.popover showAtPoint:startPoint
               popoverPostion:DXPopoverPositionDown
              withContentView:self.tableView
                       inView:self.tabBarController.view];
    __weak typeof(self) weakSelf = self;
    self.popover.didDismissHandler = ^{
        [weakSelf bounceTargetView:titleView];
    };
}
- (void)updateTableViewFrame {
    CGRect tableViewFrame = self.tableView.frame;
    tableViewFrame.size.width = 60;
    self.tableView.frame = tableViewFrame;
    self.popover.contentInset = UIEdgeInsetsZero;
    self.popover.backgroundColor = [UIColor whiteColor];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellId];
    }
    cell.textLabel.text = self.configs[indexPath.row];
    return cell;
}

#pragma mark 日期类型变更
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(_dateType!= indexPath.row){
        _dateType = indexPath.row;
       // _dateindex = 0;

        if(_dateType==1){
            [_datePickBtn setTitle:@"周" forState:UIControlStateNormal];
            [self setTitleDateWeek:[NSDate date]];
            
            
        }else if(_dateType == 2){
            [_datePickBtn setTitle:@"月" forState:UIControlStateNormal];
            [self setTitleDateMonth:[NSDate date]];
           
        }else if(_dateType == 0){
            [_datePickBtn setTitle:@"日" forState:UIControlStateNormal];
            [self setTitleDateDay:[NSDate date]];
            
        }
        
        _nextBtn.enabled = NO;
        _dateindex=0;
        [self refreshPieChart:_dateType index:_dateindex];

        
        
    }

    [self.popover dismiss];
}
- (void)bounceTargetView:(UIView *)targetView {
    targetView.transform = CGAffineTransformMakeScale(0.9, 0.9);
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.3
          initialSpringVelocity:5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         targetView.transform = CGAffineTransformIdentity;
                     }
                     completion:nil];
}


#pragma mark - 初始化PieChart
-(void)initPieChart{
    
    NSString* url = [NSString stringWithFormat:@"%@%@%@?userId=%lld&type=%d&index=%d",MAIN,LIST,PLAN_GET_MONTH,[Config getOwnID],0,0];
  
    [Utils showHudInView:self.view hint:@"玩命加载中..."];
    
    [[XZHttp sharedInstance]getWithURLString:url parameters:nil success:^(id responseObject) {
        [Utils hideHud];
        NSDictionary* data = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSInteger isSuccess = [(NSString*)data[@"isSuccess"] integerValue];
        // 登陆失败 isSuccess == 0
        if(isSuccess != 1){
            NSString* errMeesage = data[@"message"];
       
            [Utils showHUDWithErrorMsg:errMeesage];
            return;
        }else {
            
            
            NSDictionary *dict = data[@"data"];
            CGFloat normal = [(NSString*)dict[@"normal"] floatValue];
            CGFloat early = [(NSString*)dict[@"early"] floatValue];
            CGFloat overtime = [(NSString*)dict[@"overtime"] floatValue];
            
            NSInteger normal_num = [dict[@"normal_num"] integerValue];
            NSInteger early_num = [dict[@"early_num"] integerValue];
            NSInteger overtime_num = [dict[@"overtime_num"] integerValue];


            
            NSArray *items = @[[PNPieChartDataItem dataItemWithValue:normal color:[UIColor colorWithRed:0.000 green:1.000 blue:0.000 alpha:1.0] description:[NSString stringWithFormat:@"时限内完成: %d 件",normal_num]],
                               [PNPieChartDataItem dataItemWithValue:overtime color:[UIColor colorWithRed:1.000 green:0.000 blue:0.000 alpha:1.0] description:[NSString stringWithFormat:@"超时未完成: %d 件",overtime_num]],
                               [PNPieChartDataItem dataItemWithValue:early color:[UIColor colorWithRed:0.996 green:0.792 blue:0.086 alpha:1.000] description:[NSString stringWithFormat:@"提前完成: %d 件",early_num]],
                               ];
            
            self.pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(screenwith/6, 50.0, screenwith/3*2, screenwith/3*2) items:items];
            self.pieChart.descriptionTextColor = [UIColor whiteColor];
            self.pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:14.0];
            [self.pieChart strokeChart];
            self.pieChart.descriptionTextShadowColor = [UIColor clearColor];
            self.pieChart.showAbsoluteValues = NO;
            self.pieChart.showOnlyValues = YES;
            self.pieChart.delegate =self;
            self.pieChart.legendStyle = PNLegendItemStyleStacked;
            self.pieChart.legendFont = [UIFont boldSystemFontOfSize:14.0f];
            
            _legend = [self.pieChart getLegendWithMaxWidth:200];
            [_legend setFrame:CGRectMake(screenwith/2-50,70+screenwith/3*2, _legend.frame.size.width, _legend.frame.size.height)];
            [self.view addSubview:_legend];
            [self.view addSubview:self.pieChart];


            [_detailBtn setBackgroundColor:[UIColor colorWithRed:0.365 green:0.780 blue:0.145 alpha:0.317]];
            
            _detailBtn.enabled=NO;
            
        }
    } failure:^(NSError *error) {
        
        [Utils showHUDWithError:error];

    }];
    
    
    
   
    
}

#pragma mark - 初始化子视图


-(void)initsubviews{
    
    
    
    
    
    
    //详细信息查询
    _detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_detailBtn setImage:[UIImage imageNamed:@"detail_info_normal"] forState:UIControlStateNormal];
    [_detailBtn setBackgroundColor:[UIColor colorWithRed:0.365 green:0.780 blue:0.145 alpha:0.317]];
    [self.view addSubview:_detailBtn];
    [_detailBtn zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.widthValue(64).heightValue(64).bottomSpace(25).leftSpace(25);
    }];
    _detailBtn.enabled = NO;
    [_detailBtn.layer setCornerRadius:32];
    [_detailBtn addTarget:self action:@selector(detailPress:) forControlEvents:UIControlEventTouchUpInside];
    
    //按钮解释
    _tipLB = [UILabel new];
    _tipLB.text = @"注:点击查看详细任务列表";
    _tipLB.textColor = [UIColor lightGrayColor];
    _tipLB.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:_tipLB];
    [_tipLB zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.leftSpaceByView(_detailBtn,10).bottomSpaceEqualTo(_detailBtn,0);
    }];
    
    
    //上个时间单位
    _preBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_preBtn setImage:[UIImage imageNamed:@"pre_normal"] forState:UIControlStateNormal];
    [_preBtn setBackgroundColor:[UIColor colorWithRed:0.365 green:0.780 blue:0.145 alpha:1.000]];
    [self.view addSubview:_preBtn];
    [_preBtn zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.widthValue(48).heightValue(48).topSpace(15).leftSpace(15);
    }];
    [_preBtn.layer setCornerRadius:24];
    [_preBtn addTarget:self action:@selector(prePress:) forControlEvents:UIControlEventTouchUpInside];
    
    //下个时间单位
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nextBtn setImage:[UIImage imageNamed:@"next_normal"] forState:UIControlStateNormal];
    [_nextBtn setBackgroundColor:[UIColor colorWithRed:0.996 green:0.792 blue:0.086 alpha:1.000]];
    [self.view addSubview:_nextBtn];
    _nextBtn.enabled = NO;
    [_nextBtn zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.widthValue(48).heightValue(48).topSpace(15).rightSpace(15);
    }];
    [_nextBtn.layer setCornerRadius:24];
    [_nextBtn addTarget:self action:@selector(nextPress:) forControlEvents:UIControlEventTouchUpInside];
    

}
#pragma  mark - 查看详情
-(void)detailPress:(UIButton*)sender{
    NSLog(@"查看详细");
    
    
    DoneListTableViewController* donectl = [DoneListTableViewController new];
    donectl.type =_dateType;
    donectl.index =_dateindex;
    donectl.plantype = _index;
    if(_index==0){
        donectl.navigationItem.title=@"时限内完成";
        
    }else if(_index ==1 ){
        donectl.navigationItem.title=@"超时未完成";
    }else if(_index==2){
        donectl.navigationItem.title=@"提前完成";

    }
    donectl.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:donectl animated:YES];
    
    
}
#pragma  mark - 上个时间段
-(void)prePress:(UIButton*)sender{
    
    
    NSLog(@"前一个时间段");
    _dateindex++;
    if(_dateindex>0){
        _nextBtn.enabled = YES;
    }
    if(_dateType==1){
        [self setTitleDateWeek:[[NSDate date] dateBySubtractingWeeks:_dateindex]];
        
    }else if(_dateType==2) {
        [self setTitleDateMonth:[[NSDate date] dateBySubtractingMonths:_dateindex]];

    }else if(_dateType==0){
        [self setTitleDateDay:[[NSDate date] dateBySubtractingDays:_dateindex]];

    }

    [self refreshPieChart:_dateType index:_dateindex];

    

    
}
#pragma  mark - 下个时间段
-(void)nextPress:(UIButton*)sender{
    
    NSLog(@"后一时间段");
    _dateindex--;
    if (_dateindex==0) {
        _nextBtn.enabled = NO;
    }
    if(_dateType==1){
        [self setTitleDateWeek:[[NSDate date] dateBySubtractingWeeks:_dateindex]];
        
    }else if(_dateType==2) {
        [self setTitleDateMonth:[[NSDate date] dateBySubtractingMonths:_dateindex]];
        
    }else if(_dateType==0){
        [self setTitleDateDay:[[NSDate date] dateBySubtractingDays:_dateindex]];
        
    }

    [self refreshPieChart:_dateType index:_dateindex];
    
}


- (void)userClickedOnPieIndexItem:(NSInteger)pieIndex{
    
    NSLog(@"pieindex:%ld",(long)pieIndex);
    _index = pieIndex;
    
    if(_index!=-1){
        
        _detailBtn.enabled = YES;
        [_detailBtn setBackgroundColor:[UIColor colorWithRed:0.365 green:0.780 blue:0.145 alpha:1.000]];
        
        
        
        
        
    }
    
    
}

#pragma mark - 设置title的时间 星期
-(void)setTitleDateWeek:(NSDate*)date{
    NSInteger weekindex = [date weekday];
    NSDate* startday = [date dateBySubtractingDays:weekindex-1];
    NSDate* endday = [date dateByAddingDays:7-weekindex];
    NSLog(@"星期:%ld",(long)weekindex);
    NSString* title = [NSString stringWithFormat:@"%@-%@",[startday currentTimeStringMD],[endday currentTimeStringMD]];
    self.navigationItem.title = title;
}
#pragma mark - 设置title的时间 月份
-(void)setTitleDateMonth:(NSDate*)date{
    NSString * month = [date currentTimeStringYM];
    NSLog(@"月份:%@",month);
    NSString* title = month;
    self.navigationItem.title = title;
}

#pragma mark - 设置title的时间 月份
-(void)setTitleDateDay:(NSDate*)date{
    
    NSString * day = [date currentTimeStringYMD];
    NSLog(@"日期:%@",day);
    
    self.navigationItem.title = day;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    _datePickBtn.hidden= YES;
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _datePickBtn.hidden= NO;

}
#pragma  mark - 跟新piechart图
-(void)refreshPieChart:(NSInteger)type index:(NSInteger)index{
 
    
    NSString* url = [NSString stringWithFormat:@"%@%@%@?userId=%lld&type=%d&index=%d",MAIN,LIST,PLAN_GET_MONTH,[Config getOwnID],type,index];
    
    [Utils showHudInView:self.view hint:@"玩命拉取数据中..."];
    
    [[XZHttp sharedInstance]getWithURLString:url parameters:nil success:^(id responseObject) {
        [Utils hideHud];
        NSDictionary* data = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSInteger isSuccess = [(NSString*)data[@"isSuccess"] integerValue];
        // 登陆失败 isSuccess == 0
        if(isSuccess != 1){
            NSString* errMeesage = data[@"message"];
           
            [Utils showHUDWithErrorMsg:errMeesage];
            return;
        }else {
            
            
            NSDictionary *dict = data[@"data"];
            CGFloat normal = [(NSString*)dict[@"normal"] floatValue];
            CGFloat early = [(NSString*)dict[@"early"] floatValue];
            CGFloat overtime = [(NSString*)dict[@"overtime"] floatValue];

            
            NSInteger normal_num = [dict[@"normal_num"] integerValue];
            NSInteger early_num = [dict[@"early_num"] integerValue];
            NSInteger overtime_num = [dict[@"overtime_num"] integerValue];
            
            
            
            NSArray *items = @[[PNPieChartDataItem dataItemWithValue:normal color:[UIColor colorWithRed:0.000 green:1.000 blue:0.000 alpha:1.0] description:[NSString stringWithFormat:@"时限内完成: %d 件",normal_num]],
                               [PNPieChartDataItem dataItemWithValue:overtime color:[UIColor colorWithRed:1.000 green:0.000 blue:0.000 alpha:1.0] description:[NSString stringWithFormat:@"超时未完成: %d 件",overtime_num]],
                               [PNPieChartDataItem dataItemWithValue:early color:[UIColor colorWithRed:0.996 green:0.792 blue:0.086 alpha:1.000] description:[NSString stringWithFormat:@"提前完成: %d 件",early_num]],
                               ];
            
            
            [self.pieChart updateChartData:items];
            [self.pieChart strokeChart];
            [_legend removeFromSuperview];
            
            _legend = [self.pieChart getLegendWithMaxWidth:200];
            [_legend setFrame:CGRectMake(screenwith/2-50,70+screenwith/3*2, _legend.frame.size.width, _legend.frame.size.height)];
            [self.view addSubview:_legend];
            [self.view addSubview:self.pieChart];
            
            [_detailBtn setBackgroundColor:[UIColor colorWithRed:0.365 green:0.780 blue:0.145 alpha:0.317]];

            _detailBtn.enabled=NO;

        }
    } failure:^(NSError *error) {
       
        [Utils showHUDWithError:error];

        
    }];
    
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
