//
//  MainContentViewController.m
//  BigToeTimer
//
//  Created by 肖准 on 7/11/16.
//  Copyright © 2016 xiaozhun. All rights reserved.
//

#import "MainContentViewController.h"
#import "OptionButton.h"
#import "SettingsViewController.h"
#import "ListViewController.h"
#import "detailViewController.h"
#import "AnalysisTableViewController.h"
#import "LoginViewController.h"

@interface MainContentViewController ()<UITabBarControllerDelegate>{
    UIButton* _centerButton;
    CGFloat _length;
    ListViewController *_listCtl;
    
    
}
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIImageView *blurView;
@property (nonatomic, assign) BOOL isPressed;
@property (nonatomic, strong) UIView *dimView;
@property (nonatomic, strong) NSMutableArray *optionButtons;

@end

@implementation MainContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.937 alpha:1.000];
    self.tabBar.translucent = NO;

    
    //计划
    _listCtl = [ListViewController new];
    UINavigationController* listnav = [[UINavigationController alloc]initWithRootViewController:_listCtl];
    _listCtl.needCache = YES;
    
    
    
    //设置
//    UIStoryboard * settingSB = [UIStoryboard storyboardWithName:@"Settings" bundle:nil];
//    UINavigationController * settingsNav = [settingSB instantiateViewControllerWithIdentifier:@"nav"];

    //统计
    AnalysisTableViewController * anlyCtl = [AnalysisTableViewController new];
     anlyCtl.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu_1"] style:UIBarButtonItemStylePlain target:self action:@selector(showSideMenu)];
    UINavigationController* anNav= [[UINavigationController alloc]initWithRootViewController:anlyCtl];
    
    //tab
    self.viewControllers =@[
                            listnav,
                            [UIViewController new],
                            anNav
                            ];
    NSArray* titles = @[@"计划",@"",@"统计"];
    NSArray* images = @[@"list_1_normal",@"",@"analyse_1_normal"];
    
    [self.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        [item setTitle:titles[idx]];
        [item setImage:[UIImage imageNamed:images[idx]]];
        [item setSelectedImage:[UIImage imageNamed:[images[idx] stringByReplacingOccurrencesOfString:@"normal" withString:@"pressed"]]];
        if(idx==1){
            item.enabled = NO;
        }
    }];
    
    //中间按钮功能
    [self addCenterButtonWithImage:[UIImage imageNamed:@"tabbar-more"]];
    // 功能键相关
    _optionButtons = [NSMutableArray new];
    
    _length = 60;        // 圆形按钮的直径
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    NSArray *buttonTitles = @[@"定时", @"全天",@"其他"];
   // NSArray *buttonImages = @[@"tweetEditing", @"picture",@"omit"];
    NSArray *buttonImages = @[@"sandglass", @"clock_1",@"omit"];

    
    int buttonColors[] = {0xe69961, 0x0dac6b, 0xA9A9A9};
    
    for (int i = 0; i < 3; i++) {
        OptionButton *optionButton = [[OptionButton alloc] initWithTitle:buttonTitles[i]
                                                                   image:[UIImage imageNamed:buttonImages[i]]
                                                                andColor:[UIColor colorWithHex:buttonColors[i]]];
        
        optionButton.frame = CGRectMake((screenwith/6 * (i%3*2+1) - (_length+16)/2),
                                        screenheight + 100 + i/3*100,
                                        _length + 16,
                                        _length + [UIFont systemFontOfSize:14].lineHeight + 24);
        [optionButton.button setCornerRadius:_length/2];
        optionButton.tag = i;
        optionButton.userInteractionEnabled = YES;
        [optionButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapOptionButton:)]];
        
        [self.view addSubview:optionButton];
        [_optionButtons addObject:optionButton];
    }

    //((UIButton*)(_optionButtons[2])).enabled=NO;
}
-(void)addCenterButtonWithImage:(UIImage *)buttonImage
{
    _centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGPoint origin = [self.view convertPoint:self.tabBar.center toView:self.tabBar];
    CGSize buttonSize = CGSizeMake(self.tabBar.frame.size.width / 5 - 6, self.tabBar.frame.size.height - 4);
    _centerButton.frame = CGRectMake(origin.x - buttonSize.height/2, origin.y - buttonSize.height/2, buttonSize.height, buttonSize.height);
    [_centerButton setCornerRadius:buttonSize.height/2];
    [_centerButton setBackgroundColor:[UIColor colorWithHex:0x24a83d]];
    [_centerButton setImage:buttonImage forState:UIControlStateNormal];
    [_centerButton addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBar addSubview:_centerButton];
}


