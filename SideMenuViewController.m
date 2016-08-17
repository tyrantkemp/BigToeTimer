//
//  SideMenuViewController.m
//  iosapp
//
//  Created by chenhaoxiang on 1/31/15.
//  Copyright (c) 2015 oschina. All rights reserved.
//

#import "SideMenuViewController.h"
#import "Config.h"
#import "Utils.h"
#import "userMJ.h"
#import "SettingsViewController.h"

#import "emailViewController.h"

#import "LoginViewController.h"

#import "AppDelegate.h"

#import <RESideMenu.h>
#import <MBProgressHUD.h>
#import "AboutViewController.h"


#import <UIImageView+WebCache.h>


@implementation SideMenuViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:@"userRefresh" object:nil];
    
    self.tableView.bounces = NO;
    
    self.tableView.backgroundColor = [UIColor titleBarColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dawnAndNightMode:) name:@"dawnAndNight" object:nil];
    
    ((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode = [Config getMode];

}

- (void)dawnAndNightMode:(NSNotification *)center
{
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 160;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    userMJ *myProfile = [Config myProfile];
    
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor clearColor];
    
    UIImageView *avatar = [UIImageView new];
    avatar.contentMode = UIViewContentModeScaleAspectFit;
    [avatar setCornerRadius:30];
    avatar.userInteractionEnabled = YES;
    avatar.translatesAutoresizingMaskIntoConstraints = NO;
    [headerView addSubview:avatar];
   
    avatar.image = [UIImage imageNamed:@"default-portrait"];
    
    
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.text = myProfile.userName;
    nameLabel.font = [UIFont boldSystemFontOfSize:20];
    
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode){
        nameLabel.textColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    } else {
        nameLabel.textColor = [UIColor colorWithHex:0x696969];
    }
    nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [headerView addSubview:nameLabel];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(avatar, nameLabel);
    NSDictionary *metrics = @{@"x": @([UIScreen mainScreen].bounds.size.width / 4 - 15)};
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[avatar(60)]-10-[nameLabel]-15-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-x-[avatar(60)]" options:0 metrics:metrics views:views]];
    
    avatar.userInteractionEnabled = YES;
    nameLabel.userInteractionEnabled = YES;
    [avatar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushLoginPage)]];
    [nameLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushLoginPage)]];
        
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [UITableViewCell new];
    
    cell.backgroundColor = [UIColor clearColor];
    
    UIView *selectedBackground = [UIView new];
    selectedBackground.backgroundColor = [UIColor colorWithHex:0xCFCFCF];
    [cell setSelectedBackgroundView:selectedBackground];
    
    cell.imageView.image = [UIImage imageNamed:@[@"sidemenu_setting",@"sidemenu_info",@"sidemenu_email",@"sidemenu_cancel"][indexPath.row]];
    cell.textLabel.text = @[@"设置", @"关于",@"反馈", @"注销"][indexPath.row];
    
   
    cell.textLabel.font = [UIFont systemFontOfSize:19];
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor selectCellSColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0: {
            UIStoryboard * settingSB = [UIStoryboard storyboardWithName:@"Settings" bundle:nil];
            

            SettingsViewController* settingnav = [settingSB instantiateViewControllerWithIdentifier:@"settings"];
            
            [self setContentViewController:settingnav];
            
            
            break;
        }
        case 1: {
            NSLog(@"关于软件。。。");
            AboutViewController *aboutCtl = [AboutViewController new];
            aboutCtl.hidesBottomBarWhenPushed = YES;
            
            [self setContentViewController:aboutCtl];

            break;
        }
        case 2: {
            NSLog(@"反馈信息。。。");
            
            
            emailViewController *emailCtl = [emailViewController new];
            emailCtl.hidesBottomBarWhenPushed = YES;
            [self setContentViewController:emailCtl];

            
            break;
        }
        case 3: {
            NSLog(@"用户注销。。。");
            
            if([Config getOwnID]==0)
            {
                [self.sideMenuViewController hideMenuViewController];
                return ;
            }
            
            UIAlertView* alert = [UIAlertView bk_showAlertViewWithTitle:@"确定退出？" message:nil cancelButtonTitle:@"确定" otherButtonTitles:@[@"取消"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if(buttonIndex == 0){
                    
                    [Config clearCookie];
                    [Config clearProfile];
                    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
                    for (NSHTTPCookie *cookie in [cookieStorage cookies]) {
                        [cookieStorage deleteCookie:cookie];
                    }
                    
                    [Utils showHUDWithMsg:@"注销成功" andImage:[UIImage imageNamed:@"HUD-done"]];
                    
                    [self.sideMenuViewController hideMenuViewController];

                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"userRefresh" object:@(YES)];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });

                }else{
                    
                }
            }];
            alert.delegate =self;
            [alert show];
            break;
        }
      
        default: break;
    }
}


- (void)setContentViewController:(UIViewController *)viewController
{
    viewController.hidesBottomBarWhenPushed = YES;
    UINavigationController *nav = (UINavigationController *)((UITabBarController *)self.sideMenuViewController.contentViewController).selectedViewController;
    //UIViewController *vc = nav.viewControllers[0];
    //vc.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [nav pushViewController:viewController animated:NO];
    
    [self.sideMenuViewController hideMenuViewController];
}

#pragma mark - 点击登录

- (void)pushLoginPage
{
    if ([Config getOwnID] == 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        LoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self setContentViewController:loginVC];
    } else {
        return;
    }
}

- (void)reload
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}


@end
