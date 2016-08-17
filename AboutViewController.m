//
//  AboutViewController.m
//  BigToeTimer
//
//  Created by 肖准 on 7/21/16.
//  Copyright © 2016 xiaozhun. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController (){
    
    UIImageView* _icon;
    
    UILabel* _title1;
    UILabel* _nameLB;
    UILabel* _version;
}

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //tableview 不扩展 只在bar和navigation之间显示 默认UIRectEdgeAll
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {self.edgesForExtendedLayout= UIRectEdgeNone;
    }

    self.view.backgroundColor = [UIColor colorWithRed:0.902 green:0.902 blue:0.941 alpha:1.000];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_2"] style:UIBarButtonItemStylePlain  target:self action:@selector(back)];
    self.navigationItem.title=@"关于大拇指Timer";
    
    _icon = [UIImageView new];
    [_icon setImage:[UIImage imageNamed:@"toe_1"]];
    [_icon setCornerRadius:30];
    [self.view addSubview:_icon];
    
    [_icon zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.topSpace(screenheight/4).leftSpace(screenwith/2-30).widthValue(60).heightValue(60);
    }];
    
    _title1 = [UILabel new];
    _title1.text = @"By";
    _title1.font = [UIFont systemFontOfSize:14];
    
    _title1.textAlignment = NSTextAlignmentCenter;
    _title1.textColor=[UIColor lightGrayColor];
    
    [self.view addSubview:_title1];

    [_title1 zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.topSpaceByView(_icon,20).xCenterByView(_icon,0);
    }];
    
    _nameLB = [UILabel new];
    _nameLB.text = @"肖准 QQ:848750016";
    _nameLB.font = [UIFont systemFontOfSize:14];
    _nameLB.textAlignment = NSTextAlignmentCenter;
    
    _nameLB.textColor=[UIColor lightGrayColor];

    [self.view addSubview:_nameLB];
    [_nameLB zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.topSpaceByView(_title1,10).xCenterByView(_icon,0);

    }];
    _version = [UILabel new];
    _version.text = @"v 1.0";
    _version.font = [UIFont systemFontOfSize:14];
    _version.textAlignment = NSTextAlignmentCenter;
    _version.textColor=[UIColor lightGrayColor];

    
    [self.view addSubview:_version];
    [_version zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.topSpaceByView(_nameLB,20).xCenterByView(_icon,0);

    }];

    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
    
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
