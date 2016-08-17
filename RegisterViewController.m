//
//  RegViewController.m
//  qunxin_edu
//
//  Created by 肖准 on 6/16/16.
//  Copyright © 2016 肖准. All rights reserved.
//

#import "RegisterViewController.h"
//#import <SMS_SDK/SMSSDK.h>
#import "UserInfoViewController.h"
#import "NSString+Util.h"
#import "MBProgressHUD.h"

@interface RegisterViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate>{
    
  
    
    UITextField* _phoneTF;
    UITextField* _smsTF;
    UIButton* _getSMSBtn;
    UILabel* _ui86;
    
    //UIButton* _typeBtn;
    
    UIView * _mailview;
    UITextField* _mailTF;
    UITextField* _mailaccountTF;
    UITextField* _mailpwdTF;
    
    
    NSMutableArray * _TFArr;

    
    UIButton * _submitBtn;

    
   // NSInteger _type;
    
    //倒计时
    NSTimer* _timer;
    NSInteger _totaltime;
    
    
}

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // self.edgesForExtendedLayout = UIRectEdgeNone;
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {self.edgesForExtendedLayout= UIRectEdgeNone;
    }

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    //_type = 0;
    
    
    [self setUpSubviews];
    [self setLayout];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(quitCtl) name:QUIT_REGISTER object:nil];
    
}

-(void)setUpSubviews{

 
//    
//    _ui86 = [UILabel new];
//    [_ui86 setText:@"+86"];
//    [_ui86 setFont:[UIFont systemFontOfSize:17]];
//    [self.view addSubview:_ui86];
//    
//    
//    _phoneTF = [UITextField new];
//    [_phoneTF setPlaceholder:@"请输入手机号"];
//    [_phoneTF setClearsOnBeginEditing:YES];
//    _phoneTF.keyboardType = UIKeyboardTypePhonePad;
//    _phoneTF.borderStyle = UITextBorderStyleRoundedRect;
//    _phoneTF.delegate =self;
//    [_phoneTF setFont:[UIFont systemFontOfSize:17]];
//    [self.view addSubview:_phoneTF];
//    
//    _smsTF = [UITextField new];
//    [_smsTF setPlaceholder:@"输入校验码"];
//    _smsTF.borderStyle = UITextBorderStyleRoundedRect;
//    _smsTF.delegate = self;
//    _smsTF.keyboardType = UIKeyboardTypeNumberPad;
//    [_smsTF setFont:[UIFont systemFontOfSize:13]];
//    [self.view addSubview:_smsTF];
//    
//    _getSMSBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [_getSMSBtn setBackgroundColor:[UIColor colorWithRed:0.365 green:0.780 blue:0.145 alpha:1.000]];
//    [_getSMSBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [_getSMSBtn setTitle:@" 点击获取验证码 " forState:UIControlStateNormal]; // = @"点击获取验证码";
//    _getSMSBtn.titleLabel.font = [UIFont systemFontOfSize:17];
//
//    [_getSMSBtn addTarget:self action:@selector(getMsgBtnPress:) forControlEvents:UIControlEventTouchUpInside];
//    [_getSMSBtn setCornerRadius:4];
//    [self.view addSubview:_getSMSBtn];
    
    //注册方式变化btn
//    _typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_typeBtn setTitle:@"邮箱注册" forState:UIControlStateNormal];
//    _typeBtn.titleLabel.font = [UIFont systemFontOfSize:17];
//    
//    [_typeBtn setTitleColor:[UIColor colorWithRed:0.365 green:0.780 blue:0.145 alpha:1.000] forState:UIControlStateNormal];
//    [_typeBtn addTarget:self action:@selector(typeBtnPress:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.view addSubview:_typeBtn];
    
    
    //提交按钮
    _submitBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_submitBtn setBackgroundColor:[UIColor colorWithRed:0.365 green:0.780 blue:0.145 alpha:1.000]];
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitBtn setTitle:@" 注 册 " forState:UIControlStateNormal]; // = @"点击获取验证码";
    _submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    
    [_submitBtn addTarget:self action:@selector(submitBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_submitBtn];
    
    
    
    //
    _mailview = [UIView new];
    [self.view addSubview:_mailview];
    //邮箱地址
    _mailTF = [UITextField new];
    [_mailTF setPlaceholder:@"请输入邮箱地址"];
    _mailTF.delegate =self;
    _mailTF.keyboardType =UIKeyboardTypeEmailAddress;
    _mailTF.borderStyle = UITextBorderStyleRoundedRect;
    [_mailTF setClearsOnBeginEditing:YES];
    [_mailTF setFont:[UIFont systemFontOfSize:15]];
    [_mailTF setAutocorrectionType:UITextAutocorrectionTypeNo];
    
    [_mailTF setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [_mailview addSubview:_mailTF];
    
    //用户名
    _mailaccountTF = [UITextField new];
    [_mailaccountTF setPlaceholder:@"请输入用户名"];
    _mailaccountTF.borderStyle = UITextBorderStyleRoundedRect;
    [_mailaccountTF setClearsOnBeginEditing:YES];
    _mailaccountTF.delegate =self;
    [_mailaccountTF setFont:[UIFont systemFontOfSize:15]];
    [_mailaccountTF setAutocorrectionType:UITextAutocorrectionTypeNo];
    
    [_mailaccountTF setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [_mailview addSubview:_mailaccountTF];
    
    //密码
    _mailpwdTF = [UITextField new];
    [_mailpwdTF setPlaceholder:@"请输入密码"];
    _mailpwdTF.borderStyle = UITextBorderStyleRoundedRect;
    [_mailpwdTF setAutocorrectionType:UITextAutocorrectionTypeNo];
    
    [_mailpwdTF setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [_mailpwdTF setSecureTextEntry:YES];
    _mailpwdTF.delegate =self;
    [_mailpwdTF setFont:[UIFont systemFontOfSize:15]];
    [_mailview addSubview:_mailpwdTF];

    
    
    
    _TFArr = [NSMutableArray arrayWithObjects:_mailTF,_mailaccountTF,_mailpwdTF, nil];
    
    UITapGestureRecognizer* tap = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        
        [_TFArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

            [obj resignFirstResponder];
        
        }];
    }];
    tap.delegate =self;
    [self.view addGestureRecognizer:tap];
    
}

