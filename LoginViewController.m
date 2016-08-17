//
//  LoginViewController.m
//  qunxin_edu
//
//  Created by 肖准 on 6/15/16.
//  Copyright © 2016 肖准. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "UIButton+create.h"
#import "Utils.h"
#import "MBProgressHUD.h"
#import "XZHttp.h"
#import "userMJ.h"


#import "NSString+Util.h"


#import "RegisterViewController.h"
//#import "RegViewController.h"

@interface LoginViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate>{
    
    UIButton* _qqBtn;
    UIButton* _wechatBtn;
    UIButton* _weiboBtn;
    
    
    UIImageView* _userImage;
    UIImageView* _pwdImage;
    
    
    UITextField* _usernameTF;
    UITextField* _PasswordTF;
    
    
    UIButton* _regesitBtn;
    UIButton* _getPwdBtn;
    
    
}

@property (strong, nonatomic) IBOutlet UIButton *login;

@property (strong, nonatomic) IBOutlet UILabel *thirdloginLB;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpSubviews];
    [self setLayout];
    _login.enabled = YES;

    
    
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_2"] style:UIBarButtonItemStylePlain  target:self action:@selector(back)];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(quitLoginView) name:QUIT_REGISTER_TO_SETTING object:nil];
    
//    RACSignal *valid = [RACSignal combineLatest:@[_accountField.rac_textSignal, _passwordField.rac_textSignal]
//                                         reduce:^(NSString *account, NSString *password) {
//                                             return @(account.length > 0 && password.length > 0);
//                                         }];
//    RAC(_loginButton, enabled) = valid;
//    RAC(_loginButton, alpha) = [valid map:^(NSNumber *b) {
//        return b.boolValue ? @1: @0.4;
//    }];
    //    if (![TencentOAuth iphoneQQInstalled]) {
    //        _qqBtn.hidden = YES;
    //    }
    //
    //    if (![WXApi isWXAppInstalled]) {
    //        _wechatBtn.hidden = YES;
    //    }
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)quitLoginView{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)regist{
    NSLog(@"注册");
//    RegViewController* regCtl = [RegViewController new];
//    regCtl.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:regCtl animated:YES];
    
    //展示获取验证码界面，SMSGetCodeMethodSMS:表示通过文本短信方式获取验证码
//    [SMSSDKUI showVerificationCodeViewWithMetohd:SMSGetCodeMethodSMS result:^(enum SMSUIResponseState state,NSString *phoneNumber,NSString *zone, NSError *error) {
//        NSLog(@"短信验证");
//    }];

    RegisterViewController * regctl = [RegisterViewController new];
    regctl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:regctl animated:YES];
    
    
    NSLog(@"短信验证展示");
}

