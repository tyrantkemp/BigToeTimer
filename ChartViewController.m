//
//  ChartViewController.m
//  BigToeTimer
//
//  Created by 肖准 on 7/19/16.
//  Copyright © 2016 xiaozhun. All rights reserved.
//

#import "ChartViewController.h"
#import "PNChart.h"
#import "DXPopover.h"
#import "MBProgressHUD.h"
#import "MenuView.h"

@interface ChartViewController ()<PNChartDelegate,UIGestureRecognizerDelegate>{
    UIView* _maskView;
    MenuView * _menuview;
    BOOL _isPresswd;
    NSString* _dateType;
}


@property(nonatomic,strong)PNLineChart* lineChart;
@property(nonatomic,strong)UIBarButtonItem* dateTypeBtn;


@end

@implementation ChartViewController
-(instancetype)init{
    self = [super init];
    if(self){
        
        _isPresswd = NO;
        _dateType=@"week_3";
    

    }
    return  self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //tableview 不扩展 只在bar和navigation之间显示 默认UIRectEdgeAll
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {self.edgesForExtendedLayout= UIRectEdgeNone;
    }
    self.view.backgroundColor = [UIColor colorWithRed:0.902 green:0.902 blue:0.941 alpha:1.000];

    self.navigationItem.title =[[NSDate date] currentTimeStringYMD];
    
    UIBarButtonItem* blank = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(blank)];
    _dateTypeBtn =[[UIBarButtonItem alloc]initWithTitle:@"三周" style:UIBarButtonItemStylePlain target:self action:@selector(dateTypePress:)];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:_dateTypeBtn,blank,nil];
    
    [self initMask];

    [self initLineChart];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}
-(void)initLineChart{
    self.lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 60.0, screenwith, screenheight/2-60)];
    self.lineChart.yLabelFormat = @"%1.1f";
    self.lineChart.backgroundColor = [UIColor clearColor];
    [self.lineChart setXLabels:@[@"",@"",@""]];
    self.lineChart.showCoordinateAxis = YES;
    
    // added an examle to show how yGridLines can be enabled
    // the color is set to clearColor so that the demo remains the same
    //    self.lineChart.yGridLinesColor = [UIColor lightGrayColor];
    //    self.lineChart.showYGridLines = YES;
    self.lineChart.showGenYLabels = YES;
    self.lineChart.showCoordinateAxis=YES;
    
    
    //Use yFixedValueMax and yFixedValueMin to Fix the Max and Min Y Value
    //Only if you needed
    self.lineChart.yFixedValueMax = 100.0;
    self.lineChart.yFixedValueMin = 0.0;
    
    [self.lineChart setYLabels:@[
                                 @"0",
                                 @"20",
                                 @"40",
                                 @"60",
                                 @"80",
                                 @"100%"
                                 ]
     ];
    
    
    

    [Utils showHudInView:self.view hint:@"玩命拉取数据中..."];

    
     NSString* url = [NSString stringWithFormat:@"%@%@%@?userId=%lld&dateType=%@",MAIN,LIST,PLAN_GET_LINE_CHART,[Config getOwnID],@"week_3"];
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
            
            
            NSArray* arr = data[@"data"];
            NSMutableArray * arr1 = [NSMutableArray new];
            NSMutableArray * arr2 = [NSMutableArray new];
            NSMutableArray * arr3 = [NSMutableArray new];
            
            for (int i=0; i<arr.count; ++i) {
                NSDictionary* dict = arr[i];
                [arr1 addObject:dict[@"early"]];
                [arr2 addObject:dict[@"normal"]];
                [arr3 addObject:dict[@"overtime"]];
            }
            NSMutableArray* xarr = [NSMutableArray arrayWithCapacity:arr.count];
            for (int j=0; j<arr.count; ++j) {
                [xarr addObject:@""];
            }
            
            [self.lineChart setXLabels:xarr];
            
            //提前完成
            
            PNLineChartData *data01 = [PNLineChartData new];
            data01.dataTitle = @"提前完成";
            data01.color = [UIColor colorWithRed:0.996 green:0.792 blue:0.086 alpha:1.000];
            data01.alpha = 0.3f;
            data01.itemCount = arr1.count;
            // data01.inflexionPointColor = PNRed;
            data01.inflexionPointStyle = PNLineChartPointStyleTriangle;
            data01.getData = ^(NSUInteger index) {
                CGFloat yValue = [arr1[index] floatValue];
                return [PNLineChartDataItem dataItemWithY:yValue];
            };
            
            //时限内完成
            
            PNLineChartData *data02 = [PNLineChartData new];
            data02.dataTitle = @"时限内完成";
            data02.color = [UIColor greenColor];
            data02.alpha = 0.5f;
            data02.itemCount = arr2.count;
            data02.inflexionPointStyle = PNLineChartPointStyleSquare;
            data02.getData = ^(NSUInteger index) {
                CGFloat yValue = [arr2[index] floatValue];
                return [PNLineChartDataItem dataItemWithY:yValue];
            };
            
            //超时
            
            PNLineChartData *data03 = [PNLineChartData new];
            data03.dataTitle = @"超时";
            data03.color = [UIColor redColor];
            data03.alpha = 0.5f;
            data03.itemCount = arr3.count;
            data03.inflexionPointStyle = PNLineChartPointStyleCircle;
            data03.getData = ^(NSUInteger index) {
                CGFloat yValue = [arr3[index] floatValue];
                return [PNLineChartDataItem dataItemWithY:yValue];
            };
            
            self.lineChart.chartData = @[data01, data02,data03];
            [self.lineChart strokeChart];
            self.lineChart.delegate = self;
            
            
            [self.view addSubview:self.lineChart];
            
            self.lineChart.legendStyle = PNLegendItemStyleStacked;
            self.lineChart.legendFont = [UIFont boldSystemFontOfSize:14.0f];
            self.lineChart.legendFontColor = [UIColor lightGrayColor];
            
            UIView *legend = [self.lineChart getLegendWithMaxWidth:320];
            [legend setFrame:CGRectMake(30, 340, legend.frame.size.width, legend.frame.size.width)];
            [self.view addSubview:legend];
            

            
            
        }
    } failure:^(NSError *error) {
        [Utils showHUDWithError:error];
        
    }];
    
    
}
-(void)dateTypePress:(UIBarButtonItem*)sender{
    if(_isPresswd){
        [self catohidden];
        
    }else {
        [self catoshow];
        
    }
}
#pragma  mark - 遮盖层
-(void)initMask{
    
    _maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenwith, screenheight)];
    _maskView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.352];
    [self.view addSubview:_maskView];
    _maskView.hidden = YES;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMaskView:)];
    tap.delegate = self;
    [_maskView addGestureRecognizer:tap];
    
    _menuview = [[MenuView alloc]initWithFrame:CGRectMake(0, 0, screenwith, 120)];
    _menuview.backgroundColor =[UIColor whiteColor];
    __weak typeof(self) weakself= self;
    _menuview.didselectAtrowWithId = ^(NSString* Id,NSString* name){
        NSLog(@"点击:%@",Id);
        [weakself catohidden];
        [weakself.dateTypeBtn setTitle:name];
        _dateType = Id;
        
        NSString* url = [NSString stringWithFormat:@"%@%@%@?userId=%lld&dateType=%@",MAIN,LIST,PLAN_GET_LINE_CHART,[Config getOwnID],Id];
        [weakself refreshLingChart:url];
        
    };
    
    [_maskView addSubview:_menuview];
    
}
#pragma mark - 课程类别
-(void)catohidden{
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFromTop;
    animation.duration = 0.2;
    [_maskView.layer addAnimation:animation forKey:nil];
    _maskView.hidden = YES;
    _menuview.hidden = YES;
    _isPresswd=NO;

}
-(void)catoshow{
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFromBottom;
    animation.duration = 0.2;
    [_maskView.layer addAnimation:animation forKey:nil];
    _maskView.hidden = NO;
    [self.view bringSubviewToFront:_maskView];
    _menuview.hidden = NO;
    _isPresswd=YES;

}
#pragma mark - 手势 delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    CGPoint p = [touch locationInView:_maskView];
    if(CGRectContainsPoint (_menuview.frame, p)){
        return NO;
    }
    return YES;
}