-(void)setLayout{
//    
//    [_segement zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
//        
//        layout.widthValue(screenwith/5*4).heightValue(30).topSpace(10).leftSpace(screenwith/10);
//    }];
//    
    
    
//    [_phoneTF zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
//        layout.topSpace(40).widthValue(screenwith/3*2).leftSpace(screenwith/6).heightValue(33);
//    }];
//  
//
//    [_ui86 zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
//        layout.topSpace(45).rightSpaceByView(_phoneTF,10);
//    }];
//    
//    
//    [_getSMSBtn zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
//        
//        layout.topSpaceByView(_phoneTF,10).rightSpaceEqualTo(_phoneTF,0).widthValue(100).heightValue(33);
//        
//    }];
//    
//    [_smsTF zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
//       
//        layout.topSpaceByView(_phoneTF,10).leftSpaceEqualTo(_phoneTF,0).rightSpaceByView(_getSMSBtn,5).heightValue(33);
//    }];
    
//    
//    [_typeBtn zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
//
//        layout.topSpace(screenheight/3+40).rightSpaceEqualTo(_phoneTF,0);
//        
//    }];
//
 
    
    
    [_mailview setFrame:CGRectMake(screenwith/8, 40, screenwith/4*3, 150)];
    
    [_mailTF zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.topSpace(0).leftSpace(0).rightSpace(0).heightValue(40);
    }];
    
    [_mailaccountTF zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.leftSpace(0).rightSpace(0).topSpaceByView(_mailTF,10).heightValue(40);
    }];
    
    [_mailpwdTF zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
    
        layout.leftSpace(0).rightSpace(0).topSpaceByView(_mailaccountTF,10).heightValue(40);
    }];
    
    [_submitBtn zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        
        layout.topSpaceByView(_mailview,20).leftSpace(screenwith/10).widthValue(screenwith/5*4).heightValue(44);
        
    }];
//    [_mailview zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
//        layout.leftSpace(screenwith+screenwith/6+20).widthValue(screenwith/3*2).heightValue(100).topSpace(40);
//        
//    }];
    
}