- (void)changeTheButtonStateAnimatedToOpen:(BOOL)isPressed
{
    if (isPressed) {
        [self removeBlurView];
        
        [_animator removeAllBehaviors];
        for (int i = 0; i < 3; i++) {
            UIButton *button = _optionButtons[i];
            
            UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc] initWithItem:button
                                                                         attachedToAnchor:CGPointMake(screenwith/6 * (i%3*2+1),
                                                                                                      screenheight + 60 + i/3*100)];
            attachment.damping = 0.65;
            attachment.frequency = 4;
            attachment.length = 1;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC * (6 - i)), dispatch_get_main_queue(), ^{
                [_animator addBehavior:attachment];
            });
        }
    } else {
        [self addBlurView];
        
        [_animator removeAllBehaviors];
        for (int i = 0; i < 3; i++) {
            UIButton *button = _optionButtons[i];
            [self.view bringSubviewToFront:button];
            
            UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc] initWithItem:button
                                                                         attachedToAnchor:CGPointMake(screenwith/6 * (i%3*2+1),
                                                                                                      screenheight - 60+ i/3*100)];
            attachment.damping = 0.65;
            attachment.frequency = 4;
            attachment.length = 1;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.02 * NSEC_PER_SEC * (i + 1)), dispatch_get_main_queue(), ^{
                [_animator addBehavior:attachment];
            });
        }
    }
}

- (void)buttonPressed
{
    [self changeTheButtonStateAnimatedToOpen:_isPressed];
    _isPressed = !_isPressed;
}

- (void)addBlurView
{
    _centerButton.enabled = NO;
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGRect cropRect = CGRectMake(0, screenSize.height - 135, screenSize.width, screenSize.height);
    
    UIImage *originalImage = [self.view updateBlur];
    UIImage *croppedBlurImage = [originalImage cropToRect:cropRect];
    
    _blurView = [[UIImageView alloc] initWithImage:croppedBlurImage];
    _blurView.frame = cropRect;
    _blurView.userInteractionEnabled = YES;
    [self.view addSubview:_blurView];
    
    _dimView = [[UIView alloc] initWithFrame:self.view.bounds];
    _dimView.backgroundColor = [UIColor blackColor];
    _dimView.alpha = 0.4;
    [self.view insertSubview:_dimView belowSubview:self.tabBar];
    
    [_blurView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonPressed)]];
    [_dimView  addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonPressed)]];
    
    [UIView animateWithDuration:0.25f
                     animations:^{}
                     completion:^(BOOL finished) {
                         if (finished) {_centerButton.enabled = YES;}
                     }];
}

- (void)removeBlurView
{
    _centerButton.enabled = NO;
    
    self.view.alpha = 1;
    [UIView animateWithDuration:0.25f
                     animations:^{}
                     completion:^(BOOL finished) {
                         if(finished) {
                             [_dimView removeFromSuperview];
                             _dimView = nil;
                             
                             [self.blurView removeFromSuperview];
                             self.blurView = nil;
                             _centerButton.enabled = YES;
                         }
                     }];
}


#pragma mark - 处理点击事件
- (void)onTapOptionButton:(UIGestureRecognizer *)recognizer
{
    switch (recognizer.view.tag) {
        case 0: {
            NSLog(@"限时计划");
            if([Config getOwnID]==0){
                UIAlertView *alert = [UIAlertView bk_showAlertViewWithTitle:@"请先登录" message:@"左滑点击头像登录" cancelButtonTitle:@"确定" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    if(buttonIndex==0){
                       // LoginViewController* logCtl = [LoginViewController new];
                      //  [self.navigationController pushViewController:logCtl animated:YES];
                        //[self presentModalViewController:logCtl animated:YES];

                    }
                }];
                alert.delegate =self;
                [alert show];
            }else{
                detailViewController * detailctl = [detailViewController new];
                [self presentViewController:detailctl animated:YES completion:nil];
                
            }
            
       
            
            break;
        }
        case 1: {
            NSLog(@"全天计划");
            
            if([Config getOwnID]==0){
                UIAlertView *alert = [UIAlertView bk_showAlertViewWithTitle:@"请先登录" message:@"左滑点击头像登录" cancelButtonTitle:@"确定" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    if(buttonIndex==0){
                        // LoginViewController* logCtl = [LoginViewController new];
                        //  [self.navigationController pushViewController:logCtl animated:YES];
                        //[self presentModalViewController:logCtl animated:YES];
                        
                    }
                }];
                
                alert.delegate =self;
                [alert show];
            }else{
                detailViewController * detailctl = [detailViewController new];
                detailctl.plantype = PlanTypeAllDay;
                [self presentViewController:detailctl animated:YES completion:nil];
            }
           
            
            break;
        }
        case 2: {
            NSLog(@"其他");

            UIAlertView * alert = [UIAlertView bk_showAlertViewWithTitle:@"ooops!!" message:@"该功能还在开发中..." cancelButtonTitle:@"确定" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                
            }];
            alert.delegate =self;
            [alert show];
          
            break;
        }
                default: break;
    }
    
    [self buttonPressed];
}

#pragma mark - 点击显示侧边栏
-(void)showSideMenu{
    [self.sideMenuViewController presentLeftMenuViewController];

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
