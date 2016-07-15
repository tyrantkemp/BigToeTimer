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
@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 23;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath section] == 0){
        return 70;
    }else{
        return 45;
    }
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    
    if(indexPath.section == 0){
        
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"settings_cell_section_0"];
        cell.textLabel.text = @"您还未登陆";
        cell.detailTextLabel.text =@"点击登录";
        cell.imageView.image = [UIImage imageNamed:@"touxiang"];
    
        cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
        
        
    }
    
    else if(indexPath.section == 1){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"settings_cell_section_1"];
        cell.textLabel.text = @[@"检查更新",@"清除图片缓存",@"欢迎界面"][indexPath.row];
        cell.detailTextLabel.text = @[@"当前版本v1.0",@"",@""][indexPath.row];
        
    }else if(indexPath.section==2){
        cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settings_cell_section_2"];
        cell.textLabel.text=@[@"维护人员电话:13302332014",@"意见反馈",@"社交分享",@"关于前星学院"][indexPath.row];
        cell.imageView.image =[UIImage imageNamed:@[@"tel",@"feedback",@"icon_share",@"about"][indexPath.row] ];
        
    }
    
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:{
            //登陆注册页面
            UIStoryboard* board = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
            LoginViewController* loginctl = [board instantiateViewControllerWithIdentifier:@"LoginViewController"];
            loginctl.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:loginctl animated:YES];
            
            
            
            
            
            
            
            
            
            
            
            break;
            
        }
        case 1:
            if(indexPath.row == 0){
                //检查更新
                
                
                
                break;
            }else if(indexPath.row ==1){
                //清除图片文件缓存
                
                UIAlertView * alert = [UIAlertView bk_showAlertViewWithTitle:nil message:@"确定要清除缓存的图片和文件?" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    NSLog(@"index:%d",buttonIndex);
                    
                    if(buttonIndex == 1){
                        [[NSURLCache sharedURLCache] removeAllCachedResponses];
                        [[SDImageCache sharedImageCache] clearMemory];
                        [[SDImageCache sharedImageCache] clearDisk];
                    }
                }];
                alert.delegate =self;
                [alert  show];
                
                break;
            }else if(indexPath.row ==2){
                //欢迎界面
                
                break;
            }
        
    
        case 2:
            
            if(indexPath.row==0){
                //联系负责人？？？
                
                
                
            }
            
           else if(indexPath.row == 1){
                //意见反馈
                
                
                
                break;
            }else if(indexPath.row ==2){
                //社交平台分享
                
                NSString *title = @"分享";
                
                // 微信相关设置
                [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
                [UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://www.baidu.com";
                [UMSocialData defaultData].extConfig.wechatTimelineData.url = @"http://www.baidu.com";
                [UMSocialData defaultData].extConfig.title = title;
                
                // 手机QQ相关设置
                [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
                [UMSocialData defaultData].extConfig.qqData.title = title;
                //[UMSocialData defaultData].extConfig.qqData.shareText = weakSelf.objectTitle;
                [UMSocialData defaultData].extConfig.qqData.url = @"http://www.baidu.com";
                
                // 新浪微博相关设置
                [[UMSocialData defaultData].extConfig.sinaData.urlResource setResourceType:UMSocialUrlResourceTypeDefault url:@"http://www.baidu.com"];
                
                [UMSocialSnsService presentSnsIconSheetView:self
                                                     appKey:@"57612161e0f55acd920028aa"
                                                  shareText:[NSString stringWithFormat:@"分享来自 "]
                                                 shareImage:[UIImage imageNamed:@"home"]
                                            shareToSnsNames:@[UMShareToWechatTimeline, UMShareToWechatSession, UMShareToQQ, UMShareToSina]
                                                   delegate:nil];
                break;
            }else if(indexPath.row ==3){
                //关于群星学院介绍
                
                break;
            }
            
        default:
            break;
    }
    
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
