
//
//  DoneListTableViewController.m
//  BigToeTimer
//
//  Created by 肖准 on 7/19/16.
//  Copyright © 2016 xiaozhun. All rights reserved.
//

#import "DoneListTableViewController.h"
#import "planTableViewCell.h"
#import "planMJ.h"
#import "detailViewController.h"
#import <MBProgressHUD.h>
static NSString* cellId= @"donelist_plan_cell";


@interface DoneListTableViewController ()<SWTableViewCellDelegate>{
    CGFloat _cellheight;
}

@end

@implementation DoneListTableViewController
-(instancetype)init{
    self = [super init];
    if(self){
        _type = 0;
        _cellheight = 100;
        _index = 0;
        _plantype = 0;
        __weak DoneListTableViewController * corpctl = self;
        
        self.generateURL = ^NSString*(NSUInteger page){
            page++;
            NSString* url =[NSString stringWithFormat:@"%@%@%@?pageIndex=%lu&type=%d&userId=%lld&index=%d&plantype=%d", MAIN, LIST,PLAN_GETBY_TYPE_AND_DATE, (unsigned long)page, corpctl.type,[Config getOwnID],corpctl.index,corpctl.plantype];
            NSLog(@"url:%@",url);
            return url;
            
        };
        
        self.tableWillReload = ^(NSUInteger count){
            ((count < 10)?(corpctl.lastCell.status =LastCellStatusFinished):(corpctl.lastCell.status = LastCellStatusMore));
        };
        
        self.objClass = [DoneListTableViewController class];
        
        
        self.shouldFetchDataAfterLoaded = YES;
        self.needAutoRefresh = NO;
        self.isRefreshAfterInit  =NO;
        
//        self.needAutoRefresh = YES;
//        self.refreshInterval = 21600;
//        self.kLastRefreshTime = @"CorporationRefreshInterval";
        
    }
    
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
   self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_2"] style:UIBarButtonItemStylePlain  target:self action:@selector(back)];
    //注册cell
    [self.tableView registerClass:[planTableViewCell class] forCellReuseIdentifier:cellId];
    
    
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark - tablview delegate & datadsourse
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _cellheight;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    planTableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath] ;
    
    cell.rightUtilityButtons = nil;
    cell.delegate = self;
    
    
    cell.index = [indexPath row]+1;
    [cell loyoutWithDataAndHeight:self.objects[indexPath.row] height:_cellheight isShow:YES];
    
    
    
  //  [cell loadTime:_limitdateArray[indexPath.row] indexPath:indexPath];
    //  m_date* date = _dateArray[indexPath.row];
    //[cell loadTime:date indexPath:indexPath];
    return cell;
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //获取单个任务信息 查看or编辑
    planTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString * url = [NSString stringWithFormat:@"%@%@%@?planName=%@&userId=%lld",MAIN,LIST,PLAN_GET_ONE,cell.plan.planName,[Config getOwnID]];

    [Utils showHudInView:self.view hint:@"加载中..."];
    
    [[XZHttp sharedInstance]getWithURLString:url parameters:nil success:^(id responseObject) {
        [Utils hideHud];
        NSDictionary* data = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSInteger isSuccess = [(NSString*)data[@"isSuccess"] integerValue];
        // 获取成功 isSuccess == 0
        if(isSuccess != 1){
            NSString* errMeesage = data[@"message"];
         
            [Utils showHUDWithErrorMsg:errMeesage];
            return;
        }else {
            
            
            planMJ* plan = [planMJ mj_objectWithKeyValues:data[@"data"]];
            
            
            detailViewController * detailctl = [detailViewController new];
            detailctl.plan=plan;
            detailctl.editType =2;
            [self presentModalViewController:detailctl animated:YES];
            
        }
        
        
    } failure:^(NSError *error) {
        [Utils showHUDWithError:error];
    }];
    
    

    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSArray*)parseJson:(id)responseObject{
    NSDictionary *jsondict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
    
    NSArray* res =[planMJ mj_objectArrayWithKeyValuesArray:jsondict[@"data"]];
    
    // NSArray * arr = responseObject;
    //NSArray *arr =  [NSKeyedUnarchiver unarchiveObjectWithData:responseObject];
    //    RLMRealm * reaml =[RLMRealm defaultRealm];
    //    [reaml beginWriteTransaction];
    //    NSArray* res = [Corporation createOrUpdateInRealm:reaml withJSONArray:json];
    //    [reaml commitWriteTransaction];
    //    NSLog(@"公司：%@",res);
    //    return res;
    //    
    
    return res;
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
