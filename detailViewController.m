//
//  detailViewController.m
//  BigToeTimer
//
//  Created by 肖准 on 7/13/16.
//  Copyright © 2016 xiaozhun. All rights reserved.
//

#import "detailViewController.h"
#import "planMJ.h"
#import "MBProgressHUD.h"


@interface detailViewController ()<UITextViewDelegate,UIGestureRecognizerDelegate>{
    UIButton* _quitBtn;
    UIButton* _saveBtn;
    UITextView* _contentTV;
    UILabel* _placehoder;
    
    UIButton* _starttimeBtn;
    UIButton* _endtimeBtn;
    
    UIView* _backview;
    UIDatePicker* _picker;
    UIButton* _okBtn;
    
    NSDate* _starttimeDate;
    NSDate* _endtimeDate;

    
    UILabel* _title;
    BOOL _isStart; //判断点击按钮类型 默认为开始按钮
}
@property (nonatomic, strong) MBProgressHUD *hud;


@end

@implementation detailViewController
-(instancetype)init{
    self = [super init];
    if(self){
        _isStart = YES;
        _plantype = PlanTypeLimited;
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.851 green:0.965 blue:0.941 alpha:1.000];


    [self inisubviews];
    [self setlayout];

    [self plantypeConfig];
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    gesture.delegate = self;
    [self.view addGestureRecognizer:gesture];
    // Do any additional setup after loading the view.
}
-(void)inisubviews{
   
    
    _quitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_quitBtn setBackgroundImage:[UIImage imageNamed:@"quit_normal"] forState:UIControlStateNormal];
    [_quitBtn setBackgroundImage:[UIImage imageNamed:@"quit_pressed"] forState:UIControlStateHighlighted];
    [_quitBtn addTarget:self action:@selector(quit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_quitBtn];
    
    
    _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_saveBtn setBackgroundImage:[UIImage imageNamed:@"save_normal"] forState:UIControlStateNormal];
    [_saveBtn setBackgroundImage:[UIImage imageNamed:@"save_pressed"] forState:UIControlStateHighlighted];
    [_saveBtn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_saveBtn];

    //标题