#pragma mark - 类型转换
//-(void)typeBtnPress:(UIButton*)sender{
//    NSLog(@"类型转换");
//    [_TFArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//    
//        [obj resignFirstResponder];
//        [((UITextField*)obj) setText:@""];
//    }];
//    
//    
//    if(_type ==0 ){
//    
//    [UIView animateWithDuration:0.2 animations:^{
//        
////        CGFloat smsbtnX= _getSMSBtn.center.x;
////        CGFloat ui86X = _ui86.center.x;
////        CGFloat
////        
//        
//        [_getSMSBtn setFrame:CGRectMake(_getSMSBtn.frame.origin.x-screenwith, _getSMSBtn.frame.origin.y, _getSMSBtn.frame.size.width, _getSMSBtn.frame.size.height)];
//        
//        [_ui86 setFrame:CGRectMake(_ui86.frame.origin.x-screenwith, _ui86.frame.origin.y, _ui86.frame.size.width, _ui86.frame.size.height)];
//        
//        [_smsTF setFrame:CGRectMake(_smsTF.frame.origin.x-screenwith, _smsTF.frame.origin.y, _smsTF.frame.size.width, _smsTF.frame.size.height)];
//        
//    
//        [_phoneTF setFrame:CGRectMake(_phoneTF.frame.origin.x-screenwith, _phoneTF.frame.origin.y, _phoneTF.frame.size.width, _phoneTF.frame.size.height)];
//        [_mailview setFrame:CGRectMake(screenwith/6, 40, screenwith/3*2, 100)];
//        }];
//   
//        [_typeBtn setTitle:@"短信注册" forState:UIControlStateNormal];
//        
//        _getSMSBtn.alpha =0;
//        _ui86.alpha = 0;
//        _smsTF.alpha =0 ;
//        _phoneTF.alpha =0;
//        _type =1;
//        _mailview.alpha =1;
//
//    }else if(_type ==1 ){
//        
//        [UIView animateWithDuration:0.2 animations:^{
//            [_getSMSBtn setFrame:CGRectMake(_getSMSBtn.frame.origin.x + screenwith, _getSMSBtn.frame.origin.y, _getSMSBtn.frame.size.width, _getSMSBtn.frame.size.height)];
//            
//            [_ui86 setFrame:CGRectMake(_ui86.frame.origin.x + screenwith, _ui86.frame.origin.y, _ui86.frame.size.width, _ui86.frame.size.height)];
//            
//                       
//            
//            [_smsTF setFrame:CGRectMake(_smsTF.frame.origin.x+screenwith, _smsTF.frame.origin.y, _smsTF.frame.size.width, _smsTF.frame.size.height)];
//            
//            
//            [_phoneTF setFrame:CGRectMake(_phoneTF.frame.origin.x+screenwith, _phoneTF.frame.origin.y, _phoneTF.frame.size.width, _phoneTF.frame.size.height)];
//            [_mailview setFrame:CGRectMake(screenwith+screenwith/6, 40, screenwith/3*2, 100)];
//            
//            
//            _getSMSBtn.alpha =1;
//            _ui86.alpha = 1;
//            _smsTF.alpha =1 ;
//            _phoneTF.alpha =1;
//            _type =1;
//
//            _mailview.alpha =0;
//        }];
//        
//        
//        [_typeBtn setTitle:@"邮箱注册" forState:UIControlStateNormal];
//        _type =0;
//        
//    }
//}


//#pragma mark - 获取验证码
//-(void)getMsgBtnPress:(UIButton*)sender{
//
//    
//    //如果为空
//    if([[_phoneTF.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]){
//    
//        UIAlertView * alert = [[UIAlertView alloc]bk_initWithTitle:nil message:@"手机号不能为空"];
//        [alert bk_setCancelButtonWithTitle:@"OK" handler:^{
//            NSLog(@"alert 退出");
//            
//        }];
//        [alert show];
//        return ;
//        
//    }
//    _totaltime = 60;
//    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(smsTime:) userInfo:nil repeats:YES];
//    
//    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:_phoneTF.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
//        if (!error) {
//            NSLog(@"获取验证码成功");
//        } else {
//            NSLog(@"错误信息：%@",error);
//        }
//    }];
//}

