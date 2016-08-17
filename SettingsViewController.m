//
//  SettingsViewController.m
//  qunxin_edu
//
//  Created by 肖准 on 6/5/16.
//  Copyright © 2016 肖准. All rights reserved.
//

#import "SettingsViewController.h"
#import "LoginViewController.h"
#import "UMSocial.h"
#import <SDImageCache.h>
#import "MBProgressHUD.h"
@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_2"] style:UIBarButtonItemStylePlain  target:self action:@selector(back)];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh) name:@"userRefresh" object:nil];
    
}
-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 用户登录或注册成功
-(void)refresh{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - Table view data source
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 23;
//    
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if([indexPath section] == 0){
//        return 70;
//    }else{
//        return 45;
//    }

    return  45;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;

    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"settings_cell_section_1"];
   // cell.textLabel.text = @[@"检查更新",@"清除缓存",@"给应用评分"][indexPath.row];
    //cell.detailTextLabel.text = @[@"当前版本v1.0",@"",@""][indexPath.row];
    cell.textLabel.text = @"清除缓存";
 //   cell.detailTextLabel.text = @[@"当前版本v1.0",@"",@""][indexPath.row];
//
//    if(indexPath.section == 0){
//        
//        if([Config getOwnID]==0){
//        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"settings_cell_section_0"];
//        cell.textLabel.text = @"您还未登陆";
//        cell.detailTextLabel.text =@"点击登录";
//        cell.imageView.image = [UIImage imageNamed:@"touxiang"];
//        cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
//        }else {
//            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"settings_cell_section_0"];
//            cell.textLabel.text = [NSString stringWithFormat:@"用户名:%@",[Config getOwnUserName]];
//            cell.imageView.image = [UIImage imageNamed:@"touxiang"];
//            cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
//        }
//        
//    }
//    
//    else if(indexPath.section == 1){
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"settings_cell_section_1"];
//        cell.textLabel.text = @[@"检查更新",@"清除缓存",@"给应用评分"][indexPath.row];
//        cell.detailTextLabel.text = @[@"当前版本v1.0",@"",@""][indexPath.row];
//        
//    }else if(indexPath.section==2){
//        cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settings_cell_section_2"];
//        cell.textLabel.text=@[@"意见反馈",@"社交分享",@"关于大脚趾Timer"][indexPath.row];
//        cell.imageView.image =[UIImage imageNamed:@[@"feedback",@"icon_share",@"about"][indexPath.row] ];
//        
//    }else if(indexPath.section==3){
//
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settings_cell_section_3"];
//        UIButton* quitbtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        
//        [quitbtn setBackgroundColor:[UIColor redColor]];
//        [quitbtn setTitle:@"注 销" forState:UIControlStateNormal];
//        [quitbtn setFrame:CGRectMake(0, 0, screenwith, 45)];
//        [cell.contentView addSubview:quitbtn];
//        cell.userInteractionEnabled =YES;
//        [quitbtn addTarget:self action:@selector(quit:) forControlEvents:UIControlEventTouchUpInside];
//        if([Config getOwnID]==0){
//            [quitbtn setBackgroundColor:[UIColor colorWithRed:0.902 green:0.902 blue:0.941 alpha:1.000]];
//            quitbtn.enabled = NO;
//            cell.userInteractionEnabled =NO;
//        }
//        
//    }
    
    return cell;
}
//#pragma mark - 注销
//-(void)quit:(UIButton*)sender{
//    NSLog(@"注销");
//    [Config clearCookie];
//    [Config clearProfile];
//    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    for (NSHTTPCookie *cookie in [cookieStorage cookies]) {
//        [cookieStorage deleteCookie:cookie];
//    }
//    
//    MBProgressHUD *HUD = [Utils createHUD];
//    HUD.mode = MBProgressHUDModeCustomView;
//    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
//    HUD.labelText = @"注销成功";
//    [HUD hide:YES afterDelay:0.5];
//    
//    
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"userRefresh" object:@(YES)];
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.tableView reloadData];
//    });
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    if(indexPath.row == 0){
//        //检查更新
//        NSLog(@"检查更新");
//        
//    }else if(indexPath.row ==1){
//        //清除图片文件缓存
//        UIAlertView * alert = [UIAlertView bk_showAlertViewWithTitle:nil message:@"确定要清除缓存?" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
//            NSLog(@"index:%d",buttonIndex);
//            
//            if(buttonIndex == 1){
//                [[NSURLCache sharedURLCache] removeAllCachedResponses];
//                [[SDImageCache sharedImageCache] clearMemory];
//                [[SDImageCache sharedImageCache] clearDisk];
//            }
//        }];
//        alert.delegate =self;
//        [alert show];
//        
//        
//    }else if(indexPath.row==2){
//        NSLog(@"应用评分");
//    }

    
    //清除图片文件缓存
    UIAlertView * alert = [UIAlertView bk_showAlertViewWithTitle:nil message:@"确定要清除缓存?" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        NSLog(@"index:%d",buttonIndex);
        
        if(buttonIndex == 1){
            [[NSURLCache sharedURLCache] removeAllCachedResponses];
            [[SDImageCache sharedImageCache] clearMemory];
            [[SDImageCache sharedImageCache] clearDisk];
        }
    }];
    alert.delegate =self;
    [alert show];