//    _title = [UILabel new];
//    _title.font = [UIFont boldSystemFontOfSize:20];
//    _title.textColor = [UIColor lightGrayColor];
//    _title.text =@"限时";
//    [self.view addSubview:_title];
    
    //任务内容
    _contentTV = [UITextView new];
    _contentTV.font = [UIFont systemFontOfSize:16];
    _contentTV.textColor= [UIColor blackColor];
    _contentTV.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _contentTV.delegate = self;
    _contentTV.backgroundColor = [UIColor colorWithRed:0.910 green:0.914 blue:0.635 alpha:1.000];
    [self.view addSubview:_contentTV];
    
    //任务栏占位
    _placehoder = [UILabel new];
    _placehoder.text = @"从此输入任务...";
    _placehoder.textColor=[UIColor lightGrayColor];
    _placehoder.enabled =NO;
    _placehoder.backgroundColor = [UIColor clearColor];
    [_contentTV addSubview:_placehoder];
    
    
    //开始时间
    _starttimeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _starttimeBtn.tag = 10000;
    _starttimeBtn.backgroundColor = [UIColor colorWithRed:0.365 green:0.780 blue:0.145 alpha:1.000];
    [_starttimeBtn setTitle:@"开始时间" forState:UIControlStateNormal];
    [_starttimeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [_starttimeBtn addTarget:self action:@selector(starttime:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_starttimeBtn];
    
    //结束时间
    _endtimeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _endtimeBtn.tag =10001;
    _endtimeBtn.backgroundColor = [UIColor redColor];
    [_endtimeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [_endtimeBtn setTitle:@"结束时间" forState:UIControlStateNormal]; //];= @"开始时间";
    [_endtimeBtn addTarget:self action:@selector(endtime:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_endtimeBtn];
    
    
    //时间选择器背景视图
    _backview = [UIView new];
    _backview.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
    _backview.hidden = YES;
    [self.view addSubview:_backview];
    
    //时间选择器
    _picker = [[UIDatePicker alloc]init];
    _picker.minimumDate = [NSDate date];
    _picker.datePickerMode = UIDatePickerModeTime;
    [_picker addTarget:self action:@selector(pickerChange:) forControlEvents:UIControlEventValueChanged];
    
    [_backview addSubview:_picker];
    
    //选择时间btn
//    _okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_okBtn setBackgroundImage:[UIImage imageNamed:@"time_save_normal"] forState:UIControlStateNormal];
//    [_okBtn addTarget:self action:@selector(timeSave:) forControlEvents:UIControlEventTouchUpInside];
    //[_backview addSubview:_okBtn];

}

-(void)setlayout{
    [_quitBtn zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.leftSpace(15).topSpace(25).widthValue(25).heightValue(25);
    }];
    [_saveBtn zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.rightSpace(15).topSpace(25).widthValue(25).heightValue(25);
    }];
    
//    [_title zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
//        layout.topSpaceEqualTo(_quitBtn,0).widthValue(100).leftSpace(screenwith/2-50);
//    }];
    
    [_contentTV zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.topSpaceByView(_quitBtn,20).leftSpace(15).rightSpace(15).heightValue(screenheight/5*2);
    }];
    
    [_placehoder zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.leftSpace(2).topSpace(4);
    }];
    
    [_starttimeBtn zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.leftSpace(15).topSpaceByView(_contentTV,10).heightValue(50).widthValue((screenwith-30)/8*3.5);
    }];
    
    [_endtimeBtn zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.rightSpace(15).topSpaceByView(_contentTV,10).heightValue(50).widthValue((screenwith-30)/8*3.5);
    }];
    
    [_backview zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.topSpaceByView(_endtimeBtn,10).bottomSpace(10).leftSpace(20).rightSpace(20);
    }];
    _backview.bounds=CGRectMake(0, 0, screenwith-40, screenheight-50-20-screenheight/5*2-10-50-10-10);
    
    NSLog(@"frame:%@",NSStringFromCGRect(_backview.frame));
    _picker.frame = CGRectMake(10, 0, _backview.frame.size.width-20, _backview.frame.size.height);
    
//    [_okBtn zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
//        layout.bottomSpace(0).heightValue(20).widthValue(20).leftSpace(_backview.frame.size.width/2-10);
//    }];
    
    
}
#pragma mark - 计划不同类型的设置
-(void)plantypeConfig{
    //全天类型
    if(_plantype == PlanTypeAllDay){
       // _title.text = @"全天";
        _starttimeDate = [NSDate date];
        [_starttimeBtn setTitle:[_starttimeDate currentTimeStringHM] forState:UIControlStateNormal];
   
        [_starttimeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _endtimeDate = [NSDate dateWithYear:0 month:0 day:0 hour:23  minute:59 second:59];
        [_endtimeBtn setTitle:[_endtimeDate currentTimeStringHM] forState:UIControlStateNormal];
        [_endtimeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

        _starttimeBtn.enabled = NO;
        _endtimeBtn.enabled = NO;
    }
}
-(void)textViewDidChange:(UITextView *)textView
{
    NSString* content =  textView.text;
    if (content.length == 0) {
        _placehoder.text = @"从此输入任务...";
    }else{
        _placehoder.text = @"";
    }
}

#pragma mark - 退出
-(void)quit:(UIButton*)sender{
    NSLog(@"退出");
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}
#pragma mark - 保存
-(void)save:(UIButton*)sender{
    NSLog(@"计划保存");
    NSString* content = [_contentTV.text StringWithoutEmpty];
    
    if(![content isNullOrEmpty] && _starttimeDate!=nil && _endtimeDate!=nil){
        

        _hud = [Utils createHUD];
        _hud.labelText= @"保存中...";
        _hud.userInteractionEnabled = NO;
        [_hud show:YES];
        
        planMJ* plan = [planMJ new];
        plan.content = content;
        plan.startTime = [_starttimeDate minuteTime];
        plan.endTime = [_endtimeDate minuteTime];
        plan.plantype = _plantype;

        NSDate * now = [NSDate date];
        plan.planName = [NSString stringWithFormat:@"%lld_%d_%d_%d_%d_%d_%d",[Config getOwnID],[now year],[now month],[now day],[now hour],[now minute],[now second]];
       
        NSString* url = [NSString stringWithFormat:@"%@%@%@",MAIN,LIST,PLAN_CREATE];
        
        [self saveOrUpdatePlan:url data:plan];

        
    }else if([content isNullOrEmpty]){
        UIAlertView* alert = [UIAlertView bk_showAlertViewWithTitle:nil message:@"任务内容不能为空" cancelButtonTitle:@"OK" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            
        }];
        alert.delegate = self;
        [alert show];
    }else if(_starttimeDate==nil || _endtimeDate==nil){
        UIAlertView* alert = [UIAlertView bk_showAlertViewWithTitle:nil message:@"开始或结束时间不能为空" cancelButtonTitle:@"OK" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            
        }];
        alert.delegate = self;
        [alert show];
    }
    
}