- (void)userClickedOnLinePoint:(CGPoint)point lineIndex:(NSInteger)lineIndex;
{
    
}
- (void)userClickedOnLineKeyPoint:(CGPoint)point
                        lineIndex:(NSInteger)lineIndex
                       pointIndex:(NSInteger)pointIndex;
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)blank{
    
}
-(void)tapMaskView:(UITapGestureRecognizer*) sender{
    _maskView.hidden = YES;
    _isPresswd = NO;
}

#pragma mark - 获取数据刷新 linechart
-(void)refreshLingChart:(NSString*)url{
    
    NSLog(@"linechart:%@",url);
    
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
            
        
            NSArray* arr = data[@"data"];
            NSMutableArray * arr1 = [NSMutableArray new];
            NSMutableArray * arr2 = [NSMutableArray new];
            NSMutableArray * arr3 = [NSMutableArray new];

            for (int i=0; i<arr.count; ++i) {
                NSDictionary* dict = arr[i];
                [arr1 addObject:dict[@"early"]];
                [arr2 addObject:dict[@"normal"]];
                [arr3 addObject:dict[@"overtime"]];
            }
            NSMutableArray* xarr = [NSMutableArray arrayWithCapacity:arr.count];
            for (int j=0; j<arr.count; ++j) {
                [xarr addObject:@""];
            }
        
            [self.lineChart setXLabels:xarr];
      
            //提前完成
           
            PNLineChartData *data01 = [PNLineChartData new];
            data01.dataTitle = @"提前完成";
            data01.color = [UIColor colorWithRed:0.996 green:0.792 blue:0.086 alpha:1.000];
            data01.alpha = 0.3f;
            data01.itemCount = arr1.count;
            // data01.inflexionPointColor = PNRed;
            data01.inflexionPointStyle = PNLineChartPointStyleTriangle;
            data01.getData = ^(NSUInteger index) {
                CGFloat yValue = [arr1[index] floatValue];
                return [PNLineChartDataItem dataItemWithY:yValue];
            };
            
            //时限内完成
           
            PNLineChartData *data02 = [PNLineChartData new];
            data02.dataTitle = @"时限内完成";
            data02.color = [UIColor greenColor];
            data02.alpha = 0.5f;
            data02.itemCount = arr2.count;
            data02.inflexionPointStyle = PNLineChartPointStyleSquare;
            data02.getData = ^(NSUInteger index) {
                CGFloat yValue = [arr2[index] floatValue];
                return [PNLineChartDataItem dataItemWithY:yValue];
            };
            
            //超时
           
            PNLineChartData *data03 = [PNLineChartData new];
            data03.dataTitle = @"超时";
            data03.color = [UIColor redColor];
            data03.alpha = 0.5f;
            data03.itemCount = arr3.count;
            data03.inflexionPointStyle = PNLineChartPointStyleCircle;
            data03.getData = ^(NSUInteger index) {
                CGFloat yValue = [arr3[index] floatValue];
                return [PNLineChartDataItem dataItemWithY:yValue];
            };

            self.lineChart.chartData = @[data01, data02,data03];
            [self.lineChart strokeChart];
            
            
        
        
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