//    switch (indexPath.section) {
//        case 0:{
//            //登陆注册页面
//            if([Config getOwnID]==0){
//
//                UIStoryboard* board = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
//                LoginViewController* loginctl = [board instantiateViewControllerWithIdentifier:@"LoginViewController"];
//                loginctl.hidesBottomBarWhenPushed=YES;
//                [self.navigationController pushViewController:loginctl animated:YES];
//            }else {
//                NSLog(@"查看用户信息");
//            }
//           
//            
//            
//            break;
//            
//        }
//        case 1:
//            if(indexPath.row == 0){
//                //检查更新
//                
//                
//                
//                break;
//            }else if(indexPath.row ==1){
//                //清除图片文件缓存
//                
//                UIAlertView * alert = [UIAlertView bk_showAlertViewWithTitle:nil message:@"确定要清除缓存?" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
//                    NSLog(@"index:%d",buttonIndex);
//                    
//                    if(buttonIndex == 1){
//                        [[NSURLCache sharedURLCache] removeAllCachedResponses];
//                        [[SDImageCache sharedImageCache] clearMemory];
//                        [[SDImageCache sharedImageCache] clearDisk];
//                    }
//                }];
//                alert.delegate =self;
//                [alert show];
//                
//                break;
//            }
//    
//        case 2:
//            
//           if(indexPath.row == 0){
//                //意见反馈
//                
//                
//                
//                break;
//            }else if(indexPath.row ==1){
//                //社交平台分享
//                
//                NSString *title = @"分享";
//                
//                // 微信相关设置
//                [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
//                [UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://www.baidu.com";
//                [UMSocialData defaultData].extConfig.wechatTimelineData.url = @"http://www.baidu.com";
//                [UMSocialData defaultData].extConfig.title = title;
//                
//                // 手机QQ相关设置
//                [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
//                [UMSocialData defaultData].extConfig.qqData.title = title;
//                //[UMSocialData defaultData].extConfig.qqData.shareText = weakSelf.objectTitle;
//                [UMSocialData defaultData].extConfig.qqData.url = @"http://www.baidu.com";
//                
//                // 新浪微博相关设置
//                [[UMSocialData defaultData].extConfig.sinaData.urlResource setResourceType:UMSocialUrlResourceTypeDefault url:@"http://www.baidu.com"];
//                
//                [UMSocialSnsService presentSnsIconSheetView:self
//                                                     appKey:@"57612161e0f55acd920028aa"
//                                                  shareText:[NSString stringWithFormat:@"分享来自 "]
//                                                 shareImage:[UIImage imageNamed:@"home"]
//                                            shareToSnsNames:@[UMShareToWechatTimeline, UMShareToWechatSession, UMShareToQQ, UMShareToSina]
//                                                   delegate:nil];
//                break;
//            }else if(indexPath.row ==2){
//                //关于群星学院介绍
//                
//                break;
//            }
//            
//        default:
//            break;
//    }
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
