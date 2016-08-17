//
//  emailViewController.m
//  BigToeTimer
//
//  Created by 肖准 on 7/21/16.
//  Copyright © 2016 xiaozhun. All rights reserved.
//

#import "emailViewController.h"
#import "MBProgressHUD.h"
@interface emailViewController ()<UITextFieldDelegate,UITextViewDelegate>{
    
    UILabel* _emailTitleLB;
    UITextField* _emailTF;
    
    UILabel* _contentTitleLB;
    UITextView* _contentTV;
    
    UIButton* _submitBtn;


    UILabel* _placehoder;
}

@end

@implementation emailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //tableview 不扩展 只在bar和navigation之间显示 默认UIRectEdgeAll
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {self.edgesForExtendedLayout= UIRectEdgeNone;
    }
    self.view.backgroundColor = [UIColor colorWithRed:0.902 green:0.902 blue:0.941 alpha:1.000];
       self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_2"] style:UIBarButtonItemStylePlain  target:self action:@selector(back)];
    self.navigationItem.title=@"意见反馈";
    
    [self initSubViews];
    [self layoutsubviews];
    
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)initSubViews{
    
    _emailTitleLB = [UILabel new];
    NSString* title_str = @"联系邮箱(可选):";
    
    NSMutableAttributedString* tile = [[NSMutableAttributedString alloc]initWithString:title_str];
    NSRange range = [title_str rangeOfString:@"(可选)"];
    

    [tile addAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:16]} range:range];
    
    _emailTitleLB.attributedText = tile;
    [self.view addSubview:_emailTitleLB];
    
    _emailTF = [UITextField new];
    _emailTF.placeholder =@"输入您的邮箱地址";
    [_emailTF setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_emailTF setEnablesReturnKeyAutomatically:YES];
    _emailTF.delegate = self;
    [_emailTF setBackgroundColor:[UIColor whiteColor]];
    [_emailTF setBorderStyle:UITextBorderStyleNone];
    [_emailTF setFont:[UIFont systemFontOfSize:16]];
    [_emailTF setTextColor:[UIColor lightGrayColor]];
    [_emailTF setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_emailTF setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self.view addSubview:_emailTF];

    
    _contentTitleLB = [UILabel new];
    _contentTitleLB.text = @"您的建议:";
    _contentTitleLB.font = [UIFont systemFontOfSize:16];
    _contentTitleLB.textColor = [UIColor blackColor];
    
    [self.view addSubview:_contentTitleLB];
    
    _contentTV = [UITextView new];
    _contentTV.font = [UIFont systemFontOfSize:16];
    _contentTV.textColor= [UIColor blackColor];
    _contentTV.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _contentTV.delegate = self;
    [_contentTV setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_contentTV setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    _contentTV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_contentTV];
    
    
    _placehoder = [UILabel new];
    _placehoder.text = @"写下您的使用建议或者想添加的功能...";
    _placehoder.font = [UIFont systemFontOfSize:16];
    _placehoder.textColor = [UIColor lightGrayColor];
    [_contentTV addSubview:_placehoder];
    
    _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_submitBtn setBackgroundColor:[UIColor colorWithRed:0.365 green:0.780 blue:0.145 alpha:1.000]];
    [_submitBtn setTitle:@"提 交" forState:UIControlStateNormal];
    [_submitBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [_submitBtn addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_submitBtn];
    
    
}

-(void)layoutsubviews{
    [_emailTitleLB zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
    
        layout.leftSpace(10).topSpace(15);
    }];
    
    [_emailTF zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.leftSpaceEqualTo(_emailTitleLB,0).topSpaceByView(_emailTitleLB,10).rightSpace(10).heightValue(35);
        
    }];
    
    [_contentTitleLB zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
     
        layout.leftSpaceEqualTo(_emailTitleLB,0).topSpaceByView(_emailTF,15);
    }];
    
    [_contentTV zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.leftSpaceEqualTo(_emailTitleLB,0).topSpaceByView(_contentTitleLB,10).bottomSpace(120).rightSpace(10).widthValue(screenwith-20);
    }];
    
    [_placehoder zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.leftSpace(2).topSpace(7);
        
    }];
    
    [_submitBtn zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.leftSpaceEqualTo(_emailTitleLB,0).topSpaceByView(_contentTV,20).rightSpace(10).heightValue(50);
        
    }];
    
    
    
}
-(void)textViewDidChange:(UITextView *)textView
{
    NSString* content =  textView.text;
    if (content.length == 0) {
        _placehoder.text = @"写下您的使用建议或者想添加的功能...";
    }else{
        _placehoder.text = @"";
    }
}
-(void)submit:(UIButton*)sender{
    NSString* mail = [_emailTF.text StringWithoutEmpty];
    
    
    if([_contentTV.text isNullOrEmpty]){
        UIAlertView* alert = [UIAlertView bk_showAlertViewWithTitle:nil message:@"写点东西吧^_^" cancelButtonTitle:@"好吧" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            
        }];
        alert.delegate =self;
        [alert show];
        return;
    }
    
    
    //邮箱格式验证
    if(![_emailTF.text isNullOrEmpty]){
    if(![Utils isValidateEmail:mail]){
        UIAlertView* alert = [UIAlertView bk_showAlertViewWithTitle:nil message:@"邮箱格式错啦~囧~" cancelButtonTitle:@"了解" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            
        }];
        alert.delegate =self;
        [alert show];
        return;
        
    }
    }
    

    
    [Utils showHudInView:self.view hint:@"加载中..."];
    
    
    NSString* url = [NSString stringWithFormat:@"%@%@%@",MAIN,AUTH,ADVISE];
    
    [[XZHttp sharedInstance]postWithURLString:url parameters:@{@"userId":[NSString stringWithFormat:@"%lld",[Config getOwnID]],@"content":_contentTV.text,@"email":[_emailTF.text StringWithoutEmpty]} success:^(id responseObject) {
        
        [Utils hideHud];
        NSDictionary* data = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSInteger isSuccess = [(NSString*)data[@"isSuccess"] integerValue];
        
        if(isSuccess != 1){
            NSString* errMeesage = data[@"message"];
      
            [Utils showHUDWithErrorMsg:errMeesage];

            return;
        }else {
            
            [self.navigationController popViewControllerAnimated:YES];
            
          
            [Utils showHUD:@"提交成功"];
            
        }
    } failure:^(NSError *error) {
        [Utils showHUDWithError:error];
        
    }];
    
 
    
    
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
