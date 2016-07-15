//
//  UserInfoViewController.m
//  qunxin_edu
//
//  Created by 肖准 on 6/18/16.
//  Copyright © 2016 肖准. All rights reserved.
//

#import "UserInfoViewController.h"

@interface UserInfoViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate>{
    
    UIButton* _quitBtn;
    
    
    UIView* _mailview;
    UITextField * _mailTF;
    
    UITextField * _mailaccountTF;
    
    UITextField * _mailpwdTF;
    
    NSMutableArray*_TFArr;
    
    UIButton* _submitBtn;
}

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    
    
    [self setUpSubviews];
    [self setLayout];
    
    // Do any additional setup after loading the view.
}

-(void)setUpSubviews{
    
    _quitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_quitBtn setBackgroundImage:[UIImage imageNamed:@"quit_normal"] forState:UIControlStateNormal];
    [_quitBtn setBackgroundImage:[UIImage imageNamed:@"quit_pressed"] forState:UIControlStateSelected];

    [_quitBtn bk_addEventHandler:^(id sender) {
        NSLog(@"退出整个注册界面");
        [self dismissViewControllerAnimated:YES completion:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:QUIT_REGISTER object:nil];
    
    } forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_quitBtn];
    
    
    //
    _mailview = [UIView new];
    [self.view addSubview:_mailview];
    //邮箱地址
    _mailTF = [UITextField new];
    [_mailTF setPlaceholder:@"请输入邮箱地址(方便密码找回)"];
    _mailTF.delegate =self;
    _mailTF.keyboardType =UIKeyboardTypeEmailAddress;
    _mailTF.borderStyle = UITextBorderStyleRoundedRect;
    [_mailTF setClearsOnBeginEditing:YES];
    [_mailTF setFont:[UIFont systemFontOfSize:13]];
    [_mailview addSubview:_mailTF];
    
    //用户名
    _mailaccountTF = [UITextField new];
    [_mailaccountTF setPlaceholder:@"请输入用户名"];
    _mailaccountTF.borderStyle = UITextBorderStyleRoundedRect;
    [_mailaccountTF setClearsOnBeginEditing:YES];
    _mailaccountTF.delegate =self;
    [_mailaccountTF setFont:[UIFont systemFontOfSize:13]];
    [_mailview addSubview:_mailaccountTF];
    
    //密码
    _mailpwdTF = [UITextField new];
    [_mailpwdTF setPlaceholder:@"请输入密码"];
    _mailpwdTF.borderStyle = UITextBorderStyleRoundedRect;
    [_mailpwdTF setSecureTextEntry:YES];
    _mailpwdTF.delegate =self;
    [_mailpwdTF setFont:[UIFont systemFontOfSize:13]];
    [_mailview addSubview:_mailpwdTF];
    
    //提交按钮
    _submitBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_submitBtn setBackgroundColor:[UIColor colorWithRed:0.365 green:0.780 blue:0.145 alpha:1.000]];
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitBtn setTitle:@" 提 交 " forState:UIControlStateNormal]; // = @"点击获取验证码";
    _submitBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_submitBtn addTarget:self action:@selector(submitBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    [_submitBtn setCornerRadius:4];
    [self.view addSubview:_submitBtn];
    
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
    [_quitBtn zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
       
        layout.topSpace(20).rightSpace(20).widthValue(20).heightValue(20);
        
    }];
    
    [_mailview setFrame:CGRectMake(screenwith/10, 100, screenwith/5*4, 100)];
    
    UILabel* title = [UILabel new];
    [title setText:@"用户信息填写"];
    [title setTextColor:[UIColor grayColor]];
    [title setFont:[UIFont fontWithName:@"Helvetica-BoldObliqu" size:15]];
    [self.view addSubview:title];
    
    [title zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
       
        layout.bottomSpaceByView(_mailview,20).leftSpaceEqualTo(_mailview,0);
    }];
    
    [_mailTF zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.topSpace(0).leftSpace(0).rightSpace(0).heightValue(33);
    }];
    
    [_mailaccountTF zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.leftSpace(0).rightSpace(0).topSpaceByView(_mailTF,10).heightValue(33);
    }];
    
    [_mailpwdTF zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.leftSpace(0).rightSpace(0).topSpaceByView(_mailaccountTF,10).heightValue(33);
    }];
    
    [_submitBtn zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        
        layout.topSpaceByView(_mailview,30).leftSpaceEqualTo(_mailview,0).widthValue(screenwith/3*2).heightValue(33);
        
    }];
    
}

#pragma  mark - 用户信息提交
-(void)submitBtnPress:(UIButton*)sender{


    
    NSLog(@"用户信息提交");
}


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