- (void)setUpSubviews
{
    
    //[_login setCornerRadius:5];
    
    self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc]initWithTitle:@"注册用户" style:UIBarButtonItemStylePlain target:self action:@selector(regist)];
    
    
    
    //用户名输入
    _usernameTF = [UITextField new];
    [_usernameTF setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_usernameTF setEnablesReturnKeyAutomatically:YES];
    _usernameTF.delegate = self;
    [_usernameTF setPlaceholder:@"用户名/邮箱"];
    [_usernameTF setFont:[UIFont systemFontOfSize:16]];
    [_usernameTF setTextColor:[UIColor colorWithRed:0.078 green:0.208 blue:0.422 alpha:1.000]];
    [_usernameTF setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_usernameTF setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    
    [self.view addSubview:_usernameTF];
    //用户名图标
    _userImage = [UIImageView new];
    [_userImage setImage:[UIImage imageNamed:@"account_1"]];
    [_userImage setUserInteractionEnabled:NO];
    [self.view addSubview:_userImage];
    //密码输入
    _PasswordTF = [UITextField new];
    [_PasswordTF setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_PasswordTF setEnablesReturnKeyAutomatically:YES];
    _PasswordTF.delegate = self;
    [_PasswordTF setPlaceholder:@"密码"];
    [_PasswordTF setFont:[UIFont systemFontOfSize:16]];
    [_PasswordTF setTextColor:[UIColor colorWithRed:0.078 green:0.208 blue:0.422 alpha:1.000]];
    [_PasswordTF setSecureTextEntry:YES];
    [_PasswordTF setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_PasswordTF setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self.view addSubview:_PasswordTF];
    _PasswordTF.delegate = self;
    
    //密码图标
    _pwdImage = [UIImageView new];
    [_pwdImage setImage:[UIImage imageNamed:@"password_1"]];
    [_pwdImage setUserInteractionEnabled:NO];
    [self.view addSubview:_pwdImage];
    
    //注册按钮
//    _regesitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_regesitBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
//    [_regesitBtn setTitle:@"注册新用户" forState:UIControlStateNormal];
//    [_regesitBtn setTitleColor:[UIColor colorWithRed:0.231 green:0.827 blue:0.918 alpha:0.770] forState:UIControlStateNormal];
//    
//    [_regesitBtn bk_addEventHandler:^(id sender) {
//        NSLog(@"注册新用户");
//    } forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_regesitBtn];
    //忘记密码
    _getPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_getPwdBtn setBackgroundColor:[UIColor clearColor]];
    [_getPwdBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_getPwdBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [_getPwdBtn setTitleColor:[UIColor colorWithRed:0.231 green:0.827 blue:0.918 alpha:0.770] forState:UIControlStateNormal];
    [_getPwdBtn setTitleColor:[UIColor colorWithRed:0.231 green:0.827 blue:0.918 alpha:1.000] forState:UIControlStateHighlighted];
    
    [_getPwdBtn bk_addEventHandler:^(id sender) {
        NSLog(@"忘记密码");
        
        
    } forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_getPwdBtn];
    _getPwdBtn.hidden=YES;
    
    //qq登录
    _qqBtn = [UIButton createButtonWithFrame:CGRectZero Target:self Selector:@selector(qqlogin:) Image:@"qq-icon" ImagePressed:@"qq-icon"];
    [self.view addSubview:_qqBtn];
    
    //微信登录
    //    _wechatBtn = [UIButton createButtonWithFrame:CGRectZero Target:self Selector:@selector(wechatlogin:) Image:@"wechat-icon" ImagePressed:@"wechat-icon"];
    _wechatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_wechatBtn setBackgroundImage:[UIImage imageNamed:@"wechat-icon"] forState:UIControlStateNormal];
    [_wechatBtn addTarget:self action:@selector(wechatlogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_wechatBtn];
    
    
    //微博登录
    _weiboBtn = [UIButton createButtonWithFrame:CGRectZero Target:self Selector:@selector(weibologin:) Image:@"weibo-icon" ImagePressed:@"weibo-icon"];
    [self.view addSubview:_weiboBtn];
    
    _qqBtn.hidden = YES;
    _weiboBtn.hidden = YES;
    _wechatBtn.hidden= YES;
    _thirdloginLB.hidden=YES;
    
    [_usernameTF addTarget:self action:@selector(returnOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_PasswordTF addTarget:self action:@selector(returnOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    gesture.delegate = self;
    [self.view addGestureRecognizer:gesture];
}

-(void)setLayout{
    
    
    [_login zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        
        layout.heightValue(44);
        
    }];

    
//    [_regesitBtn zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
//        layout.leftSpace(screenwith/6).topSpaceByView(_login,20);
//    }];
    
    [_getPwdBtn zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.rightSpace(screenwith/6).topSpaceByView(_login,20);
    }];
    
//    UIView* line1 = [UIView new];
//    [line1 setBackgroundColor:[UIColor lightGrayColor]];
//    [line1 setUserInteractionEnabled:NO];
//    [self.view addSubview:line1];
//    [line1 zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
//        layout.rightSpaceByView(_thirdloginLB,10).widthValue(screenwith/4).heightValue(1).topSpaceEqualTo(_thirdloginLB,10);
//        
//    }];
//    
//    UIView* line2 = [UIView new];
//    [line2 setBackgroundColor:[UIColor lightGrayColor]];
//    [line2 setUserInteractionEnabled:NO];
//    [self.view addSubview:line2];
//    [line2 zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
//        layout.leftSpaceByView(_thirdloginLB,10).widthValue(screenwith/4).heightValue(1).topSpaceEqualTo(_thirdloginLB,10);
//    }];
    
    [_wechatBtn zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.topSpaceByView(_thirdloginLB,30).widthValue(42).heightValue(42).leftSpace(screenwith/2-16);
        
    }]
    ;
    
    [_qqBtn zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.topSpaceByView(_thirdloginLB,30).widthValue(42).heightValue(42).rightSpaceByView(_wechatBtn,screenwith/6);
        
    }];
    
    [_weiboBtn zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.topSpaceByView(_thirdloginLB,30).widthValue(42).heightValue(42).leftSpaceByView(_wechatBtn,screenwith/6);
    }];
    
   
    
    
    [_userImage zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.widthValue(32).heightValue(32).topSpace(screenheight/6).leftSpaceEqualTo(_login,0);
        
    }];
    
    [_usernameTF zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.leftSpaceByView(_userImage,4).topSpace(screenheight/6+10).rightSpaceEqualTo(_login,0);
        
    }];
    UIView* line3 = [UIView new];
    [line3 setBackgroundColor:[UIColor blackColor]];
    [line3 setUserInteractionEnabled:NO];
    [self.view addSubview:line3];
    [line3 zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        
        layout.widthEqualTo(_login,0).topSpaceByView(_userImage,6).heightValue(1).leftSpaceEqualTo(_login,0);
        
    }];
    [_pwdImage zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.widthValue(32).heightValue(32).topSpaceByView(line3,6).leftSpaceEqualTo(_login,0);
        
    }];
    
    [_PasswordTF zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.leftSpaceByView(_pwdImage,4).topSpaceByView(line3,14).rightSpaceEqualTo(_login,0);
        
    }];

}