#pragma mark - 上传plan 新建或更改
-(void)saveOrUpdatePlan:(NSString*)url data:(planMJ*)plan{
    NSLog(@"创建任务url:%@",url);
    //成功 退出页面
    [self dismissViewControllerAnimated:YES completion:^{
        
        [[NSNotificationCenter defaultCenter]postNotificationName:PLAN_NEW object:plan];
        
    }];
    
    NSDictionary* dict = @{@"content":plan.content,@"startTime":[NSString stringWithFormat:@"%d",plan.startTime],@"endTime":[NSString stringWithFormat:@"%d",plan.endTime],@"planType":[NSString stringWithFormat:@"%d",plan.plantype],@"userId":[NSString stringWithFormat:@"%lld",[Config getOwnID]],@"planName":plan.planName};
    
    [[XZHttp sharedInstance]postWithURLString:url parameters:dict success:^(id responseObject) {
        NSDictionary* data = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSInteger isSuccess = [(NSString*)data[@"isSuccess"] integerValue];
        // 登陆失败 isSuccess == 0
        if(isSuccess != 1){
            NSString* errMeesage = data[@"message"];
            _hud.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hud.labelText = errMeesage;
            [_hud hide:YES afterDelay:1];
            return;
        }else {
            
            [_hud hide:YES];
            
        }
        
        
    } failure:^(NSError *error) {
        [Utils createHUDErrorWithError:error];
        
    }];
    
    
}

#pragma mark - 开始时间
-(void)starttime:(UIButton *) sender{
    [self pickershow];
    _starttimeDate = [NSDate date];
    [_starttimeBtn setTitle:[_starttimeDate currentTimeStringHM] forState:UIControlStateNormal];
    _isStart = YES;
}

#pragma  mark - 结束时间
-(void)endtime:(UIButton*)sender{
    [self pickershow];

    _isStart = NO;
    
}



-(void)hidenKeyboard{
    [_contentTV resignFirstResponder];

}

-(void)pickershow{
    _backview.hidden = NO;
    
    CATransition *animation = [CATransition animation];
    animation.duration = 0.4f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromRight;
    [_backview.layer addAnimation:animation forKey:@"animation"];
    
    
}
-(void)pickerhide{
    _backview.hidden = YES;

}

#pragma mark - 选择器值变化
-(void)pickerChange:(UIDatePicker*)sender{
    
    if(_isStart){
        if(_endtimeDate!=nil){
            _picker.maximumDate =_endtimeDate;
        }
        _starttimeDate = sender.date;
        [_starttimeBtn setTitle:[_starttimeDate currentTimeStringHM] forState:UIControlStateNormal];
        
        
        
    }else{
        if(_starttimeDate!=nil){
            
            _picker.minimumDate=_starttimeDate;
        }
        _endtimeDate = sender.date;
        [_endtimeBtn setTitle:[_endtimeDate currentTimeStringHM] forState:UIControlStateNormal];
        
    }
    
}

//#pragma mark - 手势识别
//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
//    
//    
//    CGPoint p = [touch locationInView:self.view];
//    NSLog(@"%@",NSStringFromCGPoint(p));
//
//    if(CGRectContainsPoint(_contentTV.frame, p)){
//        
//    }else{
//        [_contentTV resignFirstResponder];
//    }
//    return YES;
//    
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