-(void)smsTime:(NSTimer*) timer{
    if(_totaltime == 1){
        [_timer invalidate];
        _totaltime = 60;
        [_getSMSBtn setTitle:@" 点击获取验证码 " forState:UIControlStateNormal];
        [_getSMSBtn setEnabled:YES];
        
    }else {
        _totaltime -- ;
        NSString* title = [NSString stringWithFormat:@" 剩余 %d s",_totaltime];
        [_getSMSBtn setTitle:title forState:UIControlStateNormal];
        [_getSMSBtn setEnabled:NO];
        
    }
}
//如果登陆成功，停止验证码的倒数，
- (void)releaseTImer {
    if (_timer) {
        if ([_timer respondsToSelector:@selector(isValid)]) {
            if ([_timer isValid]) {
                [_timer invalidate];
                _totaltime = 60;
            }
        }
    }
}
#pragma  mark - 注册提交
-(void)submitBtnPress:(UIButton*)sender{
    
    NSLog(@"邮箱注册提交");
    if([_mailTF.text isNullOrEmpty] || [_mailaccountTF.text isNullOrEmpty]|| [_mailpwdTF.text isNullOrEmpty]){
        UIAlertView* alert = [UIAlertView bk_showAlertViewWithTitle:@"错误" message:@"必填项不能为空" cancelButtonTitle:@"OK" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        }];
        
        alert.delegate =self;
        [alert show];
        return;
    }
    
    
    NSString* mail = [_mailTF.text StringWithoutEmpty];
    NSString* username = [_mailaccountTF.text StringWithoutEmpty];
    NSString* password = [[_mailpwdTF.text StringWithoutEmpty]md5Checksum];
    
    //邮箱格式验证
    if(![Utils isValidateEmail:mail]){
        UIAlertView* alert = [UIAlertView bk_showAlertViewWithTitle:nil message:@"邮箱格式错误" cancelButtonTitle:@"重新输入" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            
        }];
        alert.delegate =self;
        [alert show];
        return;
    }
    

    [Utils showHudInView:self.view hint:@"正在注册"];
    
    
    
    
    [[XZHttp sharedInstance ] postWithURLString:[NSString stringWithFormat:@"%@%@%@",MAIN,AUTH,APP_REGISTER] parameters:@{@"userName":username, @"password":password,@"email":mail} success:^(id responseObject) {
        [Utils hideHud];
        NSDictionary* data = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSInteger isSuccess = [(NSString*)data[@"isSuccess"] integerValue];
        // 注册失败 isSuccess == 0
        if(isSuccess != 1){
            NSString* errMeesage = data[@"message"];
         
            [Utils showHUDWithErrorMsg:errMeesage];

            return;
        }

        
        [Utils showHUD:@"注册成功"];
        //登陆成功后返回上一页
        dispatch_after (dispatch_time (DISPATCH_TIME_NOW, (int64_t )(2 * NSEC_PER_SEC )), dispatch_get_main_queue (), ^{
            [self.navigationController popViewControllerAnimated:NO];
            [[NSNotificationCenter defaultCenter]postNotificationName:QUIT_REGISTER_TO_SETTING object:nil];
            
        });
        //获取并保存个人资料
        NSDictionary* user = data[@"data"];
        userMJ*  usermj = [userMJ mj_objectWithKeyValues:user];
        [self renewUser:usermj];
    } failure:^(NSError *error) {
        [Utils showHUDWithError:error];
        
    }];
    
}
#pragma mark - 跟新本地用户信息
-(void)renewUser:(userMJ*) user{
    //userDefault 保存 登陆用户信息
    [self saveCookies];
    [Config saveProfile:user];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userRefresh" object:@(YES)];
    
}
- (void)saveCookies
{
    NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: cookiesData forKey: @"sessionCookies"];
    [defaults synchronize];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 判断是否是手机号 邮箱格式
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if(textField != _phoneTF){
        return YES;
    }
    return [Utils isPhoneNumber:textField Range:range String:string];
    
}



#pragma mark - notification 

-(void)quitCtl{
    [self.navigationController popViewControllerAnimated:NO];
}

@end