#pragma mark - kvo 
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    

}

- (void)returnOnKeyboard:(UITextField *)sender
{
    if (sender == _usernameTF) {
        [_PasswordTF becomeFirstResponder];
    } else if (sender == _PasswordTF) {
        [self hidenKeyboard];
        if (_login.enabled) {
            [self login];
        }
    }
}

- (void)hidenKeyboard
{
    [_usernameTF resignFirstResponder];
    [_PasswordTF resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (![_usernameTF isFirstResponder] && ![_PasswordTF isFirstResponder]) {

        return NO;
    }
    
    return YES;
}

#pragma mark - qq登录
-(void)qqlogin:(UIButton*) sender{
    NSLog(@"qq登录");
}
#pragma mark - 微信登录
-(void)wechatlogin:(UIButton*) sender{
    NSLog(@"微信登录");
    
}
#pragma mark - 微博登录
-(void)weibologin:(UIButton*) sender{
    NSLog(@"微博登录");
    
}

#pragma  mark - 登陆 

- (IBAction)Login:(UIButton *)sender {
    
    NSLog(@"登陆");
    if([_usernameTF.text isNullOrEmpty] || [_PasswordTF.text isNullOrEmpty]){
        UIAlertView* alter = [UIAlertView bk_showAlertViewWithTitle:@"错误" message:@"用户名或密码不能为空" cancelButtonTitle:@"OK" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            
        }];
        alter.delegate=self;
        [alter show];
        return;
    }
    
    [Utils showHudInView:self.view hint:@"正在登陆"];


    //用户名过滤掉空格 密码过滤空格MD5加密
    NSString* account = [_usernameTF.text StringWithoutEmpty];
    NSString * md5pwd = [[_PasswordTF.text StringWithoutEmpty] md5Checksum];
    

    NSLog(@"login url:%@",[NSString stringWithFormat:@"%@%@%@",MAIN,AUTH,APP_LOGIN]);

    
    [[XZHttp sharedInstance ] postWithURLString:[NSString stringWithFormat:@"%@%@%@",MAIN,AUTH,APP_LOGIN] parameters:@{@"userName":account, @"password":md5pwd} success:^(id responseObject) {
        
        [Utils hideHud];
        NSDictionary* data = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSInteger isSuccess = [(NSString*)data[@"isSuccess"] integerValue];
        
        // 登陆失败 isSuccess == 0
        if(isSuccess != 1){
            NSString* errMeesage = data[@"message"];
        
            [Utils showHUDWithErrorMsg:errMeesage];
             return;
        }
        
        //登陆成功后保存用户名密码下次进入登录页面可默认显示
        [Config saveOwnAccount:_usernameTF.text andPassword:_PasswordTF.text];
        //登陆成功后返回上一页
        [self.navigationController popViewControllerAnimated:YES];
        //获取并保存个人资料
        NSDictionary* user = data[@"data"];
        userMJ*  usermj = [userMJ mj_objectWithKeyValues:user];
        
        [self renewUser:usermj];
    
    } failure:^(NSError *error) {
        
        [Utils showHUDWithError:error];
     
    }];
    
    
    
    
//    [manager POST:[NSString stringWithFormat:@"%@%@", OSCAPI_HTTPS_PREFIX, OSCAPI_LOGIN_VALIDATE]
//       parameters:@{@"username" : _accountField.text, @"pwd" : _passwordField.text, @"keep_login" : @(1)}
//          success:^(AFHTTPRequestOperation *operation, ONOXMLDocument *responseObject) {
//              ONOXMLElement *result = [responseObject.rootElement firstChildWithTag:@"result"];
//              
//              NSInteger errorCode = [[[result firstChildWithTag:@"errorCode"] numberValue] integerValue];
//              if (!errorCode) {
//                  NSString *errorMessage = [[result firstChildWithTag:@"errorMessage"] stringValue];
//                  
//                  _hud.mode = MBProgressHUDModeCustomView;
//                  _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
//                  _hud.labelText = [NSString stringWithFormat:@"错误：%@", errorMessage];
//                  [_hud hide:YES afterDelay:1];
//                  
//                  return;
//              }
//              
//              [Config saveOwnAccount:_accountField.text andPassword:_passwordField.text];
//              ONOXMLElement *userXML = [responseObject.rootElement firstChildWithTag:@"user"];
//              
//              [self renewUserWithXML:userXML];
//          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//              _hud.mode = MBProgressHUDModeCustomView;
//              _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
//              _hud.labelText = [@(operation.response.statusCode) stringValue];
//              _hud.detailsLabelText = error.userInfo[NSLocalizedDescriptionKey];
//              
//              [_hud hide:YES afterDelay:1];
//          }
//     ];
}

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
#pragma mark - dellac
-(void)dealloc{
     
}


@end
